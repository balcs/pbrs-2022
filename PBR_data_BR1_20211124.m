% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'BR1'; 

d.lat = 33.59285; % Latitude (DD)
d.lon = -116.92530; % Longitude (DD)
d.elv = 778; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [116.3
147.0
178.1
209.9
238.5
287.2
329.3]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 265;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.791
0.621
0.656
0.435
0.437
0.581
0.782]';

d.Li = [183.9
209.0
196.5
227.9
218.0
191.2
177.5]';

% 4. Measured Be-10 concentrations

d.Nmi = [305795
269295
189452
143274
126507
218176
240997]; % Be-10 concentration, atoms/g

d.delNmi = [6141
5972
5705
4697
3129
4239
9819]; % Uncertainty, atoms/g

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




