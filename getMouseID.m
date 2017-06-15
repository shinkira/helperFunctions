function mouseID = getMouseID(mouse_num)
    mouseID = sprintf('%s%03d',getInitials(mouse_num),mouse_num);
end