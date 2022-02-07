% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'UCR1'; 

d.lat = 33.96516; % Latitude (DD)
d.lon = -117.32011; % Longitude (DD)
d.elv = 403; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [87
66
42
0]'; 

% Fulcrum z-coordinate (cm below PBR top)
d.h = 56.6;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.649
0.658
0.709
0.746]';

d.Li = [188.7
189.9
186.0
180.2]';

% 4. Measured Be-10 concentrations

d.Nmi = [49122
47037
55697
66807]; % Be-10 concentration, atoms/g

d.delNmi = [1953
2433
2612
3910]; % Uncertainty, atoms/g

% 5. Other information

% Rock density
d.rho = 2.65; % g/cm3

% Assumed surface erosion rates after exhumation
d.Esi = [0 0 0 0]; % cm/yr


% -------- end data entry ------------

% do production related calculations
% Enter 1 as second arg to get plotting, zero to suppress

d  = get_P_params(d,1);

% Save data in .mat-file with same name

fname = [mfilename '.mat'];
eval(['save ' fname ' d']);
disp([fname ' saved']);




