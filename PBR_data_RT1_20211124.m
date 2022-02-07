% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.'

clear all; close all;

% 1. Identifying information

d.PBRName = 'RT1'; 

d.lat = 33.52070; % Latitude (DD)
d.lon = -116.90687; % Longitude (DD)
d.elv = 734; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [92
192
310
151
231
270
337
376]'; 

% Fulcrum z-coordinate (cm below PBR top)
d.h = 348;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.685
0.455
0.776
0.506
0.400
0.398
0.835
0.764]';

d.Li = [330.4
220.6
173.9
217.0
216.7
209.3
170.6
177.0]';

% 4. Measured Be-10 concentrations

d.Nmi = [234216
126477
208302
139198
116037
119712
241297
180826]; % Be-10 concentration, atoms/g

d.delNmi = [5458
2996
4852
3609
3888
3552
4957
3756]; % Uncertainty, atoms/g

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





