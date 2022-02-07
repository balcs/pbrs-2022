% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'MR1'; 

d.lat = 33.80942; % Latitude (DD)
d.lon = -117.25282; % Longitude (DD)
d.elv = 534; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [112
140
175
224
254
303]'; 

% Fulcrum z-coordinate (cm below PBR top)
d.h = 224.55;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.805
0.729
0.631
0.757
0.689
0.637]';

d.Li = [181.0
197.9
207.5
180.6
184.8
188.5]';

% 4. Measured Be-10 concentrations

d.Nmi = [174457
135758
91928
65950
49022
51622]; % Be-10 concentration, atoms/g

d.delNmi = [6264
7400
3406
2820
3630
7518]; % Uncertainty, atoms/g

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



