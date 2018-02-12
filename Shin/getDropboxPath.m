function dropboxPath = getDropboxPath
    computerName = getComputerName;
    switch computerName
        case 'shin-pc'
            dropboxPath = 'C:\Users\Shin\Dropbox (HMS)';
        case 'harveylabrig51'
            dropboxPath = 'C:\Users\Shin\Dropbox (HMS)';
        case 'shinichiros-macbook-pro'
            dropboxPath = '/Users/shin/Dropbox (HMS)';
    end
end