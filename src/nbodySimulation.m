set(0,'defaultfigureposition',[200 50 700 700]')

clc;
clear;
close all;
time = 0;
deltaT = 1e-4;
runTime = 10;   
loopingTime = runTime/deltaT; 
timesLength = loopingTime/100;
epsilon = 1;
n = 50;    
boxwidth = 12;


radii = 0.15*ones(n);
radii(n/2) = 1;

A = 1;
B = 1;

times = [];

%position data of bodies
xPositions = (boxwidth-2)*rand(1,n)+1;
yPositions = (boxwidth-2)*rand(1,n)+1;
xPositions(n/2) = boxwidth/2;
yPositions(n/2) = boxwidth/2;

pos = [xPositions, yPositions];



absv = 12;
%velocities
xVelocities = 2*absv*rand(n,1) - absv;
yVelocities = 2*absv*rand(n,1) - absv;

xVelocities(n/2) = 0;
yVelocities(n/2) = 0;

cutoffdistance = 5;

%Matrices for animation
xPositionMatrix = zeros(timesLength, n);
yPositionMatrix = zeros(timesLength, n);

masses = ones(n);
masses(n/2) = 1e12;

g = 9.81;
oldAccelerations = zeros(n,2);
gravity = [0, 0];
totalForce = [0 0]; %set new total    
%kick-off simulator
% xPositions = parallel.pool.Constant(xPositions);
% yPositions = parallel.pool.Constant(Positions);S
for j = 1:n   
    sigma = radii(j)/(2^(1/6));
    %remember to reset total force to zero 
    totalForce = [0 0]; %set new total    
    bodyXPos = xPositions(j);
    bodyYPos = yPositions(j);
%     parfor i = 1:n
%         if (i == j) 
%             continue
%         end
%         currentDistance = hypot(xPositions(i)-bodyXPos, yPositions(i)-bodyYPos);
%         if (currentDistance > cutoffdistance) 
%             continue;
%         end
%         %Distance, unit vector, and total force (which is updated
%         %every iteration
%         unitVector = [(xPositions(i)-bodyXPos)/currentDistance, (yPositions(i)-bodyXPos)/currentDistance];
%         currentForce = unitVector*4*epsilon*((A*sigma^6/(currentDistance^7)) - (B*sigma^12/currentDistance^13));
%         totalForce = totalForce + currentForce;  
%     end
    
    oldAccelerations = getAcc(pos, );
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
        bodyXPos = xPositions(j);
        bodyYPos = yPositions(j);
        %remember to reset total force to zero 
        totalForce = [0 0]; %set new total
        parfor i = 1:n
            if (i == j) 
                continue
            end
           
            currentDistance = hypot(xPositions(i)-bodyXPos, yPositions(i)-bodyYPos);
            if (currentDistance > cutoffdistance) 
                continue;
            end
            %Distance, unit vector, and total force (which is updated
            %every iteration
            unitVector = [(xPositions(i)-bodyXPos)/currentDistance, (yPositions(i)-bodyXPos)/currentDistance];
            currentForce = unitVector*4*epsilon*((A*sigma^6/(currentDistance^7)) - (B*sigma^12/currentDistance^13));
            totalForce = totalForce + currentForce;  
        end
        newAcceleration = totalForce/masses(j);
        %% integrate and update positions for each body
        %container collision physics               
        if bodyXPos-radii(j) <= 0 || bodyXPos + radii(j) >= boxwidth
            xVelocities(j) = -xVelocities(j);
        end
        if bodyYPos-radii(j) <= 0 || bodyYPos + radii(j) >= boxwidth
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
axis([0 boxwidth 0 boxwidth]);
grid on;

particles = gobjects(n);
particleColourMatrix = zeros(n,3);
radii(n/2) = 0.6;

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
    
    pause(1e-6);

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



