function getComment(comment,n_shift,two_col)
    
    if ~isempty(comment) && ~isstr(comment)
        error('comment must be a string.')
    end
    
    if ~exist('two_col','var')
        two_col = false;
    end
    
    com_split = split(comment,'\n');
    
    max_width = 75;
    shift_length = 4;
    
    if isempty(comment)
        space = 0;
    else
        space = 1;
    end
    
    n_line = size(com_split,1);
    indent_length = n_shift * shift_length;
    marker_type = '%';
    
    if n_line==1
        str_size = length(comment);
        
        marker_length = max_width - (indent_length + str_size + space*2);
        marker_length1 = floor(marker_length/2);
        marker_length2 = ceil(marker_length/2);

        temp = [];
        for i = 1:max_width
            if i <= indent_length
                temp = [temp,' '];
            elseif i <= indent_length + marker_length1
                if i == indent_length+1
                    temp = [temp,'%'];
                else
                    temp = [temp,marker_type];
                end
            elseif i <= indent_length + marker_length1 + space
                temp = [temp,' '];
            elseif i <= indent_length + marker_length1 + space + str_size
                if i == indent_length + marker_length1 + space + str_size
                    temp = [temp,comment];
                end
            elseif i <= indent_length + marker_length1 + space*2 + str_size
                temp = [temp,' '];
            else
                temp = [temp,marker_type'];
            end
        end
        disp(temp);
    else
        if ~two_col
            addEmptyCommentLine(max_width,indent_length,marker_type)
            for ni = 1:n_line
                temp = [];
                str = com_split{ni,1};

                % remove the first spaces
                if ~isempty(str)
                    while isspace(str(1))
                        str = str(2:end);
                    end
                end

                str_size = length(str);

                for i = 1:max_width
                    if i <= indent_length
                        temp = [temp,' '];
                    elseif i<= indent_length + 1
                        temp = [temp,'%'];
                    elseif i<= indent_length + 1 + space
                        temp = [temp,' '];
                    elseif i<= indent_length + 1 + space + str_size
                        if i == indent_length + 1 + space + str_size
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
            addEmptyCommentLine(max_width,indent_length,marker_type)
        else % two columns
            if length(n_shift)==1
                n_shift(2) = 8;
                indent_length(2) = n_shift(2) * shift_length;
            end
            n_line_col = ceil(n_line/2);
            addEmptyCommentLine(max_width,indent_length,marker_type)
            for ni = 1:n_line_col
                temp = [];
                str{1} = com_split{ni,1};
                str{2} = com_split{ni+n_line_col,1};
                % remove the first spaces
                for mi = 1:2
                    while isspace(str{mi}(1))
                        str{mi} = str{mi}(2:end);
                    end
                    str_size(mi) = length(str{mi});
                end

                for i = 1:max_width
                    if i <= indent_length(1)
                        temp = [temp,' '];
                    elseif i<= indent_length(1) + 1
                        temp = [temp,'%'];
                    elseif i<= indent_length(1) + 1 + space
                        temp = [temp,' '];
                    elseif i<= indent_length(1) + 1 + space + str_size(1)
                        if i == indent_length(1) + 1 + space + str_size(1)
                            temp = [temp,str{1}];
                        end
                    elseif i<= indent_length(2)
                        temp = [temp,' '];
                    elseif i<= indent_length(2) + str_size(2)
                        if i == indent_length(2) + str_size(2)
                            temp = [temp,str{2}];
                        end
                    elseif i<= max_width-1
                        temp = [temp,' '];
                    else
                        temp = [temp,'%'];
                    end
                end
                disp(temp);
            end
            addEmptyCommentLine(max_width,indent_length,marker_type)
        end
    end
end

function addEmptyCommentLine(max_width,indent_length,marker_type)
    temp = [];
    for i = 1:max_width
        if i <= indent_length
            temp = [temp,' '];
        else
            temp = [temp,marker_type];
        end
    end
    disp(temp);
end

        
        
        