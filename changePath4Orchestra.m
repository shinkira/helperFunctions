function OrchestraName = changePath4Orchestra(name,server_name)
    name = strrep(name,'\','/');
    switch server_name
        case 'data2'
            %%% save in the permanent folder (data2) ***
            Shin_ind = strfind(name,'Shin');
            OrchestraName = ['/n/data2/hms/neurobio/harvey/',name(Shin_ind(1):end)];
        case 'scratch2'
            %%% save in the temporary folder (scratch2) ***
            Imaging_ind = strfind(name,'Imaging');
            OrchestraName = ['/n/scratch2/sk574/',name(Imaging_ind(1):end)];
        case 'no_backup'
            %%% save in the temporary folder (no_backup) ***
            Imaging_ind = strfind(name,'Imaging');
            OrchestraName = ['/n/no_backup/harvey/Shin/',name(Imaging_ind(1):end)];
    end
end