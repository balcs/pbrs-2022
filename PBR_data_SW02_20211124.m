% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'SW02'; 

d.lat = 34.29688; % Latitude (DD)
d.lon = -117.33979; % Longitude (DD)
d.elv = 1107; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [240
204
179
145
115
89
56]'; 

% Fulcrum z-coordinate (cm below PBR top)
d.h = 173;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.616
0.659
0.678
0.681
0.729
0.733
0.767]';

d.Li = [189.2
187.6
186.7
186.4
184.7
184.4
182.9]';

% 4. Measured Be-10 concentrations

d.Nmi = [12193
10881
11322
11618
16813
17307
18888]; % Be-10 concentration, atoms/g

d.delNmi = [1140
876
907
925
925
881
1852]; % Uncertainty, atoms/g

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




