function	varargout = dep2txt(src, varargin)
% function	[treeList, uniquePaths, uniqueFiles] = dep2txt(src, ['optionName1', value1, 'optionName2', value2, ...])
% INPUT:
%	src			: .m file to analyze
%	option		: in the form of 'optionName1', value1, optionName2, value2, ...
%
%		optionNames are case sensitive.
%
% 		outFile	: text file to write the result. 
% 				  omit if you don't want a file output.
% 		maxDepth: maximum depth to search. inf for unlimited. default is inf.
%				  if zipFile is specified, the default is inf.
% 		nameOnly: 1(default): exclude path if the same as src
%				  2: exclude all path
% 		filtIn	: if nonzero, only files that has filt in their full path are INcluded.
% 				  if zero, only files that has filt in their full path are EXcluded.
% 				  default is zero.
% 		filt	: cell array of filter strings. 
% 				  default is {'toolbox'}. good for filtering out obvious entries.
% 		verbose	: 1 - display unique paths (default); 2 - display whole tree.
%		zipFile : if specified with non-empty string, 
%                 zips all the files that the src file depends on, 
%				  including the src file itself, with the specified zipFile name.
%		zipAdd	: cell string of file names. Added to the zipFile.
%				  
% WARNING:
% (1)   Use dynamic calling with function pointer (@) rather than function name ('').
%       otherwise, dep2txt will fail to recognize the dependence.
%       e.g. fminsearch(@poo, ...) rather than fminsearch('poo', ...)
%
% (2)   In a script, first import package.fun and use the function/script, 
%       rather than using package.fun directly in the program.
%
% OUTPUT:
%	treeList(,;) : {'fileName', depth, recursive} (cell array)
%   uniquePaths  : List of unique paths.
%
%	text output:
%		asterisk(*) at the end of an entry means it is called recursively.
% 
% SAMPLE INPUT & OUTPUT
% 
% dep2txt('VMFB_GLM', 'maxDepth', 5)
% 
% VMFB_GLM
% 	GLM_RFX
% 		RFX_contrastFnc
% 			sub_makeNCdDstDirs
% 		RFX_specifyChangeFileOnlyFnc
% 			GLM_estimate
% 				sub_makeNCopySpmToDstDir
% 			sub_makeNCdDstDirs
% 		sub_unpackStruct
% 		test
% 	GLM_loadSessions
%
% Written by Yul Kang, 2011. yul dot kang dot on at gmail dot com
% This file is licensed under 
% Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. 
% See http://creativecommons.org/licenses/by-nc-sa/3.0/
% for details.

if iscellstr(varargin)
	strargin2var(varargin);
else
	varargin2var(varargin);
end
allParent = {};

src = which(src);

if ~exist('outFile', 'var'),	outFile = '';		end
if ~exist('nameOnly', 'var'),	nameOnly = 2;		end
if ~exist('filtIn', 'var'),		filtIn = 0;			end
if ~exist('filt', 'var'),		filt = {'toolbox'}; end
if ~exist('verbose', 'var'),	verbose = 2;		end
if ~exist('zipFile', 'var')
	zipFile = '';		
else
	if ~isempty(zipFile) %#ok<NODEF>
		if ~exist('maxDepth', 'var')
			maxDepth = inf;
		end
		if ~any(zipFile=='.')
			zipFile = [zipFile '.zip'];
		end
		if ~exist('zipAdd', 'var'), zipAdd = {}; end
	end
end
if ~exist('maxDepth', 'var'),	maxDepth = inf;		end

nFilt = length(filt);
srcDir = fileparts(src);

% Because default depfun often crashes, use '-toponly' option to go step by step..
% filtering takes place within chldrenTreesPrudent
% since the whole list is not available at the beginning, needs to carry cellStr of full paths
if verbose == 2
    fprintf('\n');
end

meStr = src;
ancestorsCell = {};
treeListCell = childrenTreesPrudent(meStr, ancestorsCell, maxDepth);

if verbose == 2
    fprintf('\n');
end

% print out tree structure
if ~isempty(outFile)
    treeCell2Txt(treeListCell, outFile, nameOnly);
end

% zip
uniqueFiles = cellstr(unique(char(treeListCell(:,1)),'rows'));

