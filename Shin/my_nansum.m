function y = my_nansum(varargin)
    % MY_NANSUM returns NaN if all inputs values are NaNs.
    % Otherwise, it returns nansum value.
    % SK 19/05/15
    
    narginchk(1,2);

    switch nargin
        case 1
            y_ = sum(varargin{1});
            y = nansum(varargin{1});
        case 2
            y_ = sum(varargin{1});
            y = nansum(varargin{1},varargin{2});
    end
    
    y(isnan(y_) & y==0) = NaN;
    
end