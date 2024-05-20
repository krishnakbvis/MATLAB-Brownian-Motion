set(0,'defaultfigureposition',[200 50 700 700]')

clc;
clear;
close all;


time = 0;
deltaT = 10^-4;
runTime = 10;   
loopingTime = runTime/deltaT; 
timesLength = loopingTime/100;
epsilon = 1;
n = 50;    

radii = 0.15*ones(n);
radii(n/2) = 1;

A = 1;
B = 1;

times = [];

%position data of bodies
xPositions = 10*rand(1,n)+1;
yPositions = 10*rand(1,n)+1;
xPositions(n/2) = 5;
yPositions(n/2) = 5;


absv = 8;
%velocities
xVelocities = 2*absv*rand(n,1) - absv;
yVelocities = 2*absv*rand(n,1) - absv;

xVelocities(n/2) = 0;
yVelocities(n/2) = 0;


%Matrices for animation
xPositionMatrix = zeros(timesLength, n);
yPositionMatrix = zeros(timesLength, n);

masses = ones(n);
masses(n/2) = 1e12;

g = 9.81;
oldAccelerations = zeros(n,2);
gravity = [0, 0];
%kick-off simulator
for j = 1:n   
    sigma = radii(j)/(2^(1/6));
    %remember to reset total force to zero 
    totalForce = [0 0]; %set new total    
    for i = 1:j-1
        currentDistance = hypot(xPositions(i)-xPositions(j), yPositions(i)-yPositions(j));
%         if (currentDistance > 9) 
%             continue;
%         end
        %Distance, unit vector, and total force (which is updated
        %every iteration
        unitVector = [(xPositions(i)-xPositions(j))/currentDistance, (yPositions(i)-yPositions(j))/currentDistance];
        currentForce = unitVector*4*epsilon*((A*sigma^6/(currentDistance^7)) - (B*sigma^12/currentDistance^13));
        totalForce = totalForce + currentForce;  
    end
    
    for i = j+1:n
        currentDistance = hypot(xPositions(i)-xPositions(j), yPositions(i)-yPositions(j));
%         if (currentDistance > 3) 
%             continue;
%         end
        unitVector = [(xPositions(i)-xPositions(j))/currentDistance, (yPositions(i)-yPositions(j))/currentDistance];
        currentForce = unitVector*4*epsilon*((A*sigma^6/(currentDistance^7)) - (B*sigma^12/currentDistance^13));
        totalForce = totalForce + currentForce;       
    end
    oldAccelerations(j,:) = totalForce/masses(j);
end

%% Simulation

for count = 1:loopingTime

    if mod(count,100) == 0
        xPositionMatrix(count/100,:) = xPositions;
        yPositionMatrix(count/100,:) = yPositions;
    end
    
    
    %% dynamics 
    
    %Outer loop (loop through each body, calculating dynamics of each body
    %before progressing the simulation
    for j = 1:n
        sigma = radii(j)/(2^(1/6));
        %update position
        xPositions(j) = xPositions(j) + xVelocities(j)*deltaT + 0.5*totalForce(1)*deltaT^2;
        yPositions(j) = yPositions(j) + yVelocities(j)*deltaT + 0.5*totalForce(2)*deltaT^2; 

        %remember to reset total force to zero 
        totalForce = [0 0]; %set new total
        for i = 1:j-1
            %Distance, unit vector, and total force (which is updated
            %every iteration
            currentDistance = hypot(xPositions(i)-xPositions(j),yPositions(i)-yPositions(j));
            unitVector = [(xPositions(i)-xPositions(j))/currentDistance (yPositions(i)-yPositions(j))/currentDistance];
            currentForce = unitVector*4*epsilon*((A*sigma^6/(currentDistance^7)) - (B*sigma^12/currentDistance^13));
            totalForce = totalForce + currentForce;                
        end
        
        for i = j+1:n
            currentDistance = hypot(xPositions(i)-xPositions(j),yPositions(i)-yPositions(j));
            unitVector = [(xPositions(i)-xPositions(j))/currentDistance (yPositions(i)-yPositions(j))/currentDistance];
            currentForce = unitVector*4*epsilon*((A*sigma^6/(currentDistance^7)) - (B*sigma^12/currentDistance^13));
            totalForce = totalForce + currentForce;
        end
        newAcceleration = totalForce/masses(j);

        %% integrate and update positions for each body
        %container collision physics               
        if xPositions(j)-radii(j) <= 0 || xPositions(j) + radii(j) >= 12
            xVelocities(j) = -xVelocities(j);
        end
        if yPositions(j)-radii(j) <= 0 || yPositions(j) + radii(j) >= 12
            yVelocities(j) = -yVelocities(j);
        else        
        xVelocities(j) = xVelocities(j) + 0.5*(newAcceleration(1) + oldAccelerations(j,1))*deltaT;
        yVelocities(j) = yVelocities(j) + 0.5*(newAcceleration(2) + oldAccelerations(j,2))*deltaT;
        end
        oldAccelerations(j,:) = totalForce/masses(j);
    end
    
    %progress the simulation and recalculate the dynamics for each body
    time = time + deltaT;
end


%% animation


axis(gca, "equal");
axis([0 12 0 12]);
grid on;

particles = gobjects(n);
particleColourMatrix = zeros(n,3);
radii(n/2) = 0.7;

for i = 1:n
    %random colour values of the particles
    particleColourMatrix(i,:) = round(rand(1,3),1);
end 

for i = 1:timesLength-1
    %Optional: displ5ay time (requires code modification)
    %title("time: " + num2str(times(i)) + "s");
  
    for j = 1:n
        r = radii(j);
        %use rectangle() to draw a filled circle
        particles(j) = rectangle('Curvature', [1 1], ...
        'Position', [xPositionMatrix(i,j)-r yPositionMatrix(i,j)-r 2*r 2*r], ...
        'facecolor', particleColourMatrix(j,:), 'edgecolor', 'none');
    end
    
    pause(10^-6);


    for j = 1:n
        %delete old elements before redrawing 
        delete(particles(j));
    end
    
    
%     reset the array to zero before refilling the array
     particles = gobjects(n);
end

for j = 1:n
    r = radii(j);
    particles(j) = rectangle('Curvature', [1 1], ...
    'Position', [xPositionMatrix(i,j)-r yPositionMatrix(i,j)-r 2*r 2*r], ...
    'facecolor', particleColourMatrix(j,:), 'edgecolor', 'none');
end



