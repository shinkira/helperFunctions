function ServerName = changePath4Server(name)
    try
        name = strrep(name,'/','\');
        Shin_ind = strfind(name,'Shin');
        ServerName = ['\\research.files.med.harvard.edu\Neurobio\HarveyLab\',name(Shin_ind(1):end)];
    catch
        name = strrep(name,'/','\');
        Imaging_ind = strfind(name,'Imaging');
        ServerName = ['\\research.files.med.harvard.edu\Neurobio\HarveyLab\Shin\ShinDataAll\',name(Imaging_ind(1):end)];
    end
end