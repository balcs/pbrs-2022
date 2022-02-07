% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'LJB2'; 

d.lat = 34.60316; % Latitude (DD)
d.lon = -117.85705; % Longitude (DD)
d.elv = 1534; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [18
43
63
87
122]'; 

% Fulcrum z-coordinate (cm below PBR top)
d.h = 99.43;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.944
0.858
0.818
0.866
0.776]';

d.Li = [167.1
175.6
178.1
173.3
181.3]';

% 4. Measured Be-10 concentrations

d.Nmi = [367879
283485
274027
248154
224996]; % Be-10 concentration, atoms/g

d.delNmi = [8314
7334
6352
5894
7499]; % Uncertainty, atoms/g

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