if ~isempty(zipFile)
    filesToZip = vertcat(uniqueFiles, zipAdd(:));
    
	rootDir = fullfile(fileparts(zipFile), 'dep2txt_');
	[anyPackage, filesToZip] = copyPackageFiles(filesToZip, rootDir);

    % May remove copying when ~anyPackage in copyPackageFiles to save time.
    
    zip(zipFile, filesToZip');
    rmdir(rootDir, 's');

    if ~isempty(zipAdd) && verbose == 2
        fprintf('Additional files zipped together:\n');
        fprintf('\t%s\n', zipAdd{:});
        fprintf('\n');
    end

    if verbose == 2
        fprintf('Zipped %d files to %s.\n', ...
                length(filesToZip) + length(zipAdd), zipFile);
    end
end
	
% return unique paths
uniquePaths = unique(cellfun(@fileparts, treeListCell(:,1), 'UniformOutput', false));

if verbose >= 1
    fprintf('\n');
    fprintf('Unique files that %s depends on:\n', src);
    fprintf('  %s\n', uniqueFiles{:});
    fprintf('\n');
    fprintf('Unique paths that %s depends on:\n', src);
    fprintf('  %s\n', uniquePaths{:});
    fprintf('\n');
end

if nargout>0
    varargout = {treeListCell, uniquePaths};
end

    function treeListCell = childrenTreesPrudent(meStr, ancestorsCell, maxDepth)
        % treeList = childrenTrees(me, ancestors, maxDepth)
        % treeList(,;) = [iEntry depth recursive]

        % show depth structure immediately
        depth = length(ancestorsCell) + 1;
        if verbose == 2
            fprintf(repmat('\t', [1  depth-1]));
            if nameOnly==2
                [pathStr name] = fileparts(meStr); %#ok<ASGLU>
                fprintf(name);
            elseif nameOnly==1
                [pathStr name] = fileparts(meStr);
                if strcmp(pathStr,srcDir)
                    fprintf(name);
                else
                    fprintf(meStr);
                end
            else
                fprintf(meStr);
            end
        end

        % get list of immediate parents
        [topList builtIns matlabClasses probFiles probSymbols evalStrings topParent] = ...
            depfun(meStr, '-quiet', '-toponly');
        nList = length(topList);

        % filter
        toIncl = ones(nList,1) * (~filtIn);
        for iFilt = 1:nFilt
            cFilt = filt{iFilt};

            for iList = 2:nList
                if ~isempty(strfind(topList{iList},cFilt))
                    toIncl(iList) = filtIn;
                end
            end
        end
        toIncl = setdiff(find(toIncl)', 1);

        % meStr
        % ancestorsCell
        % topList
        % toIncl

        % find out tree structure
        if anyMatchCellStr(ancestorsCell, topList(toIncl)) % if recursive
            treeListCell = {meStr depth 1};
            if verbose == 2
                fprintf('*\n');
            end
            return;
        else
            if verbose == 2
                fprintf('\n');
            end
            treeListCell = {meStr depth 0};	
            if depth >= maxDepth, return; end

            for iEntry = toIncl
                cEntry = topList{iEntry};
                treeListCell = vertcat(treeListCell, ...
                            childrenTreesPrudent(cEntry, horzcat(ancestorsCell, {meStr}), maxDepth));
            end
        end
    end

    function treeList = childrenTrees(me, ancestors, maxDepth)
        % treeList = childrenTrees(me, ancestors, maxDepth)
        % treeList(,;) = [iEntry depth recursive]

        depth = length(ancestors) + 1;
        treeList = [me  depth  0];

        if depth >= maxDepth, return; end

        for iEntry = setdiff(toIncl,me)
            if any(allParent{iEntry} == me)
                if any(iEntry == ancestors)
                    treeList(end+1,:) = [iEntry  depth+1  1]; %#ok<AGROW>
                else
                    treeList = [treeList; 
                                childrenTrees(iEntry, [ancestors me], maxDepth)]; %#ok<AGROW>
                end
            end
        end
    end
end


function [anyPackage, filesToZip] = copyPackageFiles(filesToZip, rootDir)
if ~exist(rootDir, 'dir')
    mkdir(rootDir);
end

anyPackage = false;

n = length(filesToZip);
for ii = 1:n
    [pth nam ext] = fileparts(filesToZip{ii});
    
    cLoc = min([strfind(pth, '/+'), strfind(pth, '/@')]);
    
    if ~isunix
        cLoc = min(cLoc, [strfind(pth, '\+'), strfind(pth, '\@')]);
    end
    cLoc = min(cLoc);
    
    if ~isempty(cLoc)
        anyPackage = true;
        newLoc = fullfile(pth((cLoc+1):end), [nam ext]);        
    else
        newLoc = fullfile([nam ext]);
    end
    
    newPth = fileparts(newLoc);
    if ~isempty(newPth) && ~exist(fullfile(rootDir, newPth), 'dir')
        mkdir(fullfile(rootDir, newPth));
    end
    copyfile(filesToZip{ii}, fullfile(rootDir, newLoc));
    filesToZip{ii} = newLoc;
end
end


function rmPackageFiles(filesToZip, rootDir)
end


function res = anyMatchCellStr(cellStr1, cellStr2)
% receives two one-dimensional cellStr, and tell if any of the strings are identical.
len1 = length(cellStr1); len2 = length(cellStr2);

if len1 > len2
	for iStr = 1:len2
		if any(strcmp(cellStr2{iStr}, cellStr1)), res = true; return; end
	end
else % len1 <= len2
	for iStr = 1:len1
		if any(strcmp(cellStr1{iStr}, cellStr2)), res = true; return; end
	end
end
res = false;
end


function treeCell2Txt(treeListCell, outFile, nameOnly)
% function treeCell2Txt(treeListCell, outFile, nameOnly)

if ~isempty(outFile)
	fids = fopen(outFile, 'w'); % [fids fopen(outFile, 'w')];
end
srcDir = fileparts(treeListCell{1,1});

for iTreeList = 1:size(treeListCell,1)
	cEntry		= treeListCell{iTreeList,1};
	cDepth		= treeListCell{iTreeList,2};
	cRecursive	= treeListCell{iTreeList,3};
	
	if (nameOnly==2) || (nameOnly=='2')
		[pathStr name] = fileparts(cEntry); %#ok<ASGLU>
		outStr = name;
	elseif (nameOnly==1) || (nameOnly=='1')
		[pathStr name] = fileparts(cEntry);
		if strcmp(pathStr,srcDir)
			outStr = name;
		else
			outStr = cEntry;
		end
	else
		outStr = cEntry;
	end
	
	for cFid = fids
		fprintf(cFid,repmat('\t', 1, cDepth-1));
		fprintf(cFid, '%s', outStr);
		
		if cRecursive
			fprintf(cFid, '*\n');
		else
			fprintf(cFid, '\n');
		end
	end
end

if ~isempty(outFile)
	fclose(fids(fids~=1));
end
fprintf('\n');
end


function tree2Txt(treeList, allList, outFile, nameOnly, verbose)
% function treeToTxt(treeList, allList, outFile, nameOnly, verbose)

if verbose == 2
	fids = 1; % Screen
	fprintf('\n');
else
	fids = []; 
end
if ~isempty(outFile)
	fids = [fids fopen(outFile, 'w')];
end
srcDir = fileparts(allList{1});

for iTreeList = 1:size(treeList,1)
	iEntry		= treeList(iTreeList,1);
	cDepth		= treeList(iTreeList,2);
	cRecursive	= treeList(iTreeList,3);
	
	if nameOnly==2
		[pathStr name] = fileparts(allList{iEntry}); %#ok<ASGLU>
		outStr = name;
	elseif nameOnly==1
		[pathStr name] = fileparts(allList{iEntry});
		if strcmp(pathStr,srcDir)
			outStr = name;
		else
			outStr = allList{iEntry};
		end
	else
		outStr = allList{iEntry};
	end
	
	for cFid = fids
		fprintf(cFid,repmat('\t', 1, cDepth-1));
		fprintf(cFid, '%s', outStr);
		
		if cRecursive
			fprintf(cFid, '*\n');
		else
			fprintf(cFid, '\n');
		end
	end
end

if ~isempty(outFile)
	fclose(fids(fids~=1));
end
fprintf('\n');
end


function varargin2var(vararginCell)
nVar = length(vararginCell)/2;
for iVar = 1:nVar
	assignin('caller', vararginCell{iVar*2-1}, vararginCell{iVar*2});
end
end


function strargin2var(vararginCell)
nVar = length(vararginCell)/2;
for iVar = 1:nVar
	try
		assignin('caller', vararginCell{iVar*2-1}, eval(vararginCell{iVar*2}));
	catch
		assignin('caller', vararginCell{iVar*2-1}, vararginCell{iVar*2});
	end
end
end