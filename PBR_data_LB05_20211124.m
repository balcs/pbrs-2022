% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'LB05';

d.lat = 34.59730; % Latitude (DD)
d.lon = -117.86720; % Longitude (DD)
d.elv = 882; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [160
140
121
102
82
61]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 107.57;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.689
0.679
0.697
0.725
0.769
0.849]';

d.Li = [188.2
189.5
189.9
183.8
184.7
175.5]';

% 4. Measured Be-10 concentrations

d.Nmi = [144402
168008
167795
187462
200837
232574]; % Be-10 concentration, atoms/g

d.delNmi = [5987
5704
5172
6787
5258
6328]; % Uncertainty, atoms/g

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



