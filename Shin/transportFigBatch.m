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
        case 'shin-macbook-pro'
            figpath = '/Users/shin/Dropbox (HMS)/TempFigs/';
        case 'harveylabrig51'
            figpath = 'C:\Users\Shin\Documents\MATLAB\ShinData\Transfer\';
        case 'shin-pc'
            if dropbox_flag
                figpath = 'E:\Dropbox (HMS)\TempFigs\';
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
                % opt.fontswap = 0;
                % print2eps([figpath,fig_name,'.eps'],gcf,opt);
                print([figpath,fig_name,'.eps'],'-depsc')
            case 'png'
                export_fig(gcf,[figpath,fig_name,'.png'],'-png','-nocrop');
            case 'jpg'
                export_fig(gcf,[figpath,fig_name,'.jpg'],'-jpg','-nocrop');
            case 'pdf'
                print([figpath,fig_name,'.pdf'],'-dpdf','-bestfit') 
        end
    end
end