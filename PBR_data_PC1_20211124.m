% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'PC1'; 

d.lat = 34.38603; % Latitude (DD)
d.lon = -118.04983; % Longitude (DD)
d.elv = 2052; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [305
246
181
137
375]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 309;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.605
0.624
0.732
0.690
0.694]';

d.Li = [187.6
197.7
184.7
192.1
179.3]';

% 4. Measured Be-10 concentrations

d.Nmi = [217882
295087
377744
304521
323340]; % Be-10 concentration, atoms/g

d.delNmi = [5090
6870
7837
9574
10808]; % Uncertainty, atoms/g

% 5. Other information

% Rock density
d.rho = 2.65; % g/cm3

% Assumed surface erosion rates after exhumation
d.Esi = [0 0 0 0 0]; % cm/yr


% -------- end data entry ------------

% do production related calculations
% Enter 1 as second arg to get plotting, zero to suppress

d  = get_P_params(d,1);

% Save data in .mat-file with same name

fname = [mfilename '.mat'];
eval(['save ' fname ' d']);
disp([fname ' saved']);




