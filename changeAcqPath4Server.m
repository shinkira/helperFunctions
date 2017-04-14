function changeAcqPath4Server(obj)  
    % change the paths from Orchestra to Server
    
    % obj.Movies{1} = changePath4Server(obj.Movies{1});
    % [mov, scanImageMetadata] = obj.readRaw(1,'single');
    % [movStruct, nSlices, nChannels] = parseScanimageTiff(mov, scanImageMetadata);
    
    % extract the number of slices and channels
    if ~isempty(obj.indexedMovie)
        nSlices = length(obj.indexedMovie.slice);
        nChannels = length(obj.indexedMovie.slice(1).channel);
    else
        nSlices = 1;
        nChannels = 1;
    end
    
    % raw movies
    for mi = 1:length(obj.Movies)
        obj.Movies{mi} = changePath4Server(obj.Movies{mi});
    end
    for si = 1:nSlices
        % covFile
        if ~isempty(obj.roiInfo)
            obj.roiInfo.slice(si).covFile.fileName = changePath4Server(obj.roiInfo.slice(si).covFile.fileName);
        end
        for ci = 1:nChannels
            % indexedMovie
            if ~isempty(obj.indexedMovie)
                obj.indexedMovie.slice(si).channel(ci).fileName = changePath4Server(obj.indexedMovie.slice(si).channel(ci).fileName);
            end
            % corrected movies
            for mi = 1:length(obj.correctedMovies.slice(si).channel(ci).fileName)
                obj.correctedMovies.slice(si).channel(ci).fileName{mi} = changePath4Server(obj.correctedMovies.slice(si).channel(ci).fileName{mi});
            end
        end
    end
    % default path
    obj.defaultDir = changePath4Server(obj.defaultDir);
    obj.save;
end