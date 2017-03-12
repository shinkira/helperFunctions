function ServerName = changePath4Server(name)
    name = strrep(name,'/','\');
    Shin_ind = strfind(name,'Shin');
    ServerName = ['\\research.files.med.harvard.edu\Neurobio\HarveyLab\',name(Shin_ind(1):end)];
end