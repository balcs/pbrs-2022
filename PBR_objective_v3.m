function out = PBR_objective_v3(X,d,c,control)

% Objective function for PBR forward model optimization
%
% out = PBR_objective(X,d,consts,control);
% 
% X has four parameters: 
%   X(1) is the pre-emergence erosion rate to which spallogenic production 
%       is equilibrated(m/Myr) (e_{0,sp})
%   X(2) is the pre-emergence erosion rate to which muon production 
%       is equilibrated(m/Myr) (e_{0,mu})
%   X(3) is the post-emergence exhumation rate (m/Myr) (e_{1})
%   X(4) is the time emergence begins (Kyr) (t_{0})
%
% d is the sample data structure that is generated by one of the PBR data
% generating scripts. See one of those. 
%
% also d.mask...indices of samples to use
%
% c is the consts structure. See make_PBR_consts.m. 
%
% control is a data structure
%
%   control.returnData = 1 returns the predicted nuclide concentrations
%   control.returnData = 0 or absent returns reduced chi-squared
% 
% Note whether is 3- or 4-parameter optimization is handled upstream by the
% optmizer. So four parameters are always supplied, it is just that
% sometimes they are fixed or locked together. 
%
% This is a complete rewrite to use look-up tables, June 2020.
% There are no more different options for muons. Always uses LUT
% integration scheme for initial inventory and subsurface production rates.
% 
% Copyright: Greg Balco
% Berkeley Geochronology Center
% 2010-2020
% 
% GB thinks this is correct as of 20200625. 
%
% Note: authorship, license, and disclaimers for use of this code are 
% in an accompanying README.md file that should have been distributed 
% with the code. Do not distribute this code without the README.md file. 


% Default control parameters

if ~isfield(control,'returnData')
    control.returnData = 0;
end

% Convert to real units

E0s = X(1) * 1e-4; % Supplied as m/Myr, convert to cm/yr
%E0m = X(2) * 1e-4; % Supplied as m/Myr, convert to cm/yr
E0m = X(2); % leave E0mu in m/Myr for interpolation into precalculated Nmu

E1 = X(3) * 1e-4; % Supplied as m/Myr, convert to cm/yr

t0 = X(4) * 1000; % Supplied as kyr, convert to yr for calculations

% Display warning if all samples are not actually exhumed. 
% Note: this is also constrained upstream in the optimizer, so you should
% never get a result that violates this. But it is interesting to see when
% the optimizer is fishing around in the forbidden zone. 

if t0*E1 < (max(d.zi) - 0.1) % leave some tolerance for the optimizer
    disp(['Not fully exhumed... t0 = ' num2str(t0) '; E1 = ' num2str(E1) '; gets ' num2str(t0.*E1) ' cm; needs ' num2str(max(d.zi))]);
end

% Start forward model of nuclide concentrations for given parameters.
% Basically we want an n-element vector of nuclide concentrations, where n
% is the number of samples. 

% First, figure production due to spallation. 
    
% N0isp is production-erosion-decay equilibrium for spallation. This is
% Equation (1) in the paper. 
N0isp = ((d.Psp_0.*exp(-d.zi.*d.rho./c.Lsp))./(c.l10 + E0s.*d.rho/c.Lsp));

% N1isp is spallogenic nuclide concentration produced during exhumation
% of this sample, calculated at the time the sample is exhumed. 
% This is the first term of Equation (7) in the paper. 

t1i = d.zi./E1; % Duration of exhumation
N1isp = ((d.Psp_0.*d.S0i)./(c.l10+E1.*d.rho./d.Li)).*(1-exp(-t1i.*(c.l10+E1.*d.rho./d.Li)));

% N2isp is the spallogenic nuclide concentration produced after the sample
% is exhumed, calculated at the present time. 
% This is the first term of Equation (8) in the paper. 
t2i = t0 - t1i; % Time since exhumation
N2isp = ((d.Psp_0.*d.S0i)./(c.l10+d.Esi.*d.rho./c.Lsp)).*(1-exp(-t2i.*(c.l10+d.Esi.*d.rho./c.Lsp)));
    
% Figure total spallogenic nuclide concentration
% This adds up the above three things with appropriate radioactive decay
% corrections to bring everything up to the present. This is like Equation
% (9) in the paper, only just for spallation. 

Nisp = N0isp.*exp(-t0.*c.l10) + N1isp.*exp(-t2i.*c.l10) + N2isp;

% Now, figure production due to muons.

% Initialize. Preallocating the memory just speeds things up a tiny bit. 
N0imu = zeros(size(N0isp)); N1imu = N0imu; 

% N0,mu is the integral from zero to infinity of
% Pmu(E0mu*t)*exp(-lambda10.*t). 
% In the paper, this is approximated by Equation (2). However, now we have
% already calculated it when preparing the .mat-file for each PBR, so we 
% just need to look up the correct result for the input value of E0,mu from
% the precalculated results. 
%
% Note must restrict upstream to pre-integrated bounds, which are 1 m/yr
% (100 cm/Myr) to 1000 m/Myr (100,000 cm/Myr). The optmizer should be set
% with these restrictions. 

for a = 1:length(d.zi)
    % Note that the interpolation is in log-log. 
    N0imu(a) = exp(interp1(log(d.eM),log(d.N10e(a,:)),log(E0m)));
    % Note this could probably be a single interp2 statement
    if isnan(N0imu(a))
        % This shouldn't happen, but if it does it is hard to figure out
        % what happened without a defined error. 
       error(['PBR_objective_v3.m: NaN from N0,mu interpolation. E0m is ' sprintf('%0.2f',E0m) ' m/Myr']); 
    end
end

% N1mu is the integral from zero to t1 of Pmu(E1.*rho.*t).*exp(-l10.*t).
% (assuming E1 is in cm/yr). 
% In the paper this is approximated by the second half of Equation (7). 
% Here we already calculated values for Pmu as a function of depth, so we 
% will just do the integral numerically by looking up values from the 
% precalculated table. Note that shielding is not included in this. 

for a = 1:length(d.zi)
    if d.zi > 0
        % Interpolation is linear. For this application, probably no point
        % to doing it in log-log. 
        N1imu(a) = integral(@(t) exp(-c.l10.*t).*interp1(d.zmug,d.Pmu,(E1.*d.rho.*t)),0,t1i(a));
    else
        % For samples on top of the rock, this is just zero.  
        N1imu(a) = 0;
    end
end


% N2imu is production after exhumation. For purposes of a surface 
% weathering rate after exhumation, this is simplified with a single 
% attenuation length for near-surface muon production, which was calculated
% earlier in making the .mat file for each PBR. Of course this is wrong for
% samples that are on the sides of rocks, which is most of them. But it is 
% pretty much irrelevant for small amounts of erosion. 
% This is like the second term in Equation (8) in the paper, but with only 
% one exponential, and with erosion included. 
% Note no shielding is applied to muon production here either.

N2imu = (d.Pmu(1)./(c.l10+d.Esi.*d.rho./d.Lmu)).*(1-exp(-t2i.*(c.l10+d.Esi.*d.rho./d.Lmu)));

% Sum up muon production, same as spallogenic production above, correcting
% for radioactive decay to the present. 

Nimu = N0imu.*exp(-t0.*c.l10) + N1imu.*exp(-t2i.*c.l10) + N2imu;

% Sum spallogenic and muon production. That gives the total predicted
% concentration for all samples for the input values of the paperamters. 
Ni = Nimu + Nisp;
   
% Figure misfit between predicted and measured. 
% This is Equation 10 in the paper, which is basically just the chi-squared statistic. 

Mi = ((Ni' - d.Nmi)./d.delNmi).^2; 
M = sum(Mi(d.mask)); % Note only sum misfits for samples included in d.mask.

% Report

if control.returnData == 1
    % Return complete predicted nuclide concentrations and diagnostics. 
    % Needed when plotting predicted against observed results. 
    out.Ni = Ni;
    out.Nisp = Nisp;
    out.Mi = Mi;
    out.plotMi = ((Ni' - d.Nmi)./d.delNmi); % not squared, needed for plotting
    out.N0isp = N0isp.*exp(-t0.*c.l10);
    out.N1isp = N1isp.*exp(-t2i.*c.l10);
    out.N2isp = N2isp;
    out.muons = 'Full LUT';
    out.N0imu = N0imu.*exp(-t0.*c.l10);
    out.N1imu = N1imu.*exp(-t2i.*c.l10);
    out.N2imu = N2imu;
    out.Nimu = Nimu;
    out.M = M;
else
    % Return only the misfit value. 
    % Needed when in use by optimizer. 
    out = M; 
end

