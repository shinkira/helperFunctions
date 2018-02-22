function dropboxPath = getDropboxPath(varargin)
    computerName = getComputerName;
    switch computerName
        case 'shin-pc'
            dropboxPath = 'C:\Users\Shin\Dropbox (HMS)';
        case 'harveylabrig51'
            dropboxPath = 'C:\Users\Shin\Dropbox (HMS)';
        case 'shinichiros-macbook-pro'
            dropboxPath = '/Users/shin/Dropbox (HMS)';
    end
    for i = 1:length(varargin)
        dropboxPath = fullfile(dropboxPath,varargin{i});
    end
end