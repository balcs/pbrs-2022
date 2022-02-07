% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'GV2'; 

d.lat = 34.27878; % Latitude (DD)
d.lon = -117.24710; % Longitude (DD)
d.elv = 1510; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [169
69
0
117]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 150;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.50
0.90
0.96
0.60]';

d.Li = [223
171
160
225]';

% 4. Measured Be-10 concentrations

d.Nmi = [163298
410286
688326
207599]; % Be-10 concentration, atoms/g

d.delNmi = [3821
6726
15979
4366]; % Uncertainty, atoms/g

% 5. Other information

% Rock density
d.rho = 2.65; % g/cm3

% Assumed surface erosion rates after exhumation
d.Esi = [0 0 2e-4 0]; % cm/yr


% -------- end data entry ------------

% do production related calculations
% Enter 1 as second arg to get plotting, zero to suppress

d  = get_P_params(d,1);


% Save data in .mat-file with same name

fname = [mfilename '.mat'];
eval(['save ' fname ' d']);
disp([fname ' saved']);

