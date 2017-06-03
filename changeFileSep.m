function new_name = changeFileSep(old_name)

    if ispc
        new_name = strrep(old_name,'/','\');
    elseif ismac
        new_name = strrep(old_name,'\','/');
    end