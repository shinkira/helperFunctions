function transportFig(varargin)

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
        case 'shin-macbook-pro'
            figpath = '/Users/shin/Dropbox (HMS)/TempFigs/';
        case 'harveylabrig51'
            figpath = 'C:\Users\Shin\Documents\MATLAB\ShinData\Transfer\';
        case 'shin-pc'
            if dropbox_flag
                figpath = 'E:\Dropbox (HMS)\TempFigs\';
                % figpath = 'C:\Users\Shin\Dropbox (HMS)\TempFigs\';
            else
                figpath = 'C:\Users\Shin\Documents\MATLAB\ShinData\Transfer\';
            end
    end
        
    fig_name = headder;
    set(gcf,'color','w')
    switch format
        case 'eps'
            print2eps([figpath,fig_name,'.eps']);
        case 'png'
            export_fig(gcf,[figpath,fig_name,'.png'],'-png','-nocrop');
        case 'jpg'
            export_fig(gcf,[figpath,fig_name,'.jpg'],'-jpg','-nocrop');
    end
end