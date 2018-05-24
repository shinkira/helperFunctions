function createAcqBatch(server_name)

if nargin<1
    server_name = 'scratch2';
    % error('select the server_name: data2; scratch2; no_backup');
end

github_dir = 'C:\Users\Shin\Documents\GitHub\DmtsShared\DMTS';
load(fullfile(github_dir,'info_set_good_okay.mat'));

mouse_set = [9,15,20,31,35,45];
for mi = 1:length(mouse_set)
    pick = cell2mat(info_set(:,1))==mouse_set(mi);
    date_set{mi} = cell2mat(info_set(pick,2));
end

if ispc
    save_dir = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier2\Shin\ShinDataAll\Imaging\BatchAcqObj';
else
    save_dir = '/Volumes/Neurobio/HarveyLab/Shin/ShinDataAll/Imaging/BatchAcqObj';
end

for mi = 1:length(mouse_set)
    for di = 1:length(date_set{mi})
        mouse_num = mouse_set(mi);
        mouseID = getMouseID(mouse_set(mi));
        initials = getInitials(mouse_num);
        date_num = date_set{mi}(di);
                
        if ismember(mouse_num,[22,23,31,35,45])
            FOV_list = {'FOV1_00001'};
        else
            FOV_list = {'FOV1_001'};
        end

        if exist('mouse_num','var') && exist('date_num','var')
            if ispc
                root_dir = '\\research.files.med.harvard.edu';
            elseif ismac
                root_dir = '/Volumes';
            end
            defaultDir = fullfile(root_dir,'Neurobio','HarveyLab','Tier2','Shin','ShinDataAll','Imaging',mouseID,num2str(date_num));
        else
            error('Essential variables are missing!')
        end
        
        if exist(fullfile(defaultDir,'Corrected'),'dir')
            fprintf('Skipping %s %d\n',mouseID,date_num)
            continue
        end
        

        for fi = 1:length(FOV_list)
            if iscell(FOV_list)
                FOV_name = [initials,sprintf('%03d',mouse_num),'_',num2str(date_num),'_',FOV_list{fi}];
            elseif ischar(FOV_list)
                FOV_name = [initials,sprintf('%03d',mouse_num),'_',num2str(date_num),'_',FOV_list];
            else
                error('FOV_list must be a Cell')
            end
            % create obj
            obj = Acquisition2P(FOV_name,@SK2Pinit,defaultDir);

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
        end
    end
end

return