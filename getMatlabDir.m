function matlab_dir = getMatlabDir

    temp = userpath;
    matlab_dir = strrep(temp,':',filesep);
    
end