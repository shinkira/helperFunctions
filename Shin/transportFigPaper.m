function transportFigPaper(varargin)

    if length(varargin)<1
        format = 'pdf';
    else
        format = varargin{1};
    end
    if length(varargin)<2
        headder = 'temp';
    else
        headder = varargin{2};        
    end
        
    % Copy all figures to the transfer directory in PNG format
    switch getComputerName
        case 'shin-pc'
            dropbox_dir= 'E:\Dropbox (HMS)';
        case 'shin-macbook-pro'
            dropbox_dir = '/Users/shin/Dropbox (HMS)';        
    end
    figpath = fullfile(dropbox_dir,'DmtsShin','tempFigs');
        
    h = findobj('type','figure');
    n = length(h);
    fprintf('Saving %d figures in %s...\n',n,format);
    
    for i = 1:n
        fig_name = [headder,'_',num2str(h(i).Number)];
        figure(h(i).Number)
        set(gcf,'color','w')
        switch format
            case 'pdf'
                print(fullfile(figpath,[fig_name,'.pdf']),'-dpdf') 
            case 'eps'
                % print2eps([figpath,fig_name,'.eps'],gcf,opt);
                print(fullfile(figpath,[fig_name,'.eps']),'-depsc')
            case 'png'
                export_fig(gcf,fullfile(figpath,[fig_name,'.png']),'-png','-nocrop');
            case 'jpg'
                export_fig(gcf,fullfile(figpath,[fig_name,'.jpg']),'-jpg','-nocrop');
        end
    end
end