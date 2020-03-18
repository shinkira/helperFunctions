function moveFigBatch   
    
    screen_size = get(groot,'MonitorPositions');
    
    if ~exist('n_screen','var')
        n_screen = size(screen_size,1);
    end
    screen_width = screen_size(1,3);
    
    h = findobj('type','figure');
    n = length(h);
    for i = 1:n
        figure(h(i).Number)
        fig_pos = get(h(i),'OuterPosition');
        fig_pos(1) = mod(fig_pos(1),screen_width);
        set(h(i),'OuterPosition',fig_pos);
    end
end