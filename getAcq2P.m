function obj = getAcq2P(mouse_num,date_num)
    mouseID = sprintf('%s%03d',getInitials(mouse_num),mouse_num);
    img_dir = ['\\research.files.med.harvard.edu\Neurobio\HarveyLab\Shin\ShinDataAll\Imaging\',mouseID,'\',num2str(date_num),'\'];
    obj_name = sprintf('%s_%d_FOV1_001',mouseID,date_num);
    D = load(fullfile([img_dir,obj_name]));
    temp = fieldnames(D);
    obj = D.(temp{1});
end