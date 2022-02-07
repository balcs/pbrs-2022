% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and run it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'BS1'; 

d.lat = 33.89750; % Latitude (DD)
d.lon = -116.98592; % Longitude (DD)
d.elv = 759; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [234
320
378
348
300
252
198]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 273;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.383
0.392
0.146
0.091
0.287
0.422
0.494]';

d.Li = [232.8
206.3
219.4
213.7
236.6
215.0
215.0]';

% 4. Measured Be-10 concentrations

d.Nmi = [168429
118844
77031
105462
128177
158231
203931]; % Be-10 concentration, atoms/g

d.delNmi = [3940
2789
1938
2900
3107
3522
4105]; % Uncertainty, atoms/g

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




