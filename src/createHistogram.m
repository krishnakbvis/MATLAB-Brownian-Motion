function [binCenters, binCounts] = createHistogram(xPositions, yPositions, binsize, N, A, B)
    dx = diff(xPositions);
    dy = diff(yPositions);
    combinedDxDy = [dx; dy];
    numbins = binsize;
    histogram(combinedDxDy, numbins, 'Normalization', 'probability');     
    stdev = std(combinedDxDy);
    mu = mean(combinedDxDy);
    hold on
    [binCounts, edges] = histcounts(combinedDxDy, numbins, 'Normalization','probability');     
    
    binCenters = zeros(1, length(edges)-1);

    for i = 1:length(edges)-1 
        binCenters(i) = 0.5*(edges(i) + edges(i+1));
    end
    hold on
    gaussEqn = 'a*exp(-((x-b)/c)^2)+d';
    startPoints = [0.01, 0.01, 0.01, 0.01];
    [f1,gof] = fit(binCenters',binCounts',gaussEqn,'Start', startPoints);
    plot(f1, binCenters, binCounts);
    title("no. particles = " + num2str(N) + ", A = " + num2str(A) + ", B = " + num2str(B) + ", \sigma = " + num2str(stdev) + ", \mu = " + num2str(mu) + ", R^2 = " + num2str(gof.rsquare));
    xlabel("displacement");
    ylabel("P(x)");
    hold off
    
end

    

