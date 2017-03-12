function OrchestraName = changePath4Orchestra(name)
    name = strrep(name,'\','/');
    Shin_ind = strfind(name,'Shin');
    OrchestraName = ['/n/data2/hms/neurobio/harvey/',name(Shin_ind(1):end)];
end