function figPref(font_size)

    if ~exist('font_size','var')
        font_size = 12;
    end
    
    set(0,'defaultaxesfontsize',font_size);
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
    set(0, 'DefaultFigurePosition', [-750   600   560   420])
end