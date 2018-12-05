function addDropboxPath
    computerName = getComputerName;
    switch computerName
        case 'shin-pc'
            dropboxPath = 'C:\Users\Shin\Dropbox (HMS)';
        case 'harveylabrig51'
            dropboxPath = 'C:\Users\Shin\Dropbox (HMS)';
        case 'shin-macbook-pro'
            dropboxPath = '/Users/shin/Dropbox (HMS)';
        case 'shin-mbp'
            dropboxPath = '/Users/shin/Dropbox (HMS)'; 
    end
    addpath(genpath(dropboxPath),'-END');
end