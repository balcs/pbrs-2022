% This script creates a .mat-file with observables needed for PBR age
% calculations. Create one of these for each PBR and execute it.  

% This contains only observables. Calculation parameters set elsewhere. 

% Basically, everything is stuffed into a structure called 'd.' 

clear all; close all;

% 1. Identifying information

d.PBRName = 'PI1'; 

d.lat = 34.30546; % Latitude (DD)
d.lon = -117.22670; % Longitude (DD)
d.elv = 1679; % Elevation (m)

% 2. PBR geometry (typically from photogrammetric shape model)

% z-coordinates of samples (cm below PBR top)
d.zi = [164
129
107
94
59
29]'; 
% Fulcrum z-coordinate (cm below PBR top)
d.h = 104;

% 3. Shielding factors (typically from Monte Carlo shielding code)
% S0i is the present shielding factor for sample i
% Li is the attenuation length as sample i gets covered with soil

d.S0i = [0.720
0.759
0.779
0.689
0.763
0.821]';

d.Li = [185.2
183.8
181.9
187.2
183.0
179.3]';

% 4. Measured Be-10 concentrations

d.Nmi = [140821
190768
230355
220950
336163
413447]; % Be-10 concentration, atoms/g

d.delNmi = [2912
3364
4041
4621
5889
6463]; % Uncertainty, atoms/g

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





