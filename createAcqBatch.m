function createAcqBatch(server_name)

if nargin<1
    server_name = 'scratch2';
    % error('select the server_name: data2; scratch2; no_backup');
end

% ALL
% mouse_set = [9,20,22,15,35];
% date_set = {[160516,160525,160608,160613,160513,160517,160519,160520,160526],...
%             [161114,161117,161120,161221,161229,161115,161119,161206],...
%             [161129,161201,161205,161207],...
%             [161129,161205,161219,161221,161223,161227,170112,170116,170117,161125,161128,161201,161216,161222,161226,161229],...
%             [170502,170504,170505,170508,170509,170510,170511,170512,170516,170515,170517,170518,170519]};

% PPC
% mouse_set = [9,20,22,15];
% date_set = {[160516,160525,160608,160613],...
%             [161114,161117,161120,161130,161221,161229],...
%             [161129,161201],...
%             [161129,161205,161219,161221,161223,161227,170112,170116,170117]};
        
% V1 & RSP
% mouse_set = [9,20,22,15];
% date_set = {[160513,160517,160519,160520,160526],...
%             [161115,161119,161206],...
%             [161205,161207],...
%             [161125,161128,161201,161216,161222,161226,161229]};

% % M1 & M2
% 
mouse_set = [31];
date_set = {[170922]};

% mouse_set = [31];
% date_set = {[170811,170815,170816,170817,170818,...
%              170821,170822,170823,170824,170825,...
%              170828,170829,170830,170831,170901,...
%              170904,170905]};
         
% mouse_set = [45];
% date_set = {[170822,170823,170824,170825,...
%              170828,170829,170830,170831]};

         

% mouse_set = [35,31];
% date_set = {[170515,170516,170517,170518,170519,170522],...
%             [170623,170628,170629,170702,170703,170706,170707]};
        
% date_set = {[170502,170503,170504,170505,170508,170509,170510,170511,170512,...
%              170515,170516,170517,170518,170519,170522]};
         
% % M1 & M2
% mouse_set = 35;
% date_set = {[999999]};


if ispc
    save_dir = '\\research.files.med.harvard.edu\neurobio\HarveyLab\Shin\ShinDataAll\Imaging\BatchAcqObj';
else
    save_dir = '/Volumes/Neurobio/HarveyLab/Shin/ShinDataAll/Imaging/BatchAcqObj';
end

for mi = 1:length(mouse_set)
    for di = 1:length(date_set{mi})
        mouse_num = mouse_set(mi);
        initials = getInitials(mouse_num);
        date_num = date_set{mi}(di);
        
        if ismember(mouse_num,[22,23,35,31,45])
            FOV_list = {'FOV1_00001'};
        else
            FOV_list = {'FOV1_001'};
        end

        if exist('mouse_num','var') && exist('date_num','var')
            if ispc
                defaultDir = sprintf('\\\\research.files.med.harvard.edu\\neurobio\\HarveyLab\\Shin\\ShinDataAll\\Imaging\\%s%03d\\%06d\\',...
                    initials,mouse_num,date_num);
            else
                defaultDir = sprintf('/Volumes/Neurobio/HarveyLab/Shin/ShinDataAll/Imaging/%s%03d/%06d/',...
                    initials,mouse_num,date_num);
            end
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