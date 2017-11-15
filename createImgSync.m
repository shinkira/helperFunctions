function createImgSync(mouse_num,server)
    
    initials = getInitials(mouse_num);
    mouseID = sprintf('%s%03d',initials,mouse_num);
    date_list = getDateListImg(mouse_num);
        
    save_dir = 'C:\Users\Shin\Documents\MATLAB\ShinCode\Imaging';
    switch server
        case 'scratch2'
            file_name = sprintf('imgSync2scratch2_%s.sh',mouseID);
        case 'no_backup'
            file_name = sprintf('imgSync2NoBackup_%s.sh',mouseID);
    end
    
    fid = fopen(fullfile(save_dir,file_name),'w');
    
    num_session = size(date_list,1);
    
    for di = num_session-1:num_session
        date_num = date_list{di,1};
        switch server
            case 'scratch2'
                msg = sprintf(['rsync -av /files/Neurobio/HarveyLab/Shin/ShinDataAll/Imaging/%s/%d/*.tif ',...
                    '/n/scratch2/sk574/Imaging/%s/%d/'],mouseID,date_num,mouseID,date_num);
            case 'no_backup'
                msg = sprintf(['rsync -av /files/Neurobio/HarveyLab/Shin/ShinDataAll/Imaging/%s/%d/*.tif ',...
                    '/n/no_backup/neurobio/harvey/Shin/Imaging/%s/%d/'],mouseID,date_num,mouseID,date_num);
        end
        fprintf(fid,[msg,'\n\n']);
    end
    
    fclose(fid);

end