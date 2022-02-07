function out = PBR_sample_window(fname);

% Builds sample info window for PBR GUI
%
% Written by Greg Balco
% Berkeley Geochronology Center
%
% Note: authorship, license, and disclaimers for use of this code are 
% in an accompanying README.md file that should have been distributed 
% with the code. Do not distribute this code without the README.md file. 


% remove existing

delete(findobj('tag','windowSamples'));

% Load data

eval(['load ' fname]); 

ns = length(d.Nmi);

rht = 23;

fht = 5 + rht*(ns+1);

% Pop figure based on position of existing

f1pos = get(findobj('tag','windowMain'),'pos');

thispos = [f1pos(1) f1pos(2)-fht-50 640 fht];

f = figure('pos',thispos); 
bgc = [0.8 0.8 0.8];
set(f,'tag','windowSamples');
set(f,'name',['Sample-specific data: ' d.PBRName]);

% Line 1

text11 = uicontrol('style','text','pos',[5 fht-30 55 20],...
	'fontsize',10,'string','#',...
	'backgroundcolor',bgc,...
	'horizontalalignment','center');
    
text12 = uicontrol('style','text','pos',[65 fht-30 75 20],...
	'fontsize',10,'string','Z (cm)',...
    'backgroundcolor',bgc,...
    'horizontalalignment','center');

text13 = uicontrol('style','text','pos',[145 fht-30 75 20],...
	'fontsize',10,'string','S0',...
    'backgroundcolor',bgc,...
    'horizontalalignment','center');

text14 = uicontrol('style','text','pos',[225 fht-30 80 20],...
	'fontsize',10,'string','L (g/cm2)',...
    'backgroundcolor',bgc,...
    'horizontalalignment','center');

text15 = uicontrol('style','text','pos',[310 fht-30 90 20],...
	'fontsize',10,'string','N (atoms/g)',...
    'backgroundcolor',bgc,...
    'horizontalalignment','center');

text16 = uicontrol('style','text','pos',[405 fht-30 75 20],...
	'fontsize',10,'string','+/-',...
    'backgroundcolor',bgc,...
    'horizontalalignment','center');

text17 = uicontrol('style','text','pos',[485 fht-30 75 20],...
	'fontsize',10,'string','Es (cm/yr)',...
    'backgroundcolor',bgc,...
    'horizontalalignment','center');

text18 = uicontrol('style','text','pos',[575 fht-30 60 20],...
	'fontsize',10,'string','OK?',...
    'backgroundcolor',bgc,...
    'horizontalalignment','center');

% Loop


% Fill figure with stuff
for a = 1:ns;
    col1(a) = uicontrol('style','text','pos',[5 fht-30-rht*a 55 20],...
        'fontsize',10,'string',int2str(a),...
        'backgroundcolor',bgc,...
        'horizontalalignment','center');
    
    col2(a) = uicontrol('style','text','pos',[65 fht-30-rht*a 75 20],...
        'fontsize',10,'string',sprintf('%0.1f',d.zi(a)),...
        'backgroundcolor',bgc,...
        'horizontalalignment','center');
    
    col3(a) = uicontrol('style','text','pos',[145 fht-30-rht*a 75 20],...
        'fontsize',10,'string',sprintf('%0.3f',d.S0i(a)),...
        'backgroundcolor',bgc,...
        'horizontalalignment','center');
    
    col4(a) = uicontrol('style','text','pos',[225 fht-30-rht*a 80 20],...
        'fontsize',10,'string',sprintf('%0.3f',d.Li(a)),...
        'backgroundcolor',bgc,...
        'horizontalalignment','center');
    
    col5(a) = uicontrol('style','text','pos',[310 fht-30-rht*a 90 20],...
        'fontsize',10,'string',sprintf('%0.3e',d.Nmi(a)),...
        'backgroundcolor',bgc,...
        'horizontalalignment','center');
    
    col6(a) = uicontrol('style','text','pos',[405 fht-30-rht*a 75 20],...
        'fontsize',10,'string',sprintf('%0.3e',d.delNmi(a)),...
        'backgroundcolor',bgc,...
        'horizontalalignment','center');
    
    col7(a) = uicontrol('style','text','pos',[485 fht-30-rht*a 75 20],...
        'fontsize',10,'string',sprintf('%0.2e',d.Esi(a)),...
        'backgroundcolor',bgc,...
        'horizontalalignment','center');
    
    ctag = ['checkbox_use_' int2str(a)];
    
    col8(a) = uicontrol('style','checkbox','pos',[595 fht-25-rht*a 20 20],...
       'tag',ctag,'backgroundcolor',bgc,'value',1,...
       'callback','PBR_model_window(''runOnce'')');
    
    
end;

% Update use vector

PBR_model_window('updateUse');

