% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.'

clear all; close all;

% 1. Identifying information

d.PBRName = 'LJ1'; 

d.lat = 34.59448; % Latitude (DD)
d.lon = -117.85328; % Longitude (DD)
d.elv = 944; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [249
467
282
322
362
393
508]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 422;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.508
0.630
0.391
0.244
0.182
0.158
0.665]';

d.Li = [206.8
184.9
221.6
246.6
256.9
257.3
184.7]';

% 4. Measured Be-10 concentrations

d.Nmi = [128122
65952
96060
58786
45139
42124
67040]; % Be-10 concentration, atoms/g

d.delNmi = [3175
1875
2374
1927
1621
1335
1957]; % Uncertainty, atoms/g

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




