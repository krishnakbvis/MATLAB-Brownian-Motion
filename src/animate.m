function [] = animate(boxwidth, xPositionMatrix, yPositionMatrix, timesLength, N)
    close all;
    set(0,'defaultfigureposition',[200 50 700 700]')

    axis(gca, "equal");
    axis([0 boxwidth 0 boxwidth]);
    grid on;
    old = [xPositionMatrix(1,N/2); yPositionMatrix(1,N/2)];
    for i = 1:timesLength-1
        %Optional: displ5ay time (requires code modification)
        axis([0 boxwidth 0 boxwidth]);
        %use rectangle() to draw a filled circle
        plot(xPositionMatrix(i,1:N/2-1), yPositionMatrix(i,1:N/2-1), '.', 'MarkerSize',30);
        title("time: " + num2str(i*1e-2) + "s");
        hold on
        xbrownian = xPositionMatrix(i,N/2);
        ybrownian = yPositionMatrix(i,N/2);
        plot(xbrownian, ybrownian, '.', 'MarkerSize', 150); 
        plot(xPositionMatrix(1:i,N/2), yPositionMatrix(1:i,N/2), 'MarkerSize', 3);
        hold on
        plot(xPositionMatrix(i,N/2 + 1:N), yPositionMatrix(i,N/2 + 1:N), '.', 'MarkerSize',30); 
        hold off
        axis square
        axis([0 boxwidth 0 boxwidth])
        pause(1e-4);
    end

end
