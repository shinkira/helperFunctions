function figPref(font_size)

    if ~exist('font_size','var')
        font_size = 12;
    end
    
    set(0,'DefaultAxesFontSize',font_size);
    set(0,'defaulttextfontsize',font_size);
    set(0,'defaultaxesfontweight','bold');
    set(0,'defaulttextfontweight','bold');
    if 0
        set(0,'defaultaxesfontsize',6);
        set(0,'defaulttextfontsize',6);
    end
    set(0,'defaultaxestickdir','out');
    set(0,'defaultaxestickdirmode','manual');
    set(0,'defaultaxesbox','off');
    set(0,'defaultFigureColor','w');
    screen_size = get(groot,'MonitorPositions');
    if size(screen_size,1)==2
        size_h = 560;
        size_v = 420;
        x_pos = screen_size(1,1) + screen_size(1,3)/2 - size_h - 10;
        y_pos = screen_size(1,2) + screen_size(1,4)/2 - size_v/2;
        set(0, 'DefaultFigurePosition', [x_pos y_pos size_h size_v]);
    end
end