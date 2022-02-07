function create_MCS_window()

%  This creates the window displaying the Monte Carlo results. 
%
% Written by Greg Balco
% Berkeley Geochronology Center
%
% Note: authorship, license, and disclaimers for use of this code are 
% in an accompanying README.md file that should have been distributed 
% with the code. Do not distribute this code without the README.md file. 

% remove existing figures
if ~isempty(findobj('tag','windowMCS'));
    delete(findobj('tag','windowMCS'));
end;


% create figure
f = figure('pos',[0 0 700 750]); % System-specific...
bgc = [0.8 0.8 0.8];
fc = [0.7 0.78 0.7];
set(f,'color',fc);
set(f,'tag','windowMCS');
set(f,'units','pixels');

    
set(f,'name','PBR Monte Carlo uncertainty analysis');


ax1L = 50;
axw = 180;
axspaceH = 40;

ax2L = ax1L+axw+axspaceH;
ax3L = ax2L+axw+axspaceH;

ax1B = 50;
axh = 180;
axspaceV = 25;
ax2B = ax1B + axh + axspaceV;
ax3B = ax2B + axh + axspaceV;

% Create axes and plot objects

% Lower left axis -- E1 vs. E0,mu
a11 = axes('units','pixels','pos',[ax1L ax1B axw axh]); hold on;
set(a11,'tag','axes11');
plot(1,1,'b.','tag','scatter11');
xlabel('E1'); ylabel('E0,mu');

% Lower middle axis -- t0 vs. E0,mu
a12 = axes('units','pixels','pos',[ax2L ax1B axw axh]); hold on;
set(a12,'tag','axes12');
plot(1,1,'b.','tag','scatter12');
xlabel('t0');

% Lower right axis - E0,sp vs. E0,mu
a13 = axes('units','pixels','pos',[ax3L ax1B axw axh]); hold on;
set(a13,'tag','axes13');
plot([0 10000],[0 10000],'r');% Also plot E0mu < E0sp constraint on this axis
plot([0 10000],[0 25000],'y');% Also plot E0mu < E0sp constraint on this axis
plot(1,1,'b.','tag','scatter13');
xlabel('E0,sp');

% Middle left axis -- E1 vs. E0,sp
a21 = axes('units','pixels','pos',[ax1L ax2B axw axh],'tag','axes21'); hold on;
plot(1,1,'b.','tag','scatter21');
ylabel('E0,sp');

% Middle center axis -- t0 vs. E0,sp
a22 = axes('units','pixels','pos',[ax2L ax2B axw axh],'tag','axes22'); hold on;
plot(1,1,'b.','tag','scatter22');

% Upper left axis -- E1 vs. t0
a31 = axes('units','pixels','pos',[ax1L ax3B axw axh],'tag','axes31'); hold on;
plot(1,1,'b.','tag','scatter31');
ylabel('t0');

% Also plot exhumation constraint on this axis
eval(['load ' get(findobj('tag','text_fname'),'string')]);   
% Update exhumation constraint
pt0 = 1:50:60000; % yr;
pE1 = max(d.zi)./pt0; % cm/yr
pE1 = pE1.*1e4; % mMyr;
plot(pE1,pt0./1000,'r');

% Upper right axis -- histogram of t_tip
ahist = axes('units','pixels','pos',[ax3L ax3B axw axh],'tag','axesHist'); hold on;
patch([0 1 1 2 2 3],[0 0 1 1 0 0],'k','tag','lineHist');
xlabel('tTip (ka)'); ylabel('Frequency');

% Progress bar at top
abar = axes('units','pixels','pos',[ax1L ax3B+axh+1.5*axspaceV (3*axw+2*axspaceH) 20],'tag','axesBar'); hold on;
set(abar,'xtick',[],'ytick',[],'ylim',[0 1],'xlim',[0 10]);
gpatch = patch([0 1 1 0 0],[0 0 1 1 0],'g');
set(gpatch,'tag','patchGood','edgecolor','none');
rpatch = patch([9 10 10 9 9],[0 0 1 1 0],'r');
set(rpatch,'tag','patchBad','edgecolor','none');

% Create duplicate x labels for case where lower row of axes is blanked

dupL1 = uicontrol('style','text','backgroundcolor',fc,...
    'pos',[ax1L ax2B-45 axw 20],'string','E1',...
    'horizontalalignment','center','tag','dup_label_1',...
    'visible','off');

dupL1 = uicontrol('style','text','backgroundcolor',fc,...
    'pos',[ax2L ax2B-45 axw 20],'string','t0',...
    'horizontalalignment','center','tag','dup_label_2',...
    'visible','off');

% PBR ID text at top...also something to identify model

text1a = uicontrol('style','text','backgroundcolor',fc,...
    'pos',[ax1L ax3B+axh+1.5*axspaceV+30 (3*axw+2*axspaceH) 30],'string','PBR and model ID text goes here...',...
    'horizontalalignment','left','tag','text_MCS_ID',...
    'fontsize',10);

% Create reporting text

text1b = uicontrol('style','text','backgroundcolor',fc,...
    'pos',[ax1L ax3B+axh+1.5*axspaceV-30 (3*axw+2*axspaceH) 20],'string','Iteration and convergence stats go here...',...
    'horizontalalignment','left','tag','text_MCS_convstats',...
    'fontsize',10);

text2a = uicontrol('style','text','backgroundcolor',fc,...
    'pos',[ax2L ax3B+axspaceV axw 20],'string','t0:',...
    'horizontalalignment','left','tag','text_MCS_t0',...
    'fontsize',10);

text2b = uicontrol('style','text','backgroundcolor',fc,...
    'pos',[ax2L ax3B+axspaceV+30 axw 20],'string','E1',...
    'horizontalalignment','left','tag','text_MCS_E1',...
    'fontsize',10);

text2c = uicontrol('style','text','backgroundcolor',fc,...
    'pos',[ax2L ax3B+axspaceV+60 axw 20],'string','E0,mu:',...
    'horizontalalignment','left','tag','text_MCS_E0mu',...
    'fontsize',10);

text2d = uicontrol('style','text','backgroundcolor',fc,...
    'pos',[ax2L ax3B+axspaceV+90 axw 20],'string','E0,sp:',...
    'horizontalalignment','left','tag','text_MCS_E0sp',...
    'fontsize',10);

text2e = uicontrol('style','text','backgroundcolor',fc,...
    'pos',[ax2L ax3B+axspaceV+120 axw 20],'string','tTip:',...
    'horizontalalignment','left','tag','text_MCS_ttip',...
    'fontsize',10);



% Create stop button

box3 = uicontrol('style','frame','backgroundcolor',fc,...
    'pos',[ax3L ax2B+axspaceV+80 axw 40]);

text3a = uicontrol('style','text','backgroundcolor',fc,...
    'pos',[ax3L+10 ax2B+axspaceV+87 0.5*axw 20],'string','Click to abort:',...
    'horizontalalignment','left',...
    'fontsize',12);

check3 = uicontrol('style','checkbox','backgroundcolor',fc,...
    'pos',[ax3L+0.75*axw ax2B+axspaceV+91 20 20],...
    'tag','checkbox_stop_MCS');









