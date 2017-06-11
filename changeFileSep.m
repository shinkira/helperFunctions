function filename = changeFilesep(filename)
    
    filename = strrep(filename,'/',filesep);
    filename = strrep(filename,'\',filesep);
    
end