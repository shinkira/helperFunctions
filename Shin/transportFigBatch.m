function transportFigBatch(varargin)
    if isempty(varargin)
        format = 'eps';
    else
        format = varargin{1};
    end
        
    % Copy all figures to the transfer directory in PNG format
    figpath = 'C:\Users\Shin\Documents\MATLAB\ShinData\Transfer\';
    h = findobj('type','figure');
    n = length(h);
    fprintf('Saving %d figures in %s...\n',n,format);
    for i = 1:n
        fig_name = ['temp',num2str(h(i).Number)];
        figure(h(i).Number)
        switch format
            case 'eps'
                print2eps([figpath,fig_name,'.eps']);
            case 'png'
                export_fig(gcf,[figpath,fig_name],'-png','-nocrop');
        end
    end
end