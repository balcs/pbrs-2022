% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'PNT01'; 

d.lat = 34.13845; % Latitude (DD)
d.lon = -116.47844; % Longitude (DD)
d.elv = 1125; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [26
55
84
107
139
2
195]'; 

% Fulcrum z-coordinate (cm below PBR top)
d.h = 119;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.804
0.773
0.720
0.704
0.673
0.816
0.743]';

d.Li = [181.4
182.5
185.0
185.4
186.8
180.9
184.7]';

% 4. Measured Be-10 concentrations

d.Nmi = [148666
112451
94176
81941
76738
185099
73686]; % Be-10 concentration, atoms/g

d.delNmi = [3760
4909
2908
3756
2902
4663
3098]; % Uncertainty, atoms/g

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




