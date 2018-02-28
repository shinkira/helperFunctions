function transportFigBatch(varargin)

    if length(varargin)<1
        format = 'eps';
    else
        format = varargin{1};
    end
    if length(varargin)<2
        dropbox_flag = 0;
    else
        dropbox_flag = varargin{2};        
    end
    if length(varargin)<3
        headder = 'temp';
    else
        headder = varargin{3};        
    end
        
    % Copy all figures to the transfer directory in PNG format
    switch getComputerName
        case 'shinichiros-macbook-pro'
            figpath = '/Users/shin/Documents/MATLAB/ShinData/Transfer/';
        case 'harveylabrig51'
            figpath = 'C:\Users\Shin\Documents\MATLAB\ShinData\Transfer\';
        case 'shin-pc'
            if dropbox_flag
                figpath = 'C:\Users\Shin\Dropbox (HMS)\TempFigs\';
            else
                figpath = 'C:\Users\Shin\Documents\MATLAB\ShinData\Transfer\';
            end
    end
        
    h = findobj('type','figure');
    n = length(h);
    fprintf('Saving %d figures in %s...\n',n,format);
    for i = 1:n
        fig_name = [headder,'_',num2str(h(i).Number)];
        figure(h(i).Number)
        set(gcf,'color','w')
        switch format
            case 'eps'
                print2eps([figpath,fig_name,'.eps']);
            case 'png'
                export_fig(gcf,[figpath,fig_name],'-png','-nocrop');
        end
    end
end