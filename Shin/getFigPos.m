function getFigPos

    pos = get(gcf,'outerposition');
    pos = round(pos,-1);
    
    round_pix = 50;
    
    for i = 1:4
        pos(i) = round_pix*round(pos(i)/round_pix);
    end
    
    fprintf('\nset(gcf,''OuterPosition'',[%d %d %d %d])\n\n',pos(1),pos(2),pos(3),pos(4));

end