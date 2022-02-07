% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'GV1'; 

d.lat = 34.27813; % Latitude (DD)
d.lon = -117.23254; % Longitude (DD)
d.elv = 1437; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [89
3
24
49
77
101
130]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 100.45;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.836
0.959
0.919
0.839
0.737
0.750
0.735]';

d.Li = [174.6
163.8
169.7
178.1
188.3
177.6
182.1]';

% 4. Measured Be-10 concentrations

d.Nmi = [198296
448281
327809
240519
193520
166671
116687]; % Be-10 concentration, atoms/g

d.delNmi = [3701
12855
14445
10219
5921
6188
4901]; % Uncertainty, atoms/g

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



