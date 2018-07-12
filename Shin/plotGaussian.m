function plotGaussian
    
    mu = 0;
    sigma = 1;
    x = -4:0.01:4;
    y = 1/sqrt(2*pi*sigma^2)*exp(-1/2*(x-mu./sigma).^2);

    figure(1);clf
    plot(x,y,'k-')
    set(gca,'Box','off')
    
end