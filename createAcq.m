function createAcq(mouse_num,date_num,varargin)

    varargin2V(varargin);
    initials = getInitials(mouse_num);
    mouseID = sprintf('%s%03d',initials,mouse_num);
    server_name = 'scratch2';

    if exist('mouse_num','var') && exist('date_num','var')
        if ispc
            root_dir = '\\research.files.med.harvard.edu';
        elseif ismac
            root_dir = '/Volumes';
        end
        defaultDir = fullfile(root_dir,'Neurobio','HarveyLab','Tier2','Shin','ShinDataAll','Imaging',mouseID,num2str(date_num));
        save_dir   = fullfile(root_dir,'Neurobio','HarveyLab','Tier2','Shin','ShinDataAll','Imaging','BatchAcqObj');

    else
        error('Essential variables are missing!')
    end

    if ismember(mouse_num,[22,23,31,35,45])
        FOV_name = 'FOV1_00001';
    else
        FOV_name = 'FOV1_001';
    end
    
    Acq_name = [initials,sprintf('%03d',mouse_num),'_',num2str(date_num),'_',FOV_name];
    
    % create obj
    obj = Acquisition2P(Acq_name,@SK2Pinit,defaultDir);

    if ~exist('motionCorrectionFunction','var')
        % overwrite motion correction function
        obj.motionCorrectionFunction = @lucasKanade_plus_nonrigid;
    else
        obj.motionCorrectionFunction = motionCorrectionFunction;
    end
    fprintf('motionCorrectionFunction:\t%s\n',func2str(obj.motionCorrectionFunction));
    % select the server_name: data2; scratch2; no_backup;
    obj.defaultDir = changePath4Orchestra(obj.defaultDir,server_name);
    for i = 1:length(obj.Movies)
        obj.Movies{i} = changePath4Orchestra(obj.Movies{i},server_name);
    end
    fprintf('Will process movies saved @ %s\n',server_name)
    obj.save(save_dir)

return