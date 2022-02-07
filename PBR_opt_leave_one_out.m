function out = PBR_opt_leave_one_out(xopt,d,consts,control)

% This does leave-one-out validation for PBR age optimization
%
% Written by Greg Balco
% Berkeley Geochronology Center
%
% Note: authorship, license, and disclaimers for use of this code are 
% in an accompanying README.md file that should have been distributed 
% with the code. Do not distribute this code without the README.md file. 


% Error if not enough data for four-parameter

if length(d.zi) < 5
    disp('Not enough samples for leave-one-out validation. Stopping.');
    set(findobj('tag','text_optim_status'),'string','Need n > 4. Stopping.');
    return
end

%% Set up and initialize

% Get model scheme
model = get(findobj('tag','menu_model'),'value');


xopts = zeros(length(d.zi),4);
fvals = xopts;
exitflags = xopts;

Xmins = [0.1 0.1 0 0];
Xmaxes = [10000 10000 10000 10000];

opts = optimset('fmincon');
opts = optimset(opts,'display','off');

%% Leave each sample out in turn

for a = 1:length(d.zi)
    set(findobj('tag','text_optim_status'),'string',['Leaving out sample ' int2str(a) '.']);
    % Leave out one sample
    use = ones(size(d.zi));
    use(a) = 0;
    
    d.mask = find(use);
    
    % Update samples window
    for b = 1:length(d.Nmi)
        ctag = ['checkbox_use_' int2str(b)];
        set(findobj('tag',ctag),'value',use(b));
    end
      
    % Do optimization, starting at existing Xopt
    if model == 1
        % case 4-parameter
        [tempx,fvals(a),exitflags(a),output] = fmincon(@(x) PBR_objective_v3(x,d,consts,control),xopt,consts.conA,consts.conB,[],[],Xmins,Xmaxes,@(x) exhumeCon(x,max(d.zi)),opts);
    elseif model == 2
        % case 3-parameter, force X1 = X2;
        [tempx,fvals(a),exitflags(a),output] = fmincon(@(x) PBR_objective_v3(x,d,consts,control),xopt,[],[],[1 -1 0 0],[0],Xmins,Xmaxes,@(x) exhumeCon(x,max(d.zi)),opts);
    end
    
    xopts(a,:) = tempx;
    
    % Update model window
    set(findobj('tag','input_E0sp'),'string',sprintf('%0.2f',xopts(a,1)));
    set(findobj('tag','input_E0mu'),'string',sprintf('%0.2f',xopts(a,2)));
    set(findobj('tag','input_E1'),'string',sprintf('%0.1f',xopts(a,3)));
    set(findobj('tag','input_t0'),'string',sprintf('%0.0f',xopts(a,4).*1000));
    drawnow
    PBR_model_window('runOnce')
    drawnow
end

for a = 1:length(d.zi)
    outstr = ['Leaving out sample ' int2str(a) ': E0,sp = ' sprintf('%0.2f',xopts(a,1)) '; E0,mu = ' sprintf('%0.2f',xopts(a,2)) '; E1 = ' sprintf('%0.2f',xopts(a,3)) '; t0 = ' sprintf('%0.0f',xopts(a,4).*1000)];
    outstr = [outstr '; ttip = ' sprintf('%0.0f',(1000*xopts(a,4) - d.h/(xopts(a,3).*1e-4))) '; fval = ' sprintf('%0.1f',fvals(a)) '; exitflag = ' int2str(exitflags(a))];
    disp(outstr);
end

% Also save results




