function varargout = fillTrace(X,Y,err,varargin)
    
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
    if length(varargin)<4 || isempty(varargin{4})
        LineWidth = 0.5;
    else
        LineWidth = varargin{4};
    end
    if length(varargin)<5 || isempty(varargin{5})
        FaceAlpha = 0.3;
    else
        FaceAlpha = varargin{5};
    end
    
    fill_c = 1-((1-c).*c_alpha);
    
    if isrow(X)
        X = X';
    end
    if isrow(Y)
        Y = Y';
    end
    if isrow(err)
        err = err';
    end
    pick = isfinite(Y);
    
    X = X(pick);
    Y = Y(pick);
    err(isnan(err)) = 0;
    err = err(pick);
    
    Ylow = Y-err;
    Yhi  = Y+err;
    M = [X Ylow;flipud(X),flipud(Yhi)];
    
    % plot them
    hold on
    h = fill(M(:,1),M(:,2),fill_c,'LineStyle','none','FaceAlpha',FaceAlpha);
    % h = patch(M(:,1),M(:,2),fill_c);
    % set(h,'LineStyle','none','FaceAlpha',0.7);
    h2 = plot(X,Y,'color',c,'LineWidth',LineWidth,'LineStyle',LineStyle);
    
    varargout{1} = h;
    varargout{2} = h2;
    return
end