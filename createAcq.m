function createAcq(mouse_num,date_num,FOV_list,varargin)

varargin2V(varargin);
initials = getInitials(mouse_num);
mouseID = sprintf('%s%03d',initials,mouse_num);

if exist('mouseID','var') && exist('date_num','var')
    defaultDir = sprintf('\\\\research.files.med.harvard.edu\\neurobio\\HarveyLab\\Shin\\ShinDataAll\\Imaging\\%s\\%06d\\',...
        mouseID,date_num);
else
    error('Essential variables are missing!')
end

for fi = 1:length(FOV_list)
    if iscell(FOV_list)
        FOV_name = [mouseID,'_',num2str(date_num),'_',FOV_list{fi}];
    elseif ischar(FOV_list)
        FOV_name = [mouseID,'_',num2str(date_num),'_',FOV_list];
    else
        error('FOV_list must be a Cell')
    end
    % create obj
    obj = Acquisition2P(FOV_name,@SK2Pinit,defaultDir);
    
    if ~exist('motionCorrectionFunction','var')
        
        obj.motionCorrectionFunction = @lucasKanade_plus_nonrigid;
            
    else
        obj.motionCorrectionFunction = motionCorrectionFunction;
    end
    fprintf('motionCorrectionFunction:\t%s\n',func2str(obj.motionCorrectionFunction));
    obj.save
    
end

return