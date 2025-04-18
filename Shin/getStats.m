function [v_mean, v_std, v_sem, n, v_median] = getStats(v,NameValueArgs)

    % v is a column vector (n_sample x 1) or a matrix (n_sample x features)
    %
    % EXAMPLE: getStats([1,2,2,3,5],'err','std','print',1);
    %          [x_mean, x_std, x_se] = getStats(x,'err','sem','print',1);
    
    arguments
        v double
        NameValueArgs.print (1,1) {mustBeNumeric} = 0
        NameValueArgs.central string = 'mean'
        NameValueArgs.err string = 'sem'
    end
    
    if isrow(v)
        v = v';
    end
    
    n = size(v,1);
    v_mean = mean(v,1,'omitnan');
    v_median = median(v,1,'omitnan');
    v_std  = std(v,[],1,'omitnan');
    v_sem  = std(v,[],1,'omitnan')./sqrt(n);
    
    if NameValueArgs.print
        switch NameValueArgs.central
            case 'mean' 
                central = v_mean;
            case 'median'
                central = v_median;
        end
        switch NameValueArgs.err
            case 'std' 
                err = v_std;
            case 'sem'
                err = v_sem;
        end
        
        fprintf('%.2f %s %.2f (%s %s %s)\n',central,char(177),err,NameValueArgs.central,char(177),NameValueArgs.err);
    end


end