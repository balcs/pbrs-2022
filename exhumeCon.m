function [c,ceq] = exhumeCon(X,k);

% This is the nonlinear constraint function to make sure that all samples
% are actually exhumed. All it does is implement t0.*E1 > max(zi).
%
% Written by Greg Balco
% Berkeley Geochronology Center
%
% Note: authorship, license, and disclaimers for use of this code are 
% in an accompanying README.md file that should have been distributed 
% with the code. Do not distribute this code without the README.md file. 


% Convert to real units

t0 = X(4) * 1000; % Now in yr
E0s = X(1) * 1e-4; % Now in cm/yr
E0m = X(2) * 1e-4; % Now in cm/yr
E1 = X(3) * 1e-4; % Now in cm/yr

c = k - t0.*E1;
ceq = [];