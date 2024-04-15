set(0,'defaultfigureposition',[200 50 700 700]')

clc;
clear;
close all;


time = 0;
deltaT = 10^-4;
runTime = 10;
loopingTime = runTime/deltaT; 
timesLength = loopingTime/100;

n = 20;
r = 0.3;

%Mass data


times = [];

%position data of bodies
xPositions = 10*rand(1,n)+1;
yPositions = 10*rand(1,n)+1;

%velocities
xVelocities = zeros(n,1);
yVelocities = zeros(n,1);

%Matrices for animation
xPositionMatrix = [];
yPositionMatrix = [];

oldAccelerations = zeros(n,2);

%kick-off simulator
for j = 1:n
    %remember to reset total force to zero 
    totalForce = [0 0]; %set new total    
    for i = 1:j-1
        %Distance, unit vector, and total force (which is updated
        %every iteration
        currentDistance = hypot(xPositions(i)-xPositions(j),yPositions(i)-yPositions(j));
        unitVector = [(xPositions(i)-xPositions(j))/currentDistance (yPositions(i)-yPositions(j))/currentDistance];
        totalForce = totalForce + unitVector*(20*(2*r/currentDistance^2 - 0.5*r/currentDistance^3));                
    end
    
    for i = j+1:n
        currentDistance = hypot(xPositions(i)-xPositions(j),yPositions(i)-yPositions(j));
        unitVector = [(xPositions(i)-xPositions(j))/currentDistance (yPositions(i)-yPositions(j))/currentDistance];
        totalForce = totalForce + unitVector*(20*(2*r/currentDistance^2 - 0.5*r/currentDistance^3));
    end
    oldAccelerations(j,:) = totalForce;
end

%% Simulation

for count = 1:loopingTime

    if mod(count,100) == 0
        xPositionMatrix = [xPositionMatrix; xPositions];
        yPositionMatrix = [yPositionMatrix; yPositions];
    end
    
    
    %% dynamics 
    
    %Outer loop (loop through each body, calculating dynamics of each body
    %before progressing the simulation
    for j = 1:n
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
            totalForce = totalForce + unitVector*(20*(2*r/currentDistance^2 - 0.5*r/currentDistance^3));                
        end
        
        for i = j+1:n
            currentDistance = hypot(xPositions(i)-xPositions(j),yPositions(i)-yPositions(j));
            unitVector = [(xPositions(i)-xPositions(j))/currentDistance (yPositions(i)-yPositions(j))/currentDistance];
            totalForce = totalForce + unitVector*(20*(2*r/currentDistance^2 - 0.5*r/currentDistance^3));
        end
        newAcceleration = totalForce;

        %% integrate and update positions for each body
        %container collision physics
         
                        
        if xPositions(j)-r <= 0 || xPositions(j) >= 12
            xVelocities(j) = -xVelocities(j);
        end
        if yPositions(j)-r <= 0 || yPositions(j) >= 12
            yVelocities(j) = -yVelocities(j);
        else        
        xVelocities(j) = xVelocities(j) + 0.5*(newAcceleration(1) + oldAccelerations(j,1))*deltaT;
        yVelocities(j) = yVelocities(j) + 0.5*(newAcceleration(2) + oldAccelerations(j,2))*deltaT;
        end
        oldAccelerations(j,:) = totalForce;
    end
    
    %progress the simulation and recalculate the dynamics for each body
    time = time + deltaT;
end


%% animation

axis(gca, "equal");
axis([0 12 0 12]);
grid on;

particles = [];

particleColourMatrix = [];

for i = 1:n
    %random colour values of the particles
    particleColourMatrix = [particleColourMatrix; round(rand(1,3),1)];
end 

for i = 1:timesLength-1
    %Optional: display time (requires code modification)
    %title("time: " + num2str(times(i)) + "s");
  
    for j = 1:n
        %use rectangle() to draw a filled circle
        particles = [particles;     rectangle('Curvature', [1 1], ...
        'Position', [xPositionMatrix(i,j)-r yPositionMatrix(i,j)-r r r], ...
        'facecolor', particleColourMatrix(j,:), 'edgecolor', 'none') ];
    end
    
    pause(10^-6);


    for j = 1:n
        %delete old elements before redrawing 
        delete(particles(j));
    end
    
    
    %reset the array to zero before refilling the array
    particles = [];
end

for j = 1:n
    %use rectangle() to draw a filled circle
    particles = [particles;     rectangle('Curvature', [1 1], ...
    'Position', [xPositionMatrix(i,j)-r yPositionMatrix(i,j)-r r r], ...
    'facecolor', particleColourMatrix(j,:), 'edgecolor', 'none') ];
end

