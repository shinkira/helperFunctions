function createAcq(varargin)

varargin2V(varargin);

if ~exist('initials','var')
    initials = 'DA';
end

if exist('mouseID','var') && exist('date_num','var')
    defaultDir = sprintf('\\\\research.files.med.harvard.edu\\neurobio\\HarveyLab\\Shin\\ShinDataAll\\Imaging\\%s%03d\\%06d\\',...
        initials,mouseID,date_num);
else
    error('Essential variables are missing!')
end

for fi = 1:length(FOV_list)
    if iscell(FOV_list)
        FOV_name = [initials,sprintf('%03d',mouseID),'_',num2str(date_num),'_',FOV_list{fi}];
    elseif ischar(FOV_list)
        FOV_name = [initials,sprintf('%03d',mouseID),'_',num2str(date_num),'_',FOV_list];
    else
        error('FOV_list must be a Cell')
    end
    % create obj
    obj = Acquisition2P(FOV_name,@SK2Pinit,defaultDir);
    
    if ~exist('motionCorrectionFunction','var')
        % overwrite motion correction function
        switch mouseID
            case {1,3,16}
                obj.motionCorrectionFunction = @withinFile_fullFrame_fft;
            case {13,15,20,22}
                obj.motionCorrectionFunction = @withinFile_withinFrame_lucasKanade;
        end
    else
        obj.motionCorrectionFunction = motionCorrectionFunction;
    end
    fprintf('motionCorrectionFunction:\t%s\n',func2str(obj.motionCorrectionFunction));
    obj.save
    
end

return