function varargout = bigTiffRead(fPath, castType, isSilent)
% [img, metadata, frameDescriptions] = tiffRead(fPath, castType, isSilent)


if ~exist('castType', 'var')
    castType = [];
end

if ~exist('isSilent', 'var') || isempty(isSilent)
    isSilent = false;
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
% add DLL files to the system's PATH environment variable
[temp_path, ~, ~] = fileparts(which(mfilename));
setenv('PATH', [[temp_path,'\ScanImageTiffReader\bin'] pathsep() getenv('PATH')])
siTifObj = ScanImageTiffReader(fPath);
if isempty(castType)
    imgStack = data(siTifObj);
else
    switch castType
        case 'double'
            imgStack = double(data(siTifObj));
        case 'single'
            imgStack = single(data(siTifObj));
        case 'int16'
            imgStack = int16(data(siTifObj));
        case 'uint16'
            imgStack = uint16(data(siTifObj));
    end
end
varargout{1} = permute(imgStack,[2 1 3]);

if nargout > 1
    metaDataText = metadata(siTifObj);
    lineInd = strfind(metaDataText,'SI.');
    for i=1:length(lineInd)-1
        eval([metaDataText(lineInd(i):lineInd(i+1)-2) ';']);
    end
    SI.appendedMetaData = metaDataText(lineInd(end):end);
    varargout{2} = SI;
    if nargout > 2
        varargout{3} = descriptions(siTifObj);
    end
end

close(siTifObj);

%turn off warning thrown by reading in scanImage3 files
% warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning'),
% % Create Tiff object:
% t = Tiff(fPath);
% 
% % Get number of directories (= frames):
% t.setDirectory(1);
% while ~t.lastDirectory
%     t.nextDirectory;
% end
% nDirectories = t.currentDirectory;
% 
% % Load all directories (= frames):
% img = zeros(t.getTag('ImageLength'), ...
%     t.getTag('ImageWidth'), ...
%     nDirectories, ...
%     castType);
% 
% for i = 1:nDirectories
%     t.setDirectory(i);
%     img(:,:,i) = t.read;
%     if ~isSilent && ~mod(i, 200)
%         fprintf('%1.0f frames of %d loaded.\n', i, nDirectories);
%     end
% end
% 
% varargout{1} = img;
% 
% %turn back on warning to avoid conflicts later
% warning('on','MATLAB:imagesci:tiffmexutils:libtiffWarning'),

% Scanimage metadata: Tiffs saved by Scanimage contain useful metadata in
% form of a struct. This data can be requested as a second output argument.
% if nargout > 1
%     % Check if this Tiff has valid scanimage metadata and get version:
%     try
%         imgDesc = t.getTag('ImageDescription');
%     catch
%         imgDesc = [];
%     end
%     if isempty(imgDesc)
%         scanImageVersion = -1;
%     else
%         if ~isempty(strfind(imgDesc, 'scanimage'))
%             scanImageVersion = 4;
%         elseif ~isempty(strfind(imgDesc, 'state.'))
%             scanImageVersion = 3;
%         elseif ~isempty(strfind(imgDesc, 'dcOverVoltage'))
%             scanImageVersion = 2016;
%         else
%             scanImageVersion = -1;
%         end
%     end
%     
%     switch scanImageVersion
%         case 3
%             lineDesc = regexp(imgDesc,'state.','start');
%             lineDesc(end+1) = length(imgDesc)+1;
%             for e = 1:length(lineDesc)-1
%                 eval([imgDesc(lineDesc(e):lineDesc(e+1)-2) ';']);
%             end
%             varargout{2} = state;
%         case 4
%             imgDescC = regexp(imgDesc, 'scanimage\..+? = .+?(?=\n)', 'match');
%             imgDescC = strrep(imgDescC, '<nonscalar struct/object>', 'NaN');
%             imgDescC = strrep(imgDescC, '<unencodeable value>', 'NaN');
%             for e = imgDescC;
%                 eval(['s.' e{:} ';']);
%             end
%             varargout{2} = s.scanimage;
%         case 2016
%             siHeader = scanimage.util.opentif(fPath);
%             varargout{2} = siHeader;
%         case -1
%             % Not a scanimage file. Since a second output argument was
%             % requested, we use a fake scanimage metadata to make the Acq2P
%             % object work with non-scanimage tiffs:
%             varargout{2} = createScanimageMetadataStruct;
%             warning('Could not find scanimage metadata in raw tiff file. Using fake metadata generated by createScanimageMetadataStruct.m');
%     end
% end
% 
% % Close:
% t.close();