function se = stderr(varargin)

sd = std(varargin{:});
data = varargin{1};
if any(strcmpi(varargin,'omitnan'))
    n = sum(~isnan(data));
else
    n = length(data);
end
    
se = sd./sqrt(n);