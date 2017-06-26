function copyDataFile(mouse_num,date_num)
    
    mouseID = getMouseID(mouse_num);
    dir_from = fullfile('\\research.files.med.harvard.edu\Neurobio\HarveyLab\shin\ShinDataAll\Suite2P',mouseID,num2str(date_num));
    dir_to   = fullfile('\\research.files.med.harvard.edu\Neurobio\HarveyLab\shin\ShinDataAll\Suite2P',mouseID,num2str(date_num));
    
    if ~exist(dir_to,'dir')
        mkdir(dir_to);
        fprintf('Created a new directory:\n%s\n',dir_to)
    end

    file_name_from = sprintf('F_%s_%d_plane1_proc.mat',mouseID,date_num);
    file_name_to   = sprintf('F_%s_%d_plane1_proc_50prctile.mat',mouseID,date_num);
    [success,~,~] = copyfile(fullfile(dir_from,file_name_from),fullfile(dir_to,file_name_to));
    
    if success
        fprintf('%s was copied to %s successfully.\n\n',file_name_from,file_name_to);
    else
        error('%s was not copied appropriately.\n\n',file_name_from);
    end
    
end