function createAcqBatch

% mouse_set = [20,22,15];
% date_set = {[161115],[161207],[161128,161222,161229]};

% mouse_set = [9,20,22,15];
% date_set = {[160513,160517,160519,160520,160526],[161119,161206],[161205],[161125,161201,161216,161226]};

% mouse_set = [15];
% date_set = {[161125,161201,161216,161226]};

mouse_set = 35;
date_set = {[170502,170503,170504,170505,...
             170508,170509,170510,170511,170512,...
             170515,170516,1705017]};

save_dir = '\\research.files.med.harvard.edu\neurobio\HarveyLab\Shin\ShinDataAll\Imaging\BatchAcqObj';

for mi = 1:length(mouse_set)
    for di = 1:length(date_set{mi})
        mouse_num = mouse_set(mi);
        initials = getInitials(mouse_num);
        date_num = date_set{mi}(di);
        
        if ismember(mouse_num,[22,23,35])
            FOV_list = {'FOV1_00001'};
        else
            FOV_list = {'FOV1_001'};
        end

        if exist('mouse_num','var') && exist('date_num','var')
            defaultDir = sprintf('\\\\research.files.med.harvard.edu\\neurobio\\HarveyLab\\Shin\\ShinDataAll\\Imaging\\%s%03d\\%06d\\',...
                initials,mouse_num,date_num);
        else
            error('Essential variables are missing!')
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

            if ~exist('obj.motionCorrectionFunction','var')
                % overwrite motion correction function
                obj.motionCorrectionFunction = @lucasKanade_plus_nonrigid;
                % switch mouse_num
                %     case {1,3,16}
                %         obj.motionCorrectionFunction = @withinFile_fullFrame_fft;
                %     case {9,13,15,20,22,23,35}
                %         obj.motionCorrectionFunction = @lucasKanade_affineReg;
                % end
            else
                obj.motionCorrectionFunction = motionCorrectionFunction;
            end
            fprintf('motionCorrectionFunction:\t%s\n',func2str(obj.motionCorrectionFunction));
            obj.save(save_dir)
        end
    end
end

return