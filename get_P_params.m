function out = get_P_params(in,plotFlag)

% This function accepts a PBR data structure as the input argument, 
% calculates a bunch of things having to do with production rates, and 
% returns an expanded data structure. 
%
% This only does things related to Be-10. At the moment there aren't any
% PBRs with Al-26 data. 
% 
% Requires NCEPatm_2, stone2000, and P_mu_total_alpha1. 
%
% Greg Balco -- Berkeley Geochronology Center -- June, 2020
% 
% GB thinks this is correct as of 20200625. 
%
% Note: authorship, license, and disclaimers for use of this code are 
% in an accompanying README.md file that should have been distributed 
% with the code. Do not distribute this code without the README.md file. 


if nargin < 2; plotFlag = 0; end

% The input arg is a data structure (in) that was prepared by one of
% the wrapper scripts, e.g. 'PBR_data_GV2.m'. The data structure contains
% all the location/geometry/nuclide concentration/etc. info for the rock. 
% This script just adds more stuff to the data structure. 

% load consts. Note: can't pass different consts. Thus, hard to pass
% production rate uncertainty. Maybe fix that later. 

load PBR_consts;
 
%% Step 0. Calculate things having to do with spallogenic production. 

% Elevation to pressure

in.pressure = ERA40atm(in.lat,in.lon,in.elv); 

% Surface production rate due to spallation

in.Psp_0 = consts.P10_ref_St.*stone2000(in.lat,in.pressure,1);
in.delPsp_0 = in.Psp_0.*consts.delP10_ref_St./consts.P10_ref_St;

%% Step 1. Integrate muon production from zero to infinity for a full range
% of erosion rates, for all samples. 
% This allows the optimization code to just pick from a
% precalculated look-up table for N0,mu without having to do any calculations.  

% Set erosion rate range
in.eM = logspace(-1,4,25); % erosion rate: 0.1 m/Myr to 10000 m/Myr;
in.eg = in.eM.*1e-4.*in.rho; % Same thing in mass units (g/cm2/yr)

% Note that downstream code has to keep erosion rates in the range 0.1-10k
% m/Myr. 

% Set up output matrix. Rows are samples, columns are erosion rates. 

in.N10e = zeros(length(in.zi),length(in.eg)); 

disp('Doing integration for muon-produced inventory as a function of erosion rate:')
for row = 1:length(in.zi) % Loop through samples
    disp(['Sample ' int2str(row)]);
    this_mass_depth = in.zi(row).*in.rho; % Determine mass depth of this sample
    for col = 1:length(in.eg) % Loop through erosion rates
        % Integrate P_mu(zi*rho + eg*t)*exp(-lt) from t = 0 to t = "infinity"
        tmax10 = min([(8 .* -log(0.5)./consts.l10) (199999./in.eg(col))]); % "Infinity" is 200,000 g/cm2 or 8 half-lives
        in.N10e(row,col) = integral(@(t) P_mu_total_alpha1(this_mass_depth+(in.eg(col).*t),in.pressure,consts.mc10).*exp(-consts.l10.*t),0,tmax10);
        disp([sprintf('%0.1f',in.eM(col)) ' m/Myr']);
    end
end
disp('Done integrating.')

%% Step 2. Calculate muon production rates in depth range of samples. 
% This just creates a precalculated look-up table that the optimizer can use
% when it wants the production rate at a certain depth. 

disp('Now precalculating production rates due to muons in sample depth range.')

in.zmu = linspace(0,max(in.zi),100); % Linear spacing within sample depth range
in.zmug = in.zmu.*in.rho; % In mass depth
for a = 1:length(in.zmu)
    % Populate vector of P_mu. 
    in.Pmu(a) = P_mu_total_alpha1(in.zmug(a),in.pressure,consts.mc10);
end

% Also calculate a Lmu to be used as approximate value for post-exhumation
% surface erosion. Of course this is wrong anyway if the surface isn't
% flat. 

fitx = in.zmug(1:5); fity = log(in.Pmu(1:5));
p1 = polyfit(fitx,fity,1);
in.Lmu = -1./p1(1);


disp('Done calculating.')

out = in;

%% Plotting

if plotFlag == 1
    
    figure('pos',[300 500 400 800]);
    subplot(2,1,1);
    for a = 1:length(in.zi)
        if a == 1; c = 'k'; else; c = 'r';end
        plot(in.eM,in.N10e(a,:),'r',in.eM,in.N10e(a,:),[c '.']); hold on;
    end
    grid on; 
    xlabel('Erosion rate (m/Myr)');
    ylabel('Muon-produced nuclide inventory (atoms/g/yr)');
    set(gca,'xscale','log','yscale','log'); grid on;
    title(in.PBRName);
   
    subplot(2,1,2);
    plot(in.Pmu,in.zmu,'b',in.Pmu,in.zmu,'bo');
    set(gca,'ydir','reverse');
    xlabel('Pmu (atoms/g/yr)');
    ylabel('Depth (cm)');
    hold on;
    xx = get(gca,'xlim');
    for a = 1:length(in.zi)
        plot(xx,[1 1].*in.zi(a),'k');
    end
    set(gca,'xlim',xx);
    grid on
end

