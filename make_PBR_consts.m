function out = make_PBR_consts()

% This function creates and saves a structure with relevant constants
% for PBR age optimization code. 
%
% Syntax: make_PBR_consts
% (no arguments)
%
% This has been modified June 23 2020 to use updated values. 
%
% Note: removed Al-26 constants, because there are no PBRs that have Al-26
% data. 
%
% Written by Greg Balco
% Berkeley Geochronology Center
%
% Note: authorship, license, and disclaimers for use of this code are 
% in an accompanying README.md file that should have been distributed 
% with the code. Do not distribute this code without the README.md file. 


% 0. Identifying data. 
consts.version = 'June 2020';
consts.prepdate = fix(clock);


% 1. Decay constant

consts.l10 = -log(0.5)./1.387e6; % Chmeleff/Korschinek value
dldt = -log(0.5).*(1.387e6^-2);
consts.dell10 = sqrt((dldt.*0.012e6)^2);

% 2. Effective attenuation length for spallation in rock
% Commonly accepted value: 160 g/cm2
% Note: this has to be the same thing that is used in the shielding code. 

consts.Lsp = 160; 

% 3. Be-10 production rates due to spallation. 
% This matches default in online exposure age calculators, which is
% based on CRONUS "primary" calibration data.
% Note PBR code uses non-time-dependenent 'St' scaling only. 

consts.P10_ref_St = 4.086;
consts.delP10_ref_St = consts.P10_ref_St.*0.079; 

% 4. Muon interaction cross-sections. These are now from Balco (2017). 

% Be-10, model 1A
consts.mc10.Natoms = 2.006e22;
consts.mc10.k_neg = 0.00191 .* 0.704 .* 0.1828; % From BCO fit
consts.mc10.sigma0 = 0.280e-30; % From BCO fit

consts.mc10.delk_neg = 0; % Not used for this application
consts.mc10.delsigma0 = 0; % Not used for this application

% 5. Switches to constrain relationship of E0,mu and E0,sp. These are
% inequality constraint matrices needed by fmincon(). See the documentation
% for that function. Basically, the constraints are conA*X <= conB. 

% This is no constraint
%consts.conA = []; 
%consts.conB = [];

% This case forces E0,mu < E0,sp
%consts.conA = [-1 1 0 0]; 
%consts.conB = [0];

% This case should be E0,mu < 2.5*E0,sp
consts.conA = [-2.5 1 0 0]; 
consts.conB = [0];

% Finish up

save PBR_consts consts

disp(['Be-10 constants version ' consts.version]);
disp('Saved'); 


