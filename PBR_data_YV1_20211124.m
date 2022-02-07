% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'YV1';

d.lat = 34.11756; % Latitude (DD)
d.lon = -116.50897; % Longitude (DD)
d.elv = 1280; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [296
267
235
208
176
145
116
85]'; 

% Fulcrum z-coordinate (cm below PBR top)
d.h = 212;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.586
0.610
0.639
0.657
0.659
0.663
0.695
0.755]';

d.Li = [191.1
189.6
187.9
187.4
186.9
187.4
186.2
183.6]';

% 4. Measured Be-10 concentrations

d.Nmi = [21562
21314
22128
21364
30003
27295
35911
42155]; % Be-10 concentration, atoms/g

d.delNmi = [3326
3552
2814
2622
2198
2088
2809
2446]; % Uncertainty, atoms/g

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




