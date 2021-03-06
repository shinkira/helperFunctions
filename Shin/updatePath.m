function fpath_new = updatePath(fpath)

    fpath_new = fpath;
    
    if ismac
        fpath_split = split(fpath,'\');
        ind_split = find(strcmp(fpath_split,'ShinDataAll'));
        if ~isempty(ind_split)
            fpath_new = fullfile('/Users/shin/Dropbox (HMS)/data',fpath_split{ind_split:end});
        else
            ind_split = find(strcmp(fpath_split,'GitHub'));
            if ~isempty(ind_split)
                fpath_new = fullfile('/Users/shin/Documents',fpath_split{ind_split:end});
            else
                error('ShinDataAll not included in the file path.');
            end
        end
    end
    if ispc
        fpath_split = split(fpath,'\');
        ind_split = find(strcmp(fpath_split,'ShinDataAll'));
        if ~isempty(ind_split)
            fpath_new = fullfile('E:\Dropbox (HMS)\data',fpath_split{ind_split:end});
        end
    end
end