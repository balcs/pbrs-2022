% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'LJB1'; 

d.lat = 34.60352; % Latitude (DD)
d.lon = -117.85754; % Longitude (DD)
d.elv = 1550; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [48
82
118
148
198
250
274]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 229.646;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.946
0.764
0.644
0.579
0.628
0.774
0.863]';

d.Li = [163.4
188.0
197.4
228.5
196.8
178.2
174.5]';

% 4. Measured Be-10 concentrations

d.Nmi = [355487
277812
207621
192579
156852
141536
192888]; % Be-10 concentration, atoms/g

d.delNmi = [11932
6411
6342
6150
4490
4715
5065]; % Uncertainty, atoms/g

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




