function out = PBR_MCS(xopt,d,control,consts)

% This does Monte Carlo uncertainty analysis for PBR optimization
% designed to run with GUI -- displays running results and
% diagnostics
%
% Written by Greg Balco
% Berkeley Geochronology Center
%
% Note: authorship, license, and disclaimers for use of this code are 
% in an accompanying README.md file that should have been distributed 
% with the code. Do not distribute this code without the README.md file. 


% extracts model to use from GUI window

% Note: doesn't include production rate uncert...?

%% Setup

% Get model scheme
model = get(findobj('tag','menu_model'),'value');
if model == 2
    flag3P = 1;
else
    flag3P = 0;
end

uOpt = get(findobj('tag','menu_uncert'),'value');

% Get measurement uncert option

if uOpt == 5
    mErrorFlag = 0;
else
    mErrorFlag = 1;
end

% Get starting guess option

if uOpt == 4 || uOpt == 5
    randGuessFlag = 1;
else
    randGuessFlag = 0;
end

% Pop figure

create_MCS_window;

% Put PBR data in figure

str1 = get(findobj('tag','text_sample_1'),'string');

if model == 1 
    str1 = [str1 '; 4-parameter'];
elseif model == 2
    str1 = [str1 '; 3-parameter'];
end

str1 = [str1 '; mask ' sprintf('%0.0f',d.mask)];

if randGuessFlag == 1
    str1 = [str1 '; Random start: yes'];
elseif randGuessFlag == 0
    str1 = [str1 '; Random start: no'];
end

if mErrorFlag == 1
    str1 = [str1 '; MCS: yes'];
elseif mErrorFlag == 0
    str1 = [str1 '; MCS: no'];
end

set(findobj('tag','text_MCS_ID'),'string',str1);



out.description = str1;


% Hide lower set of axes if three-parameter

if flag3P
    set(findobj('tag','axes11'),'visible','off');
    set(findobj('tag','axes12'),'visible','off');
    set(findobj('tag','axes13'),'visible','off');
    set(findobj('tag','scatter11'),'visible','off');
    set(findobj('tag','scatter12'),'visible','off');
    set(findobj('tag','scatter13'),'visible','off');
    set(findobj('tag','dup_label_1'),'visible','on');
    set(findobj('tag','dup_label_2'),'visible','on');
end

% Set status text to reflect activity

set(findobj('tag','text_optim_status'),'string','Running MCS...');


% Pull various graphics handles to speed things up

% scatterplots
h_scatter11 = findobj('tag','scatter11');
h_scatter12 = findobj('tag','scatter12');
h_scatter13 = findobj('tag','scatter13');
h_scatter21 = findobj('tag','scatter21');
h_scatter22 = findobj('tag','scatter22');
h_scatter31 = findobj('tag','scatter31');

h_patchGood = findobj('tag','patchGood');
h_patchBad = findobj('tag','patchBad');

h_lineHist = findobj('tag','lineHist');

h_axesBar = findobj('tag','axesBar')

h_textConvStats = findobj('tag','text_MCS_convstats');

h_textt0 = findobj('tag','text_MCS_t0');
h_textE1 = findobj('tag','text_MCS_E1');
h_textE0sp = findobj('tag','text_MCS_E0sp');
h_textE0mu = findobj('tag','text_MCS_E0mu');
h_textttip = findobj('tag','text_MCS_ttip');

% Determine number of iterations

numits = str2num(get(findobj('tag','input_numits'),'string'));

% Set bar graph axes

set(h_axesBar,'xlim',[0 numits]);
set(h_patchGood,'xdata',[0 0 0 0 0]);
set(h_patchBad,'xdata',[0 0 0 0 0]);

%%  Generate random inputs if required
% Note: measurement uncertainties only

if mErrorFlag == 1
    rNmi = zeros(length(d.Nmi),numits);
    
    for a = 1:length(d.Nmi)
        rNmi(a,1:numits) = randn(1,numits).*d.delNmi(a) + d.Nmi(a);
    end
end
      
%% Generate random start guesses if required

if randGuessFlag
    rt0 = rand(1,numits).*60000 + 1000; % uniform between 1000 and 60000
    rE1 = (rand(1,numits).*20 + 1).*1e4.*max(d.zi)./rt0; % uniform 1-21x constraint
    rE0mu = rand(1,numits).*100 + 2; % E0s uniform between 2-100...??
    if flag3P == 1
        rE0sp = rE0mu;
    else
        rE0sp = rand(1,numits).*100 + 2;
    end
    
    rX0 = [rE0sp' rE0mu' rE1' (rt0./1000)'];
end

%% Initialize some stuff
nConv = 0;
nNotConv = 0;
nComplete = 0;
t0s = [];
E1s = [];
E0sps = [];
E0mus = [];
fvals = [];
exitflags = [];

% If no MCS, don't compute averages
if mErrorFlag == 0
    set(h_textt0,'string','');
    set(h_textE1,'string','');
    set(h_textE0sp,'string','');
    set(h_textE0mu,'string','');    
    set(h_textttip,'string','');  
end

% Update figure

