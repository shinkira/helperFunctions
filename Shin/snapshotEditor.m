function snapshotEditor(mode,f_name_new)

f_name1  = 'MATLABDesktop.xml';
f_name2 = 'MATLAB_Editor_State.xml';
if ~exist('f_name_new','var') || isempty(f_name_new)
    date_str = datestr(now,'yymmdd_HHMMSS');
    f_name1_new = sprintf('%s_MATLABDesktop.xml',date_str);
    f_name2_new = sprintf('%s_MATLAB_Editor_State.xml',date_str);
end

v = version;
R_ind = strfind(v,'R');
matlab_ver = v(R_ind:R_ind+5);

AppDataDir = prefdir;
MyDir      = fullfile(userpath,'snapshotEditor',matlab_ver);

if ~exist(MyDir,'dir')
    mkdir(MyDir);
end

switch mode
    case 'save'
        copyfile(fullfile(AppDataDir,f_name1),fullfile(MyDir,f_name1_new));
        copyfile(fullfile(AppDataDir,f_name2),fullfile(MyDir,f_name2_new));
    case 'restore'
        cd(MyDir)
        [f_temp] = uigetfile('*.xml');
        f_temp_split = split(f_temp,'_');
        date_str = [f_temp_split{1},'_',f_temp_split{2}];
        f_name1_new = sprintf('%s_MATLABDesktop.xml',date_str);
        f_name2_new = sprintf('%s_MATLAB_Editor_State.xml',date_str);
        copyfile(fullfile(MyDir,f_name1_new),fullfile(AppDataDir,f_name1));
        copyfile(fullfile(MyDir,f_name2_new),fullfile(AppDataDir,f_name2));
        exit(0);
end