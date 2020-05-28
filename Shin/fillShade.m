function varargout = fillShade(X,Y,err,varargin)

    % fillTrace without the center line
    
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
    h = fill(M(:,1),M(:,2),fill_c,'LineStyle','none','FaceAlpha',0.3);
    % h = patch(M(:,1),M(:,2),fill_c);
    % set(h,'LineStyle','none','FaceAlpha',0.7);
    % plot(X,Y,'color',c,'LineWidth',0.5,'LineStyle',LineStyle);
    
    varargout{1} = h;
    return
end