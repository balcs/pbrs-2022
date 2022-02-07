% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'PI2'; 

d.lat = 34.29855; % Latitude (DD)
d.lon = -117.21806; % Longitude (DD)
d.elv = 1463; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [290
255
226
201
167
133]'; 

% Fulcrum z-coordinate (cm below PBR top)
d.h = 235;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.761
0.782
0.840
0.591
0.646
0.721]';

d.Li = [181.6
180.6
172.7
192.2
188.9
184.4]';

% 4. Measured Be-10 concentrations

d.Nmi = [78856
97466
142600
156450
171435
252463]; % Be-10 concentration, atoms/g

d.delNmi = [2010
3228
3125
3418
3302
5309]; % Uncertainty, atoms/g

% 5. Other information

% Rock density
d.rho = 2.65; % g/cm3

% Assumed surface erosion rates after exhumation
d.Esi = [0 0 0 0 0 0]; % cm/yr


% -------- end data entry ------------

% do production related calculations
% Enter 1 as second arg to get plotting, zero to suppress

d  = get_P_params(d,1);

% Save data in .mat-file with same name

fname = [mfilename '.mat'];
eval(['save ' fname ' d']);
disp([fname ' saved']);



