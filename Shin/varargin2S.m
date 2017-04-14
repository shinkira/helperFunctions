function S = varargin2S(varCell, defaults, restrictInput)
% S = varargin2S({'argName1', arg1, 'argName2', arg2, ...}, [defaults = struct_or_cell, restrictInput = false])
%
% Returns a struct like:
% S.argName1 == arg1
% S.argName2 == arg2
%
% Examples:
%
% Use
%   S = varargin2S(varargin, {'defaultArg1', defaultArg1, ...})
% in a function to create struct with the arguments as fields.
%
% Use
%   S = varargin2S(varargin, {'defaultArg1', defaultArg1, ...}, true)
% in a function to issue error when a variable name that's not in the defaults 
% is given in varargin.
% 
% See also: demoVarargin2S, varargin2V
% 
% 2013 Yul Kang. hk2699 at columbia dot edu.

if ~exist('restrictInput', 'var'), restrictInput = false; end
if ~exist('defaults', 'var')
    S = struct;
elseif isstruct(defaults)
    S = defaults;
    
elseif iscell(defaults)
    S = cell2struct(defaults(2:2:end), defaults(1:2:end), 2);
end

fieldNames = varCell(1:2:end);
if restrictInput
    newArgs = setdiff(fieldNames, fieldnames(S)');
    if ~isempty(newArgs)
        error(['Unexpected argument:', sprintf(' %s', newArgs{:})]);
    end
end

for iField = 1:length(fieldNames)
    S.(fieldNames{iField}) = varCell{iField*2};
end