function varargout = fillRect(A,B,C,varargin)
    % Filling a rectangle with a specified color
    % A = [Ax,Ay] is a lower left corner 
    % B = [Bx,By] is a upper right corner
    % c is a filling color
    if ~exist('C','var') || isempty(C)
        C = [0.8 1 1];
    end
    M = [A(1),A(2);
         B(1),A(2);
         B(1),B(2);
         A(1),B(2);
         A(1),A(2)];
    varargout{1} = fill(M(:,1),M(:,2),C,varargin{:});
    return
end