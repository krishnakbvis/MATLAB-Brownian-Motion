function [] = createHistogram(xPositions, yPositions, binsize)
    dx = diff(xPositions);
    dy = diff(yPositions);
    combinedDxDy = [dx; dy];
    numbins = binsize;


    gaussian = @(x, m,s) exp(-0.5*((x-m)/s).^2)/(s*sqrt(2*pi));
    mu = mean(combinedDxDy);                             % Arbitrary mean
    sigma = std(combinedDxDy);                          % arbitrary standard deviation
    h = histogram(combinedDxDy, numbins, 'Normalization', 'probability');     
    dh = h.BinWidth;
    lo = min(combinedDxDy);
    hi = max(combinedDxDy);
    dxx = (hi-lo)/100;
    xx = linspace(lo,hi,101);
    pdf = gaussian(xx, mu, sigma);
    scalefactor = sum(h.Values*dh)/(trapz(pdf)*dxx);
    pdf = scalefactor*pdf;
    hold on
    plot(xx,pdf)
    
    title("mean = " + num2str(mu) + ", std = " + num2str(sigma));

end

    

