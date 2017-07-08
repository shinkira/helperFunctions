function [f_, stats] = getF_(f, mode, frameRate, base_prctile)
% f_ = getF_(f, mode)
% default mode is linear, w/ robust fit estimation

if ~exist('mode','var') || isempty(mode)
    mode = 'custom_wfun';
end

if strcmp('mode','base_prctile') && isempty(base_prctile)
    error('Specify base_prctile for the baseline estimation.')
end

if (strcmp(mode,'custom_wfun') || strcmp(mode,'base_prctile'))...
        && (~exist('frameRate','var') || isempty(frameRate))
    error('specify frameRate')
end

switch mode
    case 'custom_wfun'
        [f_, stats] = getBaseline_customWeightFun(f);
    
    case 'exp_linear'
        x = linspace(-1,1,length(f));
        xExp = exp(-x);
        b = robustfit([x',xExp'],f,'bisquare',2);
        f_ = [ones(length(f),1),x',xExp'] * b;
        f_ = f_';
        
    case 'exponential'
        % Robustly fit a straight line to log(fluorescence) and then
        % subtract exp(straightLine).
        f(f<0.1) = 0.1; % So that log() works without imaginary issues.
        fl = log(f);
        x = 1:numel(f);
        b = robustfit(x, fl,'bisquare',2);
        f_ = exp(b(1)+b(2)*x);
        
    case 'linear'
%         f = detrend(f);
        % Detrend is not robust to outliers, so we use robustfit instead:
        x = 1:numel(f);
        b = robustfit(x, f,'bisquare',2);
        f_ = b(1)+b(2)*x;
        
    case 'prctile'
        winSize = frameRate*2*60; % 2 min window
        f_ = runningPrctile(f, round(winSize), base_prctile);
        
end