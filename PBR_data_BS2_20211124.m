% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'BS2'; 

d.lat = 33.89654; % Latitude (DD)
d.lon = -116.98470; % Longitude (DD)
d.elv = 734; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [111
90
71
51
30
11]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 98.36;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.743
0.689
0.712
0.766
0.861
0.933]';

d.Li = [187.5
202.4
200.8
196.2
175.7
168.4]';

% 4. Measured Be-10 concentrations

d.Nmi = [44776
45811
48354
59126
61869
76788]; % Be-10 concentration, atoms/g

d.delNmi = [2345
2342
2482
2893
4548
3898]; % Uncertainty, atoms/g

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

