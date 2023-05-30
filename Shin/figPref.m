function figPref(font_size,n_screen,line_width,varargin)

    if ~exist('font_size','var') || isempty(font_size)
        font_size = 12;
    end
    
    if ~exist('line_width','var') || isempty(line_width)
        line_width = 0.25;
    end
    
    n = length(varargin);
    if ~isempty(n)
        if mod(n,2)
            error('Name-value pairs are expected.');
        end
    end
    
    set(0,'DefaultAxesLineWidth',line_width);
    set(0,'DefaultAxesFontSize',font_size);
    set(0,'defaulttextfontsize',font_size);
    set(0,'defaultaxesfontweight','normal'); % 'bold'
    set(0,'defaulttextfontweight','normal'); % 'bold'
    set(0,'defaultAxesFontName', 'Arial')
    set(0,'defaultTextFontName', 'Arial')
    if 0
        set(0,'defaultaxesfontsize',6);
        set(0,'defaulttextfontsize',6);
    end
    set(0,'defaultaxestickdir','out');
    set(0,'defaultaxestickdirmode','manual');
    set(0,'defaultAxesBox','off');
    set(0,'defaultFigureColor','w');
    screen_size = get(groot,'MonitorPositions');
    
    if ~exist('n_screen','var') || isempty(n_screen)
        n_screen = size(screen_size,1);
    end
    size_h = 560;
    size_v = 420;
    switch n_screen
        case {1,3}
            x_pos = screen_size(1,1) + screen_size(1,3)/2 - size_h - 10;
            y_pos = screen_size(1,2) + screen_size(1,4)/2 - size_v/2;
        case 2
            x_pos = screen_size(1,1) + screen_size(2,3)/2 - size_h - 10;
            y_pos = screen_size(1,2) + screen_size(2,4)/2 - size_v/2;
    end
    set(0, 'DefaultFigurePosition', [x_pos y_pos size_h size_v]);
    
    % use get(groot, 'factory') to see all the default settings
    default_color = [0 0 0];
    set(0,'defaultAxesGridColor',default_color);
    set(0,'defaultAxesXColor',default_color);
    set(0,'defaultAxesYColor',default_color);
    set(0,'defaultAxesZColor',default_color);
    set(0,'defaultGeoaxesGridColor',default_color);
    set(0,'defaultHistogram2EdgeColor',default_color);
    set(0,'defaultPolaraxesGridColor',default_color);
    set(0,'defaultPolaraxesRColor',default_color);
    set(0,'defaultPolaraxesThetaColor',default_color);
    % plot with longer ticks
    set(0,'defaultAxesTickLength',2.*[0.010 0.025]);% default [0.010 0.025]
    
    h = get(groot, 'factory');
    fn = fieldnames(h);
    ind = find(contains(fn,'LineWidth'));
    for i = 1:length(ind)
        try
            set(0,['default',fn{ind(i)}(8:end)],line_width);
        catch
            set(0,['default',fn{ind(i)}(8:end)],'auto');
        end
    end
    
    % overwrite default by varargin
    for i = 1:2:n
        set(0,varargin{i},varargin{i+1});
    end
end