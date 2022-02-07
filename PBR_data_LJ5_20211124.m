% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'LJ5'; 

d.lat = 34.59454; % Latitude (DD)
d.lon = -117.85199; % Longitude (DD)
d.elv = 931; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [261
235
210
169
132
94
52]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 192;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.547
0.598
0.625
0.618
0.676
0.711
0.781]';

d.Li = [192.3
190.3
188.7
189.0
186.8
185.1
182.3]';

% 4. Measured Be-10 concentrations

d.Nmi = [149323
251321
295122
295113
383238
423613
481971]; % Be-10 concentration, atoms/g

d.delNmi = [3060
5142
5926
5917
7671
8469
9625]; % Uncertainty, atoms/g

% 5. Other information

% Rock density
d.rho = 2.65; % g/cm3

% Assumed surface erosion rates after exhumation
d.Esi = [0 0 0 0 0 0 0]; % cm/yr


% -------- end data entry ------------

% do production related calculations
% Enter 1 as second arg to get plotting, zero to suppress

d  = get_P_params(d,1);


% Save data in .mat-file with same name

fname = [mfilename '.mat'];
eval(['save ' fname ' d']);
disp([fname ' saved']);




