% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'PP1'; 

d.lat = 33.78798; % Latitude (DD)
d.lon = -117.24377; % Longitude (DD)
d.elv = 497; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [19
245
285
343
180
273
138
410]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 331.8;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.980
0.221
0.145
0.224
0.567
0.164
0.713
0.312]';

d.Li = [155.2
298.7
327.3
240.0
210.4
318.1
193.2
210.9]';

% 4. Measured Be-10 concentrations

d.Nmi = [626127
252954
62818
63726
329342
86837
548796
52880]; % Be-10 concentration, atoms/g

d.delNmi = [12795
5903
1190
1610
7836
2445
14900
1845]; % Uncertainty, atoms/g

% 5. Other information

% Rock density
d.rho = 2.65; % g/cm3

% Assumed surface erosion rates after exhumation
d.Esi = [0 0 0 0 0 0 0 0]; % cm/yr


% -------- end data entry ------------

% do production related calculations
% Enter 1 as second arg to get plotting, zero to suppress

d  = get_P_params(d,1);

% Save data in .mat-file with same name

fname = [mfilename '.mat'];
eval(['save ' fname ' d']);
disp([fname ' saved']);