drawnow;

%% Main loop 

for a = 1:numits
    % check for break;
    
    if get(findobj('tag','checkbox_stop_MCS'),'value') == 1
        break;
    end
    
    % Create new data structure
    d2 = d; 
    if mErrorFlag == 1
        % Case use random-draw measurements
        d2.Nmi = rNmi(:,a);
    end
        
    % Get starting value -- add random initialization here
    if randGuessFlag == 1
        x0 = rX0(a,:);
    elseif randGuessFlag == 0
        x0 = xopt;
    end
        
    % Set up optimizer
    opts = optimset('fmincon');
    opts = optimset(opts,'display','off');
    
    Xmins = [0.1 0.1 0 0];
    Xmaxes = [10000 10000 10000 10000];
    
    % Solve
    if flag3P == 0
        % case 4-parameter
        [this_xopt,fval,exitflag,output] = fmincon(@(x) PBR_objective_v3(x,d2,consts,control),x0,consts.conA,consts.conB,[],[],Xmins,Xmaxes,@(x) exhumeCon(x,max(d.zi)),opts);
    elseif flag3P == 1
        % case 3-parameter
        [this_xopt,fval,exitflag,output] = fmincon(@(x) PBR_objective_v3(x,d2,consts,control),x0,[],[],[1 -1 0 0],[0],Xmins,Xmaxes,@(x) exhumeCon(x,max(d.zi)),opts);
    end
    
    % Check for not-enough-iterations and run again if necessary
    if exitflag == 0
        % Do again
        disp('Not enough iterations. Running more.'); 
        if flag3P == 0
            % case 4-parameter
            [this_xopt,fval,exitflag,output] = fmincon(@(x) PBR_objective_v3(x,d2,consts,control),this_xopt,consts.conA,consts.conB,[],[],Xmins,Xmaxes,@(x) exhumeCon(x,max(d.zi)),opts);
        elseif flag3P == 1
            % case 3-parameter
            [this_xopt,fval,exitflag,output] = fmincon(@(x) PBR_objective_v3(x,d2,consts,control),this_xopt,[],[],[1 -1 0 0],[0],Xmins,Xmaxes,@(x) exhumeCon(x,max(d.zi)),opts);
        end
    end
    
    % Check for good convergence and increment appropriately
    nComplete = nComplete + 1;
    
    if exitflag > 0
        nConv = nConv + 1;
        % Record the results if it converged. 
        E0sps(end+1) = this_xopt(1);
        E0mus(end+1) = this_xopt(2);
        E1s(end+1) = this_xopt(3);
        t0s(end+1) = this_xopt(4);
        fvals(end+1) = fval;
        exitflags(end+1) = exitflag;
    else
        % Don't record the results if it didn't converge. 
        nNotConv = nNotConv + 1;
    end
    
    % Update main plot
    
    set(findobj('tag','input_E0sp'),'string',sprintf('%0.2f',this_xopt(1)));
    set(findobj('tag','input_E0mu'),'string',sprintf('%0.2f',this_xopt(2)));
    set(findobj('tag','input_E1'),'string',sprintf('%0.1f',this_xopt(3)));
    set(findobj('tag','input_t0'),'string',sprintf('%0.0f',this_xopt(4).*1000));
    PBR_model_window('runOnce');
    
    % Update bar plot
    
    set(h_patchBad,'xdata',[0 nNotConv nNotConv 0 0]);
    set(h_patchGood,'xdata',[nNotConv nComplete nComplete nNotConv nNotConv]);
    
    % Update scatter plots
    
    if flag3P == 0
        set(h_scatter11,'xdata',E1s,'ydata',E0mus);
        set(h_scatter12,'xdata',t0s,'ydata',E0mus);
        set(h_scatter13,'xdata',E0sps,'ydata',E0mus);
    end
    
    set(h_scatter21,'xdata',E1s,'ydata',E0sps);
    set(h_scatter22,'xdata',t0s,'ydata',E0sps);
    set(h_scatter31,'xdata',E1s,'ydata',t0s);
       
    set(findobj('tag','axes31'),'xlim',[min(E1s).*0.95 max(E1s).*1.05],'ylim',[min(t0s).*0.95 max(t0s).*1.05]);
    set(findobj('tag','axes13'),'xlim',[min(E0sps).*0.95 max(E0sps).*1.05],'ylim',[min(E0mus).*0.95 max(E0mus).*1.05]);
      
    % Update histogram plot
    
    if ~isempty(E1s)
        ttips = t0s.*1000 - d.h./(E1s.*1e-4);
        bins = linspace(0.98*min(ttips),1.02*max(ttips),20);
        dbin = 0.5*(bins(2)-bins(1));
    
        hdata = hist(ttips,bins);
        px = [bins(1)-dbin]; py = [0];
    
        for b = 1:length(bins)
            px = [px bins(b)-dbin bins(b)+dbin];
            py = [py hdata(b) hdata(b)];
        end
    
        px = [px bins(end)+dbin];
        py = [py 0];
    
        set(h_lineHist,'xdata',px./1000,'ydata',py');   
    
        % Update summary text
        if mErrorFlag == 1 % If this is actually a MCS
            set(h_textt0,'string',['t0 (ka): ' sprintf('%0.2f',mean(t0s)) ' +/- ' sprintf('%0.2f',std(t0s))]);
            set(h_textE1,'string',['E1 (m/Myr): ' sprintf('%0.1f',mean(E1s)) ' +/- ' sprintf('%0.1f',std(E1s))]);
            set(h_textE0sp,'string',['E0,sp (m/Myr): ' sprintf('%0.1f',mean(E0sps)) ' +/- ' sprintf('%0.1f',std(E0sps))]);
            set(h_textE0mu,'string',['E0,mu (m/Myr): ' sprintf('%0.1f',mean(E0mus)) ' +/- ' sprintf('%0.1f',std(E0mus))]);
            set(h_textttip,'string',['t_tip (ka): ' sprintf('%0.2f',mean(ttips./1000)) ' +/- ' sprintf('%0.2f',std(ttips./1000))]);  
        end
    
    end
    
    set(h_textConvStats,'string',['Iterations: ' int2str(nComplete) ': ' int2str(nConv) ' converged; ' int2str(nNotConv) ' did not.']);    
    
    drawnow;

end % end main loop

%% Figure window with fit statistics

if ~isempty(findobj('tag','fvalfigure'))
    delete(findobj('tag','fvalfigure'));
end

figure('pos',[0 0 550 700],'units','pixels','tag','fvalfigure');

al = 50;
abot = 50;
aw = 550-al-30;
ah = 120;

% Fit vs ttip
afit1 = axes('units','pixels','pos',[al abot aw ah]);
plot(fvals,ttips./1000,'r.');
ylabel('t_tip (ka)');
xlabel('Fit value');

% fit vs E0,sp
afit2 = axes('units','pixels','pos',[al abot+ah aw ah],'xticklabel',[]);
plot(fvals,E0sps,'r.');
ylabel('E0,sp (m/Myr');

% fit vs. E0,mu
afit3 = axes('units','pixels','pos',[al abot+2*ah aw ah],'xticklabel',[]);
plot(fvals,E0mus,'r.');
ylabel('E0,mu (m/Myr)');

% fit vs E1
afit4 = axes('units','pixels','pos',[al abot+3*ah aw ah],'xticklabel',[]);
plot(fvals,E1s,'r.');
ylabel('E0,mu (m/Myr)');

% fit vs. t0
afit5 = axes('units','pixels','pos',[al abot+4*ah aw ah],'xticklabel',[]);
plot(fvals,t0s,'r.');
ylabel('t0 (ka)');

% reconcile axes
xl = get(afit1,'xlim');
set(afit2,'xlim',xl);
set(afit3,'xlim',xl);
set(afit4,'xlim',xl);
set(afit5,'xlim',xl);

% clean up x ticks
temp = get(afit1,'ytick'); set(afit1,'ytick',temp(2:end));
temp = get(afit2,'ytick'); set(afit2,'ytick',temp(2:end));
temp = get(afit3,'ytick'); set(afit3,'ytick',temp(2:end));
temp = get(afit4,'ytick'); set(afit4,'ytick',temp(2:end));
temp = get(afit5,'ytick'); set(afit5,'ytick',temp(2:end));

%% Additional figure window with t0/E1/ttip contour plot

if ~isempty(findobj('tag','contourfigure'))
    delete(findobj('tag','contourfigure'));
end

figure('tag','contourfigure');

xl = [min(E1s).*0.95 max(E1s.*1.05)];
yl = [min(t0s).*0.95 max(t0s.*1.05)];

plotE1s = linspace(xl(1),xl(2),100);
plott0s = linspace(yl(1),yl(2),101);
[mE1s,mt0s] = meshgrid(plotE1s,plott0s);
mttips = (mt0s.*1000 - d.h./(mE1s.*1e-4))./1000;

mintt_ka = floor(min(ttips./1000))
maxtt_ka = ceil(max(ttips./1000))
cint = ceil((maxtt_ka - mintt_ka)./10)

[cttip,httip] = contour(mE1s,mt0s,mttips,[(mintt_ka-2*cint):cint:(maxtt_ka+2*cint)],'color',[0.5 0.5 0.5]);
hold on;
clabel(cttip,httip,'color',[0.6 0.6 0.6]);
plot(E1s,t0s,'ko','markerfacecolor',[0.3 0.3 1],'markersize',6);
xlabel('E1'); ylabel('t0'); title('Attempt to make contours of t_{tip}');
set(gca,'xlim',xl,'ylim',yl);
grid on;





%% Save results

out.nConv = nConv;
out.nNotConv = nNotConv;
out.nComplete = nComplete;
out.t0s = t0s;
out.ttips = ttips;
out.E1s = E1s;
out.E0sps = E0sps;
out.E0mus = E0mus;
out.fvals = fvals;
out.exitflags = exitflags;
out.calctime = datestr(now);

save latest_MCS_results out

%% End, clear status text

set(findobj('tag','text_optim_status'),'string','Optimized');

