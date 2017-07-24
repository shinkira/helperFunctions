function createImgSync(mouse_num)
    
    initials = getInitials(mouse_num);
    mouseID = sprintf('%s%03d',initials,mouse_num);
    date_list = getDateListImg(mouse_num);
        
    save_dir = 'C:\Users\Shin\Documents\MATLAB\ShinCode\Imaging';
    file_name = sprintf('imgSync2NoBackup_%s.sh',mouseID);
    
    fid = fopen(fullfile(save_dir,file_name),'w');
    
    for di = 1:size(date_list,1)
        date_num = date_list{di,1};
        msg = sprintf(['rsync -av /files/Neurobio/HarveyLab/Shin/ShinDataAll/Imaging/%s/%d/*.tif ',...
            '/n/no_backup/neurobio/harvey/Shin/Imaging/%s/%d/'],mouseID,date_num,mouseID,date_num);
    
        fprintf(fid,[msg,'\n\n']);
    end
    
    fclose(fid);

end