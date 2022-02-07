function nout = PBR_model_window(action)

% This code creates the control and plot windows for the PBR optimizer.
% It also has the callbacks. 
%
% Written by Greg Balco
% Berkeley Geochronology Center
%
% Note: authorship, license, and disclaimers for use of this code are 
% in an accompanying README.md file that should have been distributed 
% with the code. Do not distribute this code without the README.md file. 


if nargin < 1
    
    % Case create a new figure

    close all; % wipe out existing figures
    
    % ------ PART 1 -- SET UP CONTROL WINDOW -----
    
    % create figure; set global appearance params
  
    
    fht = 385;
    f = figure('pos',[1 1600 640 fht]); % System-specific...
    bgc = [0.8 0.8 0.8];
    fc = [0.6 0.75 0.6];
    set(f,'color',fc);
    set(f,'tag','windowMain');

    
    set(f,'name','PBR exposure model wrapper');
    
    % -------- HEADER - TITLE AND RESET BUTTON -----
    
    text0 = uicontrol('style','text','pos',[10 fht-35 400 25],...
        'string','PBR exposure model wrapper',...
        'fontsize',14,'backgroundcolor',fc,...
        'horizontalalignment','left');
    
    button0 = uicontrol('style','pushbutton','pos',[520 fht-30 100 25],...
        'string','Reset','callback','PBR_model_window(''reset'')',...
        'backgroundcolor',fc);
    
    % ----- BOX CONTAINING FIRST TWO ROWS ------
    
    box1234 = uicontrol('style','frame','pos',[5 fht-100 630 65],...
        'backgroundcolor',bgc);
    
    % ----- TOP ROW - DATA FILE OPEN -----------
    

    text11 = uicontrol('style','text','pos',[15 fht-70 75 20],...
        'fontsize',10,'string','2. Data file:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    text12 = uicontrol('style','text','pos',[95 fht-90 410 40],...
        'fontsize',10,'string','--',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag','text_fname');
    
    button1 = uicontrol('style','pushbutton','pos',[520 fht-68 100 25],...
        'string','Choose file','callback','PBR_model_window(''loadFile'')',...
        'backgroundcolor',bgc);
    
    % -------------------------------------------
    
    % ------------ NOTHING IN ROW 2 -------------
    
   
    
    % -------------------------------------------
    
    % ------- BOX CONTAINING ROWS 3-6 -----------
    
    % Defaults for input params
    ipd = [10 10 1000 20000];
    
    box34 = uicontrol('style','frame','pos',[5 fht-230 630 125],...
        'backgroundcolor',bgc);
    
    % ------ ROW 3 - E0, sp ------
    
    text31 = uicontrol('style','text','pos',[15 fht-135 100 20],...
        'fontsize',10,'string','3. Parameters:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    text32 = uicontrol('style','text','pos',[125 fht-135 280 20],...
        'fontsize',10,'string','Init apparent erosion (spallation; E0,sp) (m/Myr):',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    edit3 = uicontrol('style','edit','pos',[520 fht-135 100 25],...
        'string',sprintf('%0.2f',ipd(1)),'callback','PBR_model_window(''runOnce'')',...
        'backgroundcolor',bgc,'tag','input_E0sp');
    
    menu3 = uicontrol('style','popupmenu','pos',[405 fht-136 110 25],...
        'backgroundcolor',bgc,'tag','menu_E0sp','string','Free|Fixed',...
        'callback','PBR_model_window(''checkParams'')');
    
    % ------------------------------------------
    
    % ------ ROW 4 - E0,mu  and random button ------
    
    button4 = uicontrol('style','pushbutton','pos',[12 fht-165 100 25],...
        'backgroundcolor',bgc,'string','Random guess','callback',...
        'PBR_model_window(''random_values'')');
    
    text42 = uicontrol('style','text','pos',[125 fht-165 280 20],...
        'fontsize',10,'string','Init apparent erosion (muons; E0,mu) (m/Myr):',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    edit4 = uicontrol('style','edit','pos',[520 fht-165 100 25],...
        'string',sprintf('%0.2f',ipd(2)),'callback','PBR_model_window(''runOnce'')',...
        'backgroundcolor',bgc,'tag','input_E0mu');    
    
    menu4 = uicontrol('style','popupmenu','pos',[405 fht-166 110 25],...
        'backgroundcolor',bgc,'tag','menu_E0mu','string','Free|Fixed|= E0,sp',...
        'callback','PBR_model_window(''checkParams'')');
   
    % ------------------------------------------
    
    % ------ ROW 5 -- E1 --------------
    
    text52 = uicontrol('style','text','pos',[125 fht-195 280 20],...
        'fontsize',10,'string','Exhumation rate (E1) (m/Myr):',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    edit5 = uicontrol('style','edit','pos',[520 fht-195 100 25],...
        'string',sprintf('%0.1f',ipd(3)),'callback','PBR_model_window(''runOnce'')',...
        'backgroundcolor',bgc,'tag','input_E1'); 
    
    menu5 = uicontrol('style','popupmenu','pos',[405 fht-196 110 25],...
        'backgroundcolor',bgc,'tag','menu_E1','string','Free|Fixed',...
        'callback','PBR_model_window(''checkParams'')');
    
    text53 = uicontrol('style','text','pos',[12 fht-195 100 20],...
        'backgroundcolor',bgc,'string','# params: 4','fontsize',10,...
        'horizontalalignment','left','tag','text_num_params');
    
    % ------------------------------------------
    
    % ------ ROW 6 -- t0 --------------
    
    text62 = uicontrol('style','text','pos',[125 fht-225 280 20],...
        'fontsize',10,'string','Age PBR top exhumed (t0) (yr):',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    edit6 = uicontrol('style','edit','pos',[520 fht-225 100 25],...
        'string',sprintf('%0.0f',ipd(4)),'callback','PBR_model_window(''runOnce'')',...
        'backgroundcolor',bgc,'tag','input_t0');   
    
    menu6 = uicontrol('style','popupmenu','pos',[405 fht-226 110 25],...
        'backgroundcolor',bgc,'tag','menu_t0','string','Free|Fixed',...
        'callback','PBR_model_window(''checkParams'')');
    
    % ------------------------------------------
    
    % -------- box containing row 7 ------------
    
    box7 = uicontrol('style','frame','pos',[5 fht-270 630 35],...
        'backgroundcolor',bgc);
    
    % -------- ROW 7 -- MODEL OPTIONS ----------
    
    text71 = uicontrol('style','text','pos',[15 fht-267 205 20],...
        'fontsize',10,'string','4. Forward model scheme:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    modelstr = ' 4-parameter: distinct E0,sp, E0,mu | 3-parameter: E0,sp = E0,mu';
    
    menu7 = uicontrol('style','popupmenu','pos',[220 fht-267 405 25],...
       'string',modelstr,'backgroundcolor',bgc,...
       'tag','menu_model','value',1,...
       'callback','PBR_model_window(''updateUse''); PBR_model_window(''runOnce'')');
   
   % ----------------------------------------
   
   % -------- box containing rows 8-9 ------------
    
    box89 = uicontrol('style','frame','pos',[5 fht-340 630 65],...
        'backgroundcolor',bgc);
     
    % ------------------------------------
    
    % -------- ROW 8 -- UNCERTAINTY OPTIONS ----------
    
    text81 = uicontrol('style','text','pos',[15 fht-305 205 20],...
        'fontsize',10,'string','5. Run optimizer:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    ustr = ' Run once, no uncertainty estimate | Leave-one-out validation (requires > 4 samples) | Monte Carlo uncertainty estimate, local | Monte Carlo, randomized initial guess | Explore random initial guesses only ';
     
    
    menu8 = uicontrol('style','popupmenu','pos',[220 fht-310 405 25],...
       'string',ustr,'backgroundcolor',bgc,...
       'tag','menu_uncert','callback','PBR_model_window(''update_optmenu'')');
   
   % ----------------------------------------
   
   % ---------- ROW 9 -- OPTIMIZE BUTTON ----
   
   text91 = uicontrol('style','text','pos',[15 fht-335 205 20],...
        'fontsize',10,'string','Not optimized',...
        'backgroundcolor',bgc,'foregroundcolor','red',...
        'horizontalalignment','left','tag','text_optim_status');
    
   text92 = uicontrol('style','text','pos',[230 fht-335 70 20],...
        'fontsize',10,'string','Iterations:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag','text_numits','visible','off');
        
   input91 = uicontrol('style','edit','tag','input_numits',...
       'fontsize',10,'string','200','backgroundcolor',bgc,...
       'pos',[310 fht-333 100 25],'visible','off');
   
   button9 = uicontrol('style','pushbutton','pos',[520 fht-335 100 25],...
       'string','Optimize !','callback','PBR_model_window(''solve'')',...
       'backgroundcolor',bgc,'tag','button_optimize');
   
   % ----------------------------------------  
   
   % -------- box containing row 10 ------------
    
    box10 = uicontrol('style','frame','pos',[5 fht-380 630 35],...
        'backgroundcolor',bgc);
   
   % ---------- ROW 10 -- site-specific data ----
   
   text101 = uicontrol('style','text','pos',[15 fht-377 610 20],...
        'fontsize',10,'string','--',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag','text_sample_1');
    
    % -------- SET TO RELATIVE UNITS -----
    
    set(findobj('parent',gcf),'units','normalized');
    
    % ------- PART 2 -- SET UP THE RESULTS WINDOW ---
    
    f2 = figure;
    fpos = get(f,'pos');
    fht2 = fht+250;
    set(f2,'pos',[fpos(1)+fpos(3)+5 fpos(2)-250 fpos(3) fht2]);
    set(f2,'color',bgc);
    set(f2,'tag','windowPlot');
     
    set(f2,'name','PBR exposure model results');
    
    % -------- text at top of figure -----------------
    
    textF1 = uicontrol('style','text','pos',[15 fht2-30 610 20],...
        'fontsize',14,'string','PBR forward model results',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    textF2 = uicontrol('style','text','pos',[15 fht2-60 610 20],...
        'fontsize',10,'string','--',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag','text_sample_2');
    
    % ---------- axes -------------------------
    
    axtop = 80;
    axbot = 220;
    
    % Axis at left -- partial nuclide concentrations
    
    axisF1 = axes('units','pixels','pos',[50 axbot 180 fht2-axtop-axbot]);
    set(axisF1,'fontsize',8,'tag','axesPartial','ydir','reverse');
    xlabel('[Be-10] (atoms/g)');
    ylabel('Depth below PBR top (cm)');
    grid on; hold on;
    
    % Axis at center -- model-data comparison
    
    axisF2 = axes('units','pixels','pos',[250 axbot 200 fht2-axtop-axbot]);
    set(axisF2,'fontsize',8,'tag','axesModelData','yticklabel',[],'ydir','reverse');
    xlabel('[Be-10] (atoms/g)');
    grid on; hold on;

    % Axis at right -- model-data comparison residuals
    
    axisF3 = axes('units','pixels','pos',[470 axbot 140 fht2-axtop-axbot]);
    set(axisF3,'fontsize',8,'tag','axesResiduals','yticklabel',[],'ydir','reverse');
    xlabel('Miss (SD of data)');
    grid on; hold on;
    
    % Axis at bottom right -- exhumation constraint
    
    axisF4 = axes('units','pixels','pos',[470 40 140 axbot-90]);
    set(axisF4,'fontsize',8,'tag','axesConstraints');
    xlabel('t0 (ka)'); ylabel('E1 (m/Myr)');
    grid on; hold on;
    
    % Set axes and plot something
    
    set(axisF4,'xlim',[100 100000],'ylim',[10 100000],'yscale','log','xscale','log');
    p1 = plot(ipd(4),ipd(3),'ko','markerfacecolor','b','tag','constraintDot');
    
    t1 = text(20000,10000,'OK','fontsize',12,'fontname','Arial Black','color',[0 0.5 0]);
    t2 = text(500,30,'Not OK','fontsize',12,'fontname','Arial Black','color','r');
    
    
    % ------------ text identifying axes ------------
    
    textFT1 = uicontrol('style','text','pos',[50 fht2-axtop 180 20],...
        'fontsize',10,'string','Components',...
        'backgroundcolor',bgc,...
        'horizontalalignment','center');
    
    textFT2 = uicontrol('style','text','pos',[250 fht2-axtop 200 20],...
        'fontsize',10,'string','Model-data comparison',...
        'backgroundcolor',bgc,'horizontalalignment','center');
    
    textFT3 = uicontrol('style','text','pos',[470 fht2-axtop 140 20],...
        'fontsize',10,'string','Residuals: Np-Nm',...
        'backgroundcolor',bgc,'horizontalalignment','center');
    
    
    
    % ------------- text at bottom -------------------
    
    textF3 = uicontrol('style','text','pos',[30 axbot-75 400 20],...
        'fontsize',12,'string','Model fragility age t_tip: -- yr',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag','text_ttip');
    
    textF4 = uicontrol('style','text','pos',[30 axbot-105 400 20],...
        'fontsize',12,'string','Model fit parameter: -- ',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag','text_fit');
    
    textF5 = uicontrol('style','text','pos',[30 10 400 axbot-100-10],...
        'fontsize',10,'string',' ',...
        'backgroundcolor',bgc,'foregroundcolor','red',...
        'horizontalalignment','left','tag','text_warning');
    
    % -------- SET TO RELATIVE UNITS -----
    
    set(findobj('parent',gcf),'units','normalized');
    
    % --- HIDE DEVELOPMENTAL THINGS ----
    
    set(findobj('tag','menu_E0sp'),'visible','off');
    set(findobj('tag','menu_E0mu'),'visible','off');
    set(findobj('tag','menu_E1'),'visible','off');
    set(findobj('tag','menu_t0'),'visible','off');
    set(findobj('tag','text_num_params'),'visible','off');
    
    
elseif strcmp(action,'checkParams')
    % This determines which parameters are free, fixed, or fixed to each
    % other for purposes of counting total # params.  
    % This is in development at the moment.  
    freep = 0;
    
    v1 = get(findobj('tag','menu_E0sp'),'value');
    if v1 == 1
        % Case E0sp free
        freep = freep + 1;
    end
    v2 = get(findobj('tag','menu_E0mu'),'value');
    if v2 == 1
        % This is only case where we add a parameter -- fixed or equal to
        % E0sp add no parameters
        freep = freep + 1;
    end
    v3 = get(findobj('tag','menu_E1'),'value');
    if v3 == 1
        freep = freep + 1;
    end
    v4 = get(findobj('tag','menu_t0'),'value');
    if v4 == 1
        freep = freep + 1;
    end
    
    set(findobj('tag','text_num_params'),'string',['# params: ' int2str(freep)]);
  
    
elseif strcmp(action,'random_values')
    
    % data load
    eval(['load ' get(findobj('tag','text_fname'),'string')]);
    
    
    % Puts random numbers in input parameters
    v1 = get(findobj('tag','menu_E0sp'),'value');
    v2 = get(findobj('tag','menu_E0mu'),'value');
    v3 = get(findobj('tag','menu_E1'),'value');
    v4 = get(findobj('tag','menu_t0'),'value');
    
    if v4 == 1 % Case t0 free
        rt0 = rand(1).*60000 + 1000; % uniform between 1000 and 60000
        set(findobj('tag','input_t0'),'string',sprintf('%0.0f',rt0));
    else
        % if fixed, must get as base for random E1
        rt0 = str2num(get(findobj('tag','input_t0'),'string'));
    end
    if v3 == 1 % Case E1 free
        rE1 = (rand(1).*20 + 1).*1e4.*max(d.zi)./rt0; % uniform 1-21x constraint
        set(findobj('tag','input_E1'),'string',sprintf('%0.1f',rE1));
    end
    
    if v2 == 1 % case E0mu free
        rE0mu = rand(1).*1000 + 1;
        set(findobj('tag','input_E0mu'),'string',sprintf('%0.2f',rE0mu));
    end
    if v1 == 1 % case E0sp free
        rE0sp = rand(1).*1000 + 1;
        set(findobj('tag','input_E0sp'),'string',sprintf('%0.2f',rE0sp));
    end
    
    PBR_model_window('runOnce');
    
    
elseif strcmp(action,'update_optmenu')
    % This just adjusts go button to match selection in optimization menu.
    
    bh = findobj('tag','button_optimize');
    ith1 = findobj('tag','text_numits');
    ith2 = findobj('tag','input_numits');
    

    mv = get(findobj('tag','menu_uncert'),'value');
    if mv == 1
        % Case one-off optimization
        set(bh,'string','Optimize !');
        set(ith1,'visible','off');
        set(ith2,'visible','off');
        
    elseif mv == 2
        % Case leave-one-out
        set(bh,'string','Go');
        set(ith1,'visible','off');
        set(ith2,'visible','off');
        
    elseif mv == 3 | mv == 4 | mv == 5
        % Case Monte Carlo
        set(bh,'string','Go');
        set(ith1,'visible','on');
        set(ith2,'visible','on');
    end
        
    
    
elseif strcmp(action,'loadFile')
    % Loads PBR data file 
    
    % First reset
    PBR_model_window('reset');
   
    % Choose file and put file name in appropriate place
    [fname,pname] = uigetfile('*.mat');
    fullname = [pname fname];
    set(findobj('tag','text_fname'),'string',fullname);
    
    % Load data file
    
    eval(['load ' fullname]);
    
    % Create sample window
    
    PBR_sample_window(fullname);
    
   	% Determine depth limits for axes
    
    maxdepth = 10 + 10 *ceil(max([d.h d.zi])./10);
    mindepth = 10*floor(min([d.h d.zi])./10) -10;
    
    set(findobj('tag','axesPartial'),'ylim',[mindepth maxdepth]);
    set(findobj('tag','axesModelData'),'ylim',[mindepth maxdepth]);
    set(findobj('tag','axesResiduals'),'ylim',[mindepth maxdepth]);
    
    % Set sample data strings
    
    sstr = [d.PBRName ':  '];
    if d.lat > 0; sstr = [sstr sprintf('%0.5f',d.lat) ' N, '];
    elseif d.lat <= 0; sstr = [sstr sprintf('%0.5f',d.lat) ' S, ']; 
    end
    
    if d.lon > 0; sstr = [sstr sprintf('%0.5f',d.lon) ' E;  '];
    elseif d.lon <= 0; sstr = [sstr sprintf('%0.5f',d.lon) ' W;  ']; 
    end
    
    sstr = [sstr 'Elevation ' sprintf('%0.0f',d.elv) ' m;  '];
    sstr = [sstr 'PBR height ' sprintf('%0.0f',d.h) ' cm'];
    
    set(findobj('tag','text_sample_1'),'string',sstr);
    set(findobj('tag','text_sample_2'),'string',sstr);
    
    % Deal with constraints
    
    % If setting up new data set, make plausible default E1
    sett0 = 20000; setE1 = 1e4*10.*max(d.zi)./sett0;
    
    set(findobj('tag','input_t0'),'string',sprintf('%0.0f',sett0));
    set(findobj('tag','input_E1'),'string',sprintf('%0.1f',setE1));
    set(findobj('tag','constraintDot'),'xdata',sett0,'ydata',setE1);
    
    % plot dummy constraint line
    % first remove old
    delete(findobj('tag','regionNotOK'));
    
    axes(findobj('tag','axesConstraints'));
    plot([0 60000],[1000 1000],'r','tag','regionNotOK','linewidth',2);
    
    % Now run constraint check
    PBR_model_window('checkConstraint');
    
    % Now plotting in data window
    % first remove old data
    delete(findobj('tag','dataErrorBars'));
    a = 1;
    while 1
        dtag = ['dataPoint' int2str(a)];
        temp = findobj('tag',dtag);
        if isempty(temp)
            break;
        else
            delete(temp);
        end
        a = a+1;
    end

    axes(findobj('tag','axesModelData'));
    set(gca,'xlimmode','auto');
    
    for a = 1:length(d.Nmi)
        dtag = ['dataPoint' int2str(a)];
        xx = [d.Nmi(a)-d.delNmi(a) d.Nmi(a)+d.delNmi(a)];
        yy = [d.zi(a) d.zi(a)];
        plot(xx,yy,'k','tag','dataErrorBars');
        plot(d.Nmi(a),d.zi(a),'ko','markerfacecolor','g','tag',dtag,'markersize',6);
    end
   
    % Also plot fulcrum height
    
    delete(findobj('tag','fulcrumLine'));
    plot(get(gca,'xlim'),[d.h d.h],'k--','tag','fulcrumLine');
    
    % fix x limits, I think
    set(gca,'xlimmode','manual');
    
    % Also, run model for initial data
    
    PBR_model_window('runOnce');
    
elseif strcmp(action,'runOnce')
    % Runs forward model once and plots against data.
    
	% clear warnings 
    wth = findobj('tag','text_warning');
    set(wth,'string',' ');
    
    % Update stuff
    PBR_model_window('checkParams');
    PBR_model_window('updateUse');
    % I think that takes care of setting optim status text back to not
    % optimized. Also checks constraints. 
    
    % Parameter extraction
    input_E0sp = str2num(get(findobj('tag','input_E0sp'),'string')); % m/Myr
    input_E0mu = str2num(get(findobj('tag','input_E0mu'),'string')); % m/Myr
    input_E1 = str2num(get(findobj('tag','input_E1'),'string')); % m/Myr
    input_t0 = str2num(get(findobj('tag','input_t0'),'string')); % years
    
    
    % Make sure erosion rates are > 0.1 m/Myr
    if input_E0sp < 0.1
        input_E0sp = 0.1;
        set(findobj('tag','input_E0sp'),'string','0.1');
    end
    
    if input_E0mu < 0.1
        input_E0mu = 0.1;
        set(findobj('tag','input_E0mu'),'string','0.1');
    end
      
    % Reconcile erosion rates with menu selection
    % That is, if a three-parameter fit is chosen, make E0,mu = E0,sp
    
    if get(findobj('tag','menu_model'),'value') == 2
        input_E0mu = input_E0sp;
        set(findobj('tag','input_E0mu'),'string',sprintf('%0.2f',input_E0mu));
    end
    
    % data load
    eval(['load ' get(findobj('tag','text_fname'),'string')]);
    
    % params load
    load PBR_consts;
    
    % Get use vector
    use = zeros(1,length(d.zi));
    for a = 1:length(d.Nmi)
        ctag = ['checkbox_use_' int2str(a)];
        use(a) = get(findobj('tag',ctag),'value');
    end
    
    % Put in data structure
    d.mask = find(use);
        
    % Fill X vector
    X = [input_E0sp input_E0mu input_E1 input_t0./1000];
    
    control.returnData = 1;

    % Run forward model
    out = PBR_objective_v3(X,d,consts,control);

    % Plot prediction, components, residuals
    
    % Get order
    [temp,si] = sort(d.zi);
    
    % 1. Plot prediction
    
    if ~isempty(findobj('tag','predPoints'))
        set(findobj('tag','predPoints'),'xdata',out.Ni(si));
        set(findobj('tag','predLine'),'xdata',out.Ni(si));
    else
        axes(findobj('tag','axesModelData'));
        plot(out.Ni(si),d.zi(si),'ro','markersize',10,'tag','predPoints');
        plot(out.Ni(si),d.zi(si),'r','tag','predLine');
    end
    
    
    
    % 2. Plot components
    plotx0 = out.N0isp + out.N0imu;
    plotx1 = out.N1isp + out.N1imu;
    plotx2 = out.N2isp + out.N2imu;

    
    if ~isempty(findobj('tag','comp0Points'))
        % If already exist, just change value
        set(findobj('tag','comp0Points'),'xdata',plotx0(si));
        set(findobj('tag','comp1Points'),'xdata',plotx1(si));
        set(findobj('tag','comp2Points'),'xdata',plotx2(si));
    else
        % If don't exist yet, create
        axes(findobj('tag','axesPartial'));
        plot(plotx0(si),d.zi(si),'r','tag','comp0Points');
        plot(plotx1(si),d.zi(si),'g','tag','comp1Points');
        plot(plotx2(si),d.zi(si),'b','tag','comp2Points');
    end
    
    
    
    % 3. Plot residuals
    
    if ~isempty(findobj('tag','resPoints'))
        set(findobj('tag','resPoints'),'xdata',out.plotMi);
        for a = 1:length(d.zi)
            thist = ['resBar' int2str(a)];
            set(findobj('tag',thist),'xdata',[out.plotMi(a)-1 out.plotMi(a)+1]);
        end
    else
        axes(findobj('tag','axesResiduals'));
        for a = 1:length(d.zi)
            thist = ['resBar' int2str(a)];
            xx = [out.plotMi(a)-1 out.plotMi(a)+1];
            yy = [d.zi(a) d.zi(a)];
            plot(xx,yy,'b','tag',thist); hold on;
        end
        plot(out.plotMi,d.zi,'ko','markerfacecolor','r','tag','resPoints','markersize',7);
        
    end
       
    
   
    % Display ttip and fit parameter
    
    ttip = input_t0 - d.h/(input_E1.*1e-4);
    
    set(findobj('tag','text_ttip'),'string',['Model fragility age t_tip: ' sprintf('%0.0f',ttip) ' yr']);
    
    set(findobj('tag','text_fit'),'string',['Model fit parameter: ' sprintf('%0.2f',out.M)]);            
   
elseif strcmp(action,'solve')
    % Runs optimizer to find best-fit parameters
 
    % Get model scheme
    model = get(findobj('tag','menu_model'),'value');
    
    % Update text
    set(findobj('tag','text_optim_status'),'string','Running...');
       
    % clear warnings 
    wth = findobj('tag','text_warning');
    set(wth,'string',' ');
    drawnow;
    
    % All input parameter checks should have been completed if this is
    % called. No change in data, just button push
    
    % Parameter extraction
    input_E0sp = str2num(get(findobj('tag','input_E0sp'),'string')); % m/Myr
    input_E0mu = str2num(get(findobj('tag','input_E0mu'),'string')); % m/Myr
    input_E1 = str2num(get(findobj('tag','input_E1'),'string')); % m/Myr
    input_t0 = str2num(get(findobj('tag','input_t0'),'string')); % years
    
    % data load
    eval(['load ' get(findobj('tag','text_fname'),'string')]);
    
    % params load
    load PBR_consts;
    
    % Get use vector
    use = zeros(1,length(d.zi));
    for a = 1:length(d.Nmi)
        ctag = ['checkbox_use_' int2str(a)];
        use(a) = get(findobj('tag',ctag),'value');
    end
    
    % Put in data structure
    d.mask = find(use);
        
    % Initial value
    X0 = [input_E0sp input_E0mu input_E1 input_t0./1000];
    
    % Set up optimizer
    
    opts = optimset('fmincon');
    opts = optimset(opts,'display','iter');
    
    control.returnData = 0;
    
    % Do optimization

    Xmins = [0.1 0.1 0 0];
    Xmaxes = [10000 10000 10000 10000];
   
    if model == 1
        % case 4-parameter
        disp('4 parameters');
        [Xopt,fval,exitflag,output] = fmincon(@(x) PBR_objective_v3(x,d,consts,control),X0,consts.conA,consts.conB,[],[],Xmins,Xmaxes,@(x) exhumeCon(x,max(d.zi)),opts);
    elseif model == 2
        % case 3-parameter
        disp('3 parameters');
        [Xopt,fval,exitflag,output] = fmincon(@(x) PBR_objective_v3(x,d,consts,control),X0,[],[],[1 -1 0 0],[0],Xmins,Xmaxes,@(x) exhumeCon(x,max(d.zi)),opts);
    end
     
    % Place optimal values in text boxes
    set(findobj('tag','input_E0sp'),'string',sprintf('%0.2f',Xopt(1)));
    set(findobj('tag','input_E0mu'),'string',sprintf('%0.2f',Xopt(2)));
    set(findobj('tag','input_E1'),'string',sprintf('%0.1f',Xopt(3)));
    set(findobj('tag','input_t0'),'string',sprintf('%0.0f',Xopt(4).*1000));
    
    PBR_model_window('runOnce');

    set(findobj('tag','text_optim_status'),'string','Optimized');
    
    % Put exit message in warning...
    set(findobj('tag','text_warning'),'string',[get(findobj('tag','text_warning'),'string') ' ' output.message]);
    
    % Now determine if other uncertainty analysis is required
    
    uOpt = get(findobj('tag','menu_uncert'),'value');
    
    if uOpt == 2
        % Case leave-one-out; run appropriate code
        PBR_opt_leave_one_out(Xopt,d,consts,control);
    elseif uOpt == 3 || uOpt == 4 || uOpt == 5
        % Case Monte Carlo uncert analysis or random search; run appropriate code
        PBR_MCS(Xopt,d,control,consts);
    end
        
    
    
elseif strcmp(action,'reset')
    % Clears everything
    % Resets defaults
    % Resets constraints plot
    
    % Delete sample window
    delete(findobj('tag','windowSamples'));
    
    % Delete data points
    delete(findobj('tag','dataErrorBars'));
    delete(findobj('tag','fulcrumLine'));
    a = 1;
    while 1
        dtag = ['dataPoint' int2str(a)];
        temp = findobj('tag',dtag);
        if isempty(temp)
            break;
        else
            delete(temp);
        end
        a = a+1;
    end
    
    % Clear various bits of text
    set(findobj('tag','text_sample_1'),'string','--');
    set(findobj('tag','text_sample_2'),'string','--');
    set(findobj('tag','text_warning'),'string','');
    set(findobj('tag','text_fname'),'string','--');
    set(findobj('tag','text_optim_status'),'string','Not optimized');
    set(findobj('tag','button_optim'),'visible','on');
    
    % Reset defaults
    set(findobj('tag','input_E0sp'),'string','10.00');
    set(findobj('tag','input_E0mu'),'string','10.00');
    set(findobj('tag','input_E1'),'string','1000');
    set(findobj('tag','input_t0'),'string','20000');
    
    % Reset constraints figure
    set(findobj('tag','regionNotOK'),'xdata',[0 60000],'ydata',[100 100]);
    set(findobj('tag','constraintDot'),'xdata',20000,'ydata',1000);
    
    % Clear predicted data stuff
    delete(findobj('tag','predPoints'));
    delete(findobj('tag','predLine'));
    delete(findobj('tag','comp0Points'));
    delete(findobj('tag','comp1Points'));
    delete(findobj('tag','comp2Points'));
    
    temp = findobj('tag','axesResiduals');
    delete(findobj('parent',temp));
    
    % Reset free-fixed menus
    set(findobj('tag','menu_E0sp'),'value',1);
    set(findobj('tag','menu_E0mu'),'value',1);
    set(findobj('tag','menu_E1'),'value',1);
    set(findobj('tag','menu_t0'),'value',1);
    set(findobj('tag','text_num_params'),'string','# params: 4');
    
    
    
    
elseif strcmp(action,'updateUse')
    % Updates which samples are in use
    
    % Load data (again)
    
    eval(['load ' get(findobj('tag','text_fname'),'string')]); 
    

    % Figure out which data are in use and change colors accordingly 
    use = zeros(1,length(d.zi));
    for a = 1:length(d.Nmi)
        ctag = ['checkbox_use_' int2str(a)];
        use(a) = get(findobj('tag',ctag),'value');
        dtag = ['dataPoint' int2str(a)];
        if use(a) == 1; col = [0.2 0.8 0.2]; else; col = [0.8 0.2 0.2]; end
        set(findobj('tag',dtag),'markerfacecolor',col);
    end
    
    % Make sure there are enough data to do optimization
    if get(findobj('tag','menu_model'),'value') <= 2 & length(find(use)) < 4
        set(findobj('tag','text_optim_status'),'string','Can''t optimize -- not enough data');
        set(findobj('tag','button_optimize'),'visible','off');
    elseif get(findobj('tag','menu_model'),'value') > 2 & length(find(use)) < 3
        set(findobj('tag','text_optim_status'),'string','Not enough data');
        set(findobj('tag','button_optimize'),'visible','off');
    else
        set(findobj('tag','text_optim_status'),'string','Not optimized');
        set(findobj('tag','button_optimize'),'visible','on');
    end
    
    % Also check constraints
    PBR_model_window('checkConstraint');
        
    
elseif strcmp(action,'checkConstraint')
    % Update exhumation constraint
    
    eval(['load ' get(findobj('tag','text_fname'),'string')]); 
    
    % Update exhumation constraint
    pt0 = 1:500:60000; % yr;
    pE1 = max(d.zi)./pt0; % cm/yr
    pE1 = pE1.*1e4; % mMyr;
 
    set(findobj('tag','regionNotOK'),'xdata',pt0,'ydata',pE1);
    
    % Check exhumation constraint and move blue dot
    input_E1 = str2num(get(findobj('tag','input_E1'),'string')); % m/Myr
    input_t0 = str2num(get(findobj('tag','input_t0'),'string')); % years

    
    wth = findobj('tag','text_warning');
    % check exhumation constraint
    minE1 = max(d.zi)./input_t0;
    minE1 = minE1.*1e4; % m/Myr;
    if input_E1 < (minE1-0.1) % Leave a bit of tolerance for the optimizer 
        wt = [get(wth,'string') 'Note: E1 is too small for this t0. Must be > ' sprintf('%0.2f',minE1) ' m/Myr.'];
        set(wth,'string',wt);
        %input_E1 = minE1;
        %set(findobj('tag','input_E1'),'string',sprintf('%0.1f',input_E1));
    end
    % Update blue dot
    set(findobj('tag','constraintDot'),'xdata',input_t0,'ydata',input_E1);
    
    
end
