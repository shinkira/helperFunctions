function varargout = tiffRead(fPath, castType, isSilent, metaOnly)
% [img, metadata] = tiffRead(fPath, castType, isSilent)

%turn off warning thrown by reading in scanImage3 files
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning'),

if ~exist('castType', 'var') || isempty(castType)
    castType = 'double';
end

if ~exist('isSilent', 'var') || isempty(isSilent)
    isSilent = false;
end

if ~exist('metaOnly', 'var') || isempty(isSilent)
    metaOnly = false;
end

% Gracefully handle missing extension:
if exist(fPath, 'file') ~= 2
    if exist([fPath, '.tif'], 'file')
        fPath = [fPath, '.tif'];
    elseif exist([fPath, '.tiff'], 'file')
        fPath = [fPath, '.tiff'];
    else
        error(['Could not find ' fPath '.'])
    end
end

% Create Tiff object:
t = Tiff(fPath);

if ~metaOnly
    % Get number of directories (= frames):
    t.setDirectory(1);
    while ~t.lastDirectory
        t.nextDirectory;
    end
    nDirectories = t.currentDirectory;

    % Load all directories (= frames):
    img = zeros(t.getTag('ImageLength'), ...
        t.getTag('ImageWidth'), ...
        nDirectories, ...
        castType);

    for i = 1:nDirectories
        t.setDirectory(i);
        img(:,:,i) = t.read;
        if ~isSilent && ~mod(i, 200)
            fprintf('%1.0f frames of %d loaded.\n', i, nDirectories);
        end
    end

    varargout{1} = img;
end

%turn back on warning to avoid conflicts later
warning('on','MATLAB:imagesci:tiffmexutils:libtiffWarning'),

% Scanimage metadata: Tiffs saved by Scanimage contain useful metadata in
% form of a struct. This data can be requested as a second output argument.
if nargout > 1
    % Check if this Tiff has valid scanimage metadata and get version:
    try
        imgDesc = t.getTag('ImageDescription');
    catch
        try
            fPath = strrep(fPath,'TEST','FOV1');
            t = Tiff(fPath);
            imgDesc = t.getTag('ImageDescription');
            fprintf('For TEST files, scanimage metadata was extracted from FOV1 files')
        catch
            imgDesc = [];
        end
    end
    if isempty(imgDesc)
        scanImageVersion = -1;
    else
        if contains(imgDesc, 'scanimage')
            scanImageVersion = 4;
        elseif contains(imgDesc, 'state.')
            scanImageVersion = 3;
        elseif contains(imgDesc, 'dcOverVoltage')
            scanImageVersion = 2023;
            % scanImageVersion = 2016;
        else
            scanImageVersion = -1;
        end
    end
    
    switch scanImageVersion
        case 3
            lineDesc = regexp(imgDesc,'state.','start');
            lineDesc(end+1) = length(imgDesc)+1;
            for e = 1:length(lineDesc)-1
                eval([imgDesc(lineDesc(e):lineDesc(e+1)-2) ';']);
            end
            varargout{2} = state;
        case 4
            imgDescC = regexp(imgDesc, 'scanimage\..+? = .+?(?=\n)', 'match');
            imgDescC = strrep(imgDescC, '<nonscalar struct/object>', 'NaN');
            imgDescC = strrep(imgDescC, '<unencodeable value>', 'NaN');
            for e = imgDescC;
                eval(['s.' e{:} ';']);
            end
            varargout{2} = s.scanimage;
        case 2016
            info = imfinfo(fPath);
            temp = info.Software;
            ind = strfind(temp,'SI.');
            temp(ind(2:end)-1) = ';';
            temp(end) = ';';
            eval(temp);
            varargout{2} = SI;
            % siHeader = scanimage.util.opentif(fPath);
            % varargout{2} = siHeader;
        case 2023
            info = imfinfo(fPath);
            temp = info.Software;
            ind = strfind(temp,'SI.');
            temp(ind(2:end)-1) = ';';
            temp(end) = ';';
            %%
            for i = 1:length(ind)-1
                temp_cmd = temp(ind(i):ind(i+1)-1);
                try
                    eval(temp_cmd);
                catch
                    temp_cmd = insertBefore(temp_cmd,'[','''');
                    temp_cmd = insertAfter(temp_cmd,']','''');
                    eval(temp_cmd);
                end
            end
            
            % eval(temp);
            varargout{2} = SI;
            % siHeader = scanimage.util.opentif(fPath);
            % varargout{2} = siHeader;
        case -1
            % Not a scanimage file. Since a second output argument was
            % requested, we use a fake scanimage metadata to make the Acq2P
            % object work with non-scanimage tiffs:
            varargout{2} = createScanimageMetadataStruct;
            warning('Could not find scanimage metadata in raw tiff file. Using fake metadata generated by createScanimageMetadataStruct.m');
    end
end

% Close:
t.close();