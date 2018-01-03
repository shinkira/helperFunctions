function transportFig(varargin)
    if isempty(varargin)
        fig_name = 'temp1';
    else
        fig_name = varargin{1};
    end
    if ispc
        figpath = 'C:\Users\Shin\Documents\MATLAB\ShinData\Transfer\';
    else
        figpath = '/Users/shin/Documents/MATLAB/ShinData/Transfer/';
    end
    export_fig(gcf,[figpath,fig_name],'-png');
    % print2eps([figpath,fig_name,'.eps'])
end