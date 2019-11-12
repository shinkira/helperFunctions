function errbar(x,y,ye,color)
    
    if nargin<4
        color = 'k';
    end

    hold on
    h = errorbar(x,y,ye,'.','marker','none','color',color,'CapSize',10);
    h(1).LineWidth = 2;
    bar(x,y,'FaceColor',color);

end