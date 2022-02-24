function varargout = fillTrace2(X,Y,err_neg,err_pos,varargin)
    
    if length(varargin)<1 || isempty(varargin{1})
        c = [0 0 1];        
    else
        c = varargin{1};
    end
    if length(varargin)<2 || isempty(varargin{2})
        c_alpha = 0.8;
    else
        c_alpha = varargin{2};
    end
    if length(varargin)<3 || isempty(varargin{3})
        LineStyle = '-';
    else
        LineStyle = varargin{3};        
    end
    if length(varargin)<4 || isempty(varargin{3})
        LineWidth = 0.5;
    else
        LineWidth = varargin{4};        
    end
    
    fill_c = 1-((1-c).*c_alpha);
    
    if isrow(X)
        X = X';
    end
    if isrow(Y)
        Y = Y';
    end
    if isrow(err_neg)
        err_neg = err_neg';
    end
    if isrow(err_pos)
        err_pos = err_pos';
    end
    pick = isfinite(Y);
    
    X = X(pick);
    Y = Y(pick);
    err_neg(isnan(err_neg)) = 0;
    err_pos(isnan(err_pos)) = 0;
    err_neg = err_neg(pick);
    err_pos = err_pos(pick);
    
    Ylow = Y - err_neg;
    Yhi  = Y + err_pos;
    M = [X Ylow;flipud(X),flipud(Yhi)];
    
    % plot them
    hold on
    h = fill(M(:,1),M(:,2),fill_c,'LineStyle','none','FaceAlpha',0.3);
    % h = patch(M(:,1),M(:,2),fill_c);
    % set(h,'LineStyle','none','FaceAlpha',0.7);
    plot(X,Y,'color',c,'LineWidth',LineWidth,'LineStyle',LineStyle);
    
    varargout{1} = h;
    return
end