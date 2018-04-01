function getComment(comment,n_shift)
    
    if ~isempty(comment) && ~isstr(comment)
        error('comment must be a string.')
    end
    
    com_split = split(comment,'\n');
    
    max_width = 75;
    shift_size = 4;
    
    if isempty(comment)
        space = 0;
    else
        space = 1;
    end
    
    n_line = size(com_split,1);
    indent_size = n_shift * shift_size;
    marker_type = '%';
    
    if n_line==1
        str_size = length(comment);
        
        star_size = max_width - (indent_size + str_size + space*2);
        star_size1 = floor(star_size/2);
        star_size2 = ceil(star_size/2);

        temp = [];
        for i = 1:max_width
            if i <= indent_size
                temp = [temp,' '];
            elseif i <= indent_size + star_size1
                if i == indent_size+1
                    temp = [temp,'%'];
                else
                    temp = [temp,marker_type];
                end
            elseif i <= indent_size + star_size1 + space
                temp = [temp,' '];
            elseif i <= indent_size + star_size1 + space + str_size
                if i == indent_size + star_size1 + space + str_size
                    temp = [temp,comment];
                end
            elseif i <= indent_size + star_size1 + space*2 + str_size
                temp = [temp,' '];
            else
                temp = [temp,marker_type'];
            end
        end
        disp(temp);
    else
        addEmptyCommentLine(max_width,indent_size,marker_type)
        for ni = 1:n_line
            temp = [];
            str = com_split{ni,1};
            % remove first space
            while isspace(str(1))
                str = str(2:end);
            end
            
            str_size = length(str);
            
            for i = 1:max_width
                if i <= indent_size
                    temp = [temp,' '];
                elseif i<= indent_size + 1
                    temp = [temp,'%'];
                elseif i<= indent_size + 1 + space
                    temp = [temp,' '];
                elseif i<= indent_size + 1 + space + str_size
                    if i == indent_size + 1 + space + str_size
                        temp = [temp,str];
                    end
                elseif i<= max_width-1
                    temp = [temp,' '];
                else
                    temp = [temp,'%'];
                end
            end
            disp(temp);
        end
        
        addEmptyCommentLine(max_width,indent_size,marker_type)
    end
end

function addEmptyCommentLine(max_width,indent_size,marker_type)
    temp = [];
    for i = 1:max_width
        if i <= indent_size
            temp = [temp,' '];
        else
            temp = [temp,marker_type];
        end
    end
    disp(temp);
end

        
        
        