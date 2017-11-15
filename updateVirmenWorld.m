function updateVirmenWorld
    % updateVirmenWorld creates a T-maze with a T-intersection with cut
    % corners
    
    debug = 0;
    
    file_name = 'C:\Users\Shin\Documents\GitHub\virmen\experiments\Delay2TowersContCrutchSKver3_cutTint_2.mat';
    load(file_name);
    
    % add a symbolic variable
    exper.variables.cutLength = '40';
    exper.variables.reshapeSize = '16';
    
    if debug
        exper.movementFunction = @moveKeyboardOnly;
        exper.transformationFunction = @transformCylMex;
    else
        exper.movementFunction = @moveWithTwoSensors;
        exper.transformationFunction = @transformCylMex;
    end
    exper.experimentCode = @Delay2TowersContCrutchStim_cutTint;
    
    % delete object
    for i = 1:length(exper.worlds{1}.objects)
        obj_name{i} = exper.worlds{1}.objects{i}.name;
    end
    
    n_obj = length(exper.worlds{1}.objects);
    % n_vars = length(exper.variables);
    var_name = fieldnames(exper.variables);
    
    for i = 1:length(var_name)
        if strcmp(var_name{i},'computerName')
            continue
        end
        eval([var_name{i} ,'=', num2str(exper.variables.(var_name{i})) ';']);
    end

    for i = 1:n_obj
        switch obj_name{i}
            case{'LeftWallBlack','RightWallBlack','LeftWallWhite','RightWallWhite'}
        
                if strfind(obj_name{i},'LeftWall')
                    % X
                    exper.worlds{1}.objects{i}.symbolic.x{1,1} = 'playerStartX - mazeWidth/2';
                    exper.worlds{1}.objects{i}.symbolic.x{2,1} = 'playerStartX - mazeWidth/2';
                    % exper.worlds{1}.objects{i}.symbolic.x{3,1} = 'playerStartX - mazeWidth/2 - cutLength';
                    % Y
                    exper.worlds{1}.objects{i}.symbolic.y{1,1} = 'playerStartY';
                    exper.worlds{1}.objects{i}.symbolic.y{2,1} = 'playerStartY + mazeLengthAhead - cutLength';
                    % exper.worlds{1}.objects{i}.symbolic.y{3,1} = 'playerStartY + mazeLengthAhead';
                elseif strfind(obj_name{i},'RightWall')
                    % X
                    exper.worlds{1}.objects{i}.symbolic.x{1,1} = 'playerStartX + mazeWidth/2';
                    exper.worlds{1}.objects{i}.symbolic.x{2,1} = 'playerStartX + mazeWidth/2';
                    % exper.worlds{1}.objects{i}.symbolic.x{3,1} = 'playerStartX + mazeWidth/2 + cutLength';
                    % Y
                    exper.worlds{1}.objects{i}.symbolic.y{1,1} = 'playerStartY';
                    exper.worlds{1}.objects{i}.symbolic.y{2,1} = 'playerStartY + mazeLengthAhead - cutLength';
                    % exper.worlds{1}.objects{i}.symbolic.y{3,1} = 'playerStartY + mazeLengthAhead';
                end
                for j = 1:length(exper.worlds{1}.objects{i}.symbolic.x)
                    exper.worlds{1}.objects{i}.x(j,1) = eval(exper.worlds{1}.objects{i}.symbolic.x{j});
                end
                for j = 1:length(exper.worlds{1}.objects{i}.symbolic.y)
                    exper.worlds{1}.objects{i}.y(j,1) = eval(exper.worlds{1}.objects{i}.symbolic.y{j});
                end
                exper.worlds{1}.objects{i}.symbolic.tiling{2} = '(mazeLengthAhead - cutLength) / mazeWidth * 2';
                exper.worlds{1}.objects{i}.tiling(2) = eval(exper.worlds{1}.objects{i}.symbolic.tiling{2});
                                
            case {'LeftArmWallBlack','RightArmWallBlack','LeftArmWallWhite','RightArmWallWhite'}
                
                if strfind(obj_name{i},'Left')
                    exper.worlds{1}.objects{i}.symbolic.x = {'playerStartX - mazeWidth/2';
                                                             'playerStartX - mazeWidth/2 - cutLength';
                                                             'playerStartX - 0.5*mazeWidth - armLength';
                                                             'playerStartX - 0.5*mazeWidth - armLength';
                                                             'playerStartX'};

                    exper.worlds{1}.objects{i}.symbolic.y = {'playerStartY + mazeLengthAhead - cutLength';
                                                             'playerStartY + mazeLengthAhead';
                                                             'playerStartY + mazeLengthAhead';
                                                             'playerStartY + mazeLengthAhead + mazeWidth';
                                                             'playerStartY + mazeLengthAhead + mazeWidth'};

                else
                    exper.worlds{1}.objects{i}.symbolic.x = {'playerStartX + mazeWidth/2';
                                                             'playerStartX + mazeWidth/2 + cutLength';
                                                             'playerStartX + 0.5*mazeWidth + armLength';
                                                             'playerStartX + 0.5*mazeWidth + armLength';
                                                             'playerStartX'};

                    exper.worlds{1}.objects{i}.symbolic.y = {'playerStartY + mazeLengthAhead - cutLength';
                                                             'playerStartY + mazeLengthAhead';
                                                             'playerStartY + mazeLengthAhead';
                                                             'playerStartY + mazeLengthAhead + mazeWidth';
                                                             'playerStartY + mazeLengthAhead + mazeWidth'};
                end
                for j = 1:length(exper.worlds{1}.objects{i}.symbolic.x)
                    exper.worlds{1}.objects{i}.x(j,1) = eval(exper.worlds{1}.objects{i}.symbolic.x{j});
                end
                for j = 1:length(exper.worlds{1}.objects{i}.symbolic.y)
                    exper.worlds{1}.objects{i}.y(j,1) = eval(exper.worlds{1}.objects{i}.symbolic.y{j});
                end
                
            case {'LeftWallTest','RightWallTest'}
                
                if strfind(obj_name{i},'Left')
                    exper.worlds{1}.objects{i}.symbolic.x = {'playerStartX - mazeWidth/2';
                                                             'playerStartX - mazeWidth/2'};
                    exper.worlds{1}.objects{i}.symbolic.y = {'playerStartY + mazeLengthAhead * midOff';
                                                             'playerStartY + mazeLengthAhead - cutLength'};
                else
                    exper.worlds{1}.objects{i}.symbolic.x = {'playerStartX + mazeWidth/2';
                                                             'playerStartX + mazeWidth/2'};
                    exper.worlds{1}.objects{i}.symbolic.y = {'playerStartY + mazeLengthAhead * midOff';
                                                             'playerStartY + mazeLengthAhead - cutLength'};
                end
                for j = 1:length(exper.worlds{1}.objects{i}.symbolic.x)
                    exper.worlds{1}.objects{i}.x(j,1) = eval(exper.worlds{1}.objects{i}.symbolic.x{j});
                end
                for j = 1:length(exper.worlds{1}.objects{i}.symbolic.y)
                    exper.worlds{1}.objects{i}.y(j,1) = eval(exper.worlds{1}.objects{i}.symbolic.y{j});
                end
                exper.worlds{1}.objects{i}.symbolic.tiling{2} = '(mazeLengthAhead*(1-midOff) - cutLength) / mazeWidth * 2';
                exper.worlds{1}.objects{i}.tiling(2) = eval(exper.worlds{1}.objects{i}.symbolic.tiling{2});
                
            case 'FloorTest'
                exper.worlds{1}.objects{i}.symbolic.height = 'mazeWidth';
                exper.worlds{1}.objects{i}.symbolic.width = 'mazeLengthAhead * (1-midOff) - cutLength';
                exper.worlds{1}.objects{i}.symbolic.y = 'playerStartY + mazeLengthAhead * midOff + (mazeLengthAhead * (1-midOff) - cutLength)/2';
                exper.worlds{1}.objects{i}.symbolic.tiling{2} = '(mazeLengthAhead * (1-midOff) - cutLength)/mazeWidth*2';
                exper.worlds{1}.objects{i}.height = eval(exper.worlds{1}.objects{i}.symbolic.height);
                exper.worlds{1}.objects{i}.width = eval(exper.worlds{1}.objects{i}.symbolic.width);
                exper.worlds{1}.objects{i}.y = eval(exper.worlds{1}.objects{i}.symbolic.y);
                exper.worlds{1}.objects{i}.tiling(2) = eval(exper.worlds{1}.objects{i}.symbolic.tiling{2});
                
            case {'FloorBlack','FloorWhite','FloorWhiteLeft','FloorWhiteRight'}
                exper.worlds{1}.objects{i}.symbolic.y = '(mazeLengthAhead - cutLength)/2';
                exper.worlds{1}.objects{i}.symbolic.height = 'mazeLengthAhead - cutLength';
                exper.worlds{1}.objects{i}.symbolic.tiling{1} = '(mazeLengthAhead - cutLength)/mazeWidth*2';
                exper.worlds{1}.objects{i}.y = eval(exper.worlds{1}.objects{i}.symbolic.y);
                exper.worlds{1}.objects{i}.height = eval(exper.worlds{1}.objects{i}.symbolic.height);
                exper.worlds{1}.objects{i}.tiling(1) = eval(exper.worlds{1}.objects{i}.symbolic.tiling{1});
                
            case{'TTopMiddleFloor'}
                exper.worlds{1}.objects{i}.symbolic.y = 'mazeLengthAhead + mazeWidth - (cutLength + mazeWidth)/2';
                exper.worlds{1}.objects{i}.symbolic.width = 'cutLength + mazeWidth';
                exper.worlds{1}.objects{i}.symbolic.height = 'cutLength + mazeWidth';
                exper.worlds{1}.objects{i}.symbolic.tiling = {'(cutLength + mazeWidth)/mazeWidth','(cutLength + mazeWidth)/mazeWidth'};
                exper.worlds{1}.objects{i}.y = eval(exper.worlds{1}.objects{i}.symbolic.y);
                exper.worlds{1}.objects{i}.height = eval(exper.worlds{1}.objects{i}.symbolic.height);
                exper.worlds{1}.objects{i}.tiling(1) = eval(exper.worlds{1}.objects{i}.symbolic.tiling{1});
                exper.worlds{1}.objects{i}.tiling(2) = eval(exper.worlds{1}.objects{i}.symbolic.tiling{2});
                
        end 
    end
    
    obj_name = [obj_name,'FloorBlackLeftCorner','FloorBlackRightCorner','FloorWhiteLeftCorner','FloorWhiteRightCorner'];
    for k = 1:4
        i = i+1;
        % add objects: FloorBlackLeftCorner FloorBlackRightCorner
        if strfind(obj_name{i},'Black')
            exper.worlds{1}.addObject(exper.worlds{1}.objects{21},'copy');
        else
            exper.worlds{1}.addObject(exper.worlds{1}.objects{22},'copy');
        end
        exper.worlds{1}.objects{i}.name = obj_name{i};
        if strfind(obj_name{i},'Left')
            exper.worlds{1}.objects{i}.symbolic.x = 'playerStartX - mazeWidth/2 - cutLength/2';
        else
            exper.worlds{1}.objects{i}.symbolic.x = 'playerStartX + mazeWidth/2 + cutLength/2';
        end
        exper.worlds{1}.objects{i}.symbolic.y = 'playerStartY + mazeLengthAhead - cutLength/2';
        exper.worlds{1}.objects{i}.symbolic.width = 'cutLength + mazeWidth';
        exper.worlds{1}.objects{i}.symbolic.height = 'cutLength';
        exper.worlds{1}.objects{i}.symbolic.tiling = {'cutLength/mazeWidth';'cutLength/mazeWidth'};
        exper.worlds{1}.objects{i}.x = eval(exper.worlds{1}.objects{i}.symbolic.x);
        exper.worlds{1}.objects{i}.y = eval(exper.worlds{1}.objects{i}.symbolic.y);
        exper.worlds{1}.objects{i}.width = eval(exper.worlds{1}.objects{i}.symbolic.width);
        exper.worlds{1}.objects{i}.height = eval(exper.worlds{1}.objects{i}.symbolic.height);
        exper.worlds{1}.objects{i}.tiling(1) = 2;%eval(exper.worlds{1}.objects{i}.symbolic.tiling{1});
        exper.worlds{1}.objects{i}.tiling(2) = 2;%eval(exper.worlds{1}.objects{i}.symbolic.tiling{2});
    end
    
    file_name_new = 'C:\Users\Shin\Documents\GitHub\virmen\experiments\Delay2TowersContCrutchStim_cutTint.mat';
    save(file_name_new,'exper');
end