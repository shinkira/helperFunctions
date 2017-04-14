function createAcqBatch

if ~exist('FOV_list','var')
    FOV_list = {'FOV1_001'};
end

mouse_set = [20,15,9,23];
% date_set = {[161114,161117,161221],[161129,161227,170112,161205,161221],[160525,160516,160613]};
% date_set = {161120,[],160608};
% date_set = {[],[161219,170112],[160516,160525],[170306,170307,170308,170309,170310,170313]};
% date_set = {[],[],[],[170306,170307,170308,170309,170310,170313]};
% date_set = {[],[],[],[170309,170313,170314,170317,170320,170321]};
date_set = {[],[],[],[170313]};

save_dir = '\\research.files.med.harvard.edu\neurobio\HarveyLab\Shin\ShinDataAll\Imaging\BatchAcqObj';

for mi = 1:length(mouse_set)
    for di = 1:length(date_set{mi})
        mouse_num = mouse_set(mi);
        initials = getInitials(mouse_num);
        date_num = date_set{mi}(di);
        
        if mouse_num==23
            FOV_list = {'FOV1_00001'};
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

            if ~exist('motionCorrectionFunction','var')
                % overwrite motion correction function
                switch mouse_num
                    case {1,3,16}
                        obj.motionCorrectionFunction = @withinFile_fullFrame_fft;
                    case {9,13,15,20,22,23}
                        obj.motionCorrectionFunction = @lucasKanade_affineReg;
                end
            else
                obj.motionCorrectionFunction = motionCorrectionFunction;
            end
            fprintf('motionCorrectionFunction:\t%s\n',func2str(obj.motionCorrectionFunction));
            obj.save(save_dir)
        end
    end
end

return