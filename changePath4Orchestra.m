function OrchestraName = changePath4Orchestra(name)
    name = strrep(name,'\','/');
    %%% save in the temporary folder (scratch2) ***
    Imaging_ind = strfind(name,'Imaging');
    OrchestraName = ['/n/scratch2/sk574/',name(Imaging_ind(1):end)];
    %%% save in the permanent folder (data2) ***
    % Shin_ind = strfind(name,'Shin');
    % OrchestraName = ['/n/data2/hms/neurobio/harvey/',name(Shin_ind(1):end)];
end