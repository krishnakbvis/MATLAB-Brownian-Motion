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
n = 20;    
boxwidth = 12;

radii = 0.15*ones(n,1);5
% radii(n/2) = 1;

A = 1;
B = 1;

times = [];

% Position data of bodies
xPositions = (boxwidth-2)*rand(1,n)+1;
yPositions = (boxwidth-2)*rand(1,n)+1;
xPositions(n/2) = boxwidth/2;
yPositions(n/2) = boxwidth/2;

pos = [xPositions', yPositions'];

absv = 12;
% Velocities
xVelocities = 2*absv*rand(n,1) - absv;
yVelocities = 2*absv*rand(n,1) - absv;
xVelocities(n/2) = 0;
yVelocities(n/2) = 0;
vel = [xVelocities, yVelocities];

cutoffdistance = 5;

% Matrices for animation
xPositionMatrix = zeros(timesLength, n);
yPositionMatrix = zeros(timesLength, n);

masses = ones(n,1);
% masses(n/2) = 1e12;
masses = masses.^(-1);

% Kick-off simulator
sigma = radii/(2^(1/6));
oldAccelerations = getAcc(pos, masses, sigma, epsilon, A, B);

%% Simulation

for count = 1:loopingTime

    if mod(count,100) == 0
        xPositionMatrix(count/100,:) = pos(:,1);
        yPositionMatrix(count/100,:) = pos(:,2);
    end
    %% Dynamics 
    
    xvel = vel(:,1);
    yvel = vel(:,2);
    xpos = pos(:,1);
    ypos = pos(:,2);
    xacc = oldAccelerations(:,1);
    yacc = oldAccelerations(:,2);

    % Update position
    xpos = xpos + xvel*deltaT + 0.5*xacc*deltaT^2;
    ypos = ypos + yvel*deltaT + 0.5*yacc*deltaT^2; 
    newAcceleration = getAcc([xpos, ypos], masses, sigma, epsilon, A, B);

    %% Integrate and update positions for each body
    % Container collision physics               

    % Check if the particle is hitting the X boundaries of the box
    inboundX = (xpos - radii <= 0) | (xpos + radii >= boxwidth);
    xvel(inboundX) = -xvel(inboundX);
    inboundY = (ypos - radii <= 0) | (ypos + radii >= boxwidth);
    yvel(inboundY) = -yvel(inboundY);

    % Reverse X velocity if hitting X boundaries
    pos(:,1) = xpos;
    pos(:,2) = ypos;
    vel(:,1) = xvel;
    vel(:,2) = yvel;
    
    xvel = xvel + 0.5*(newAcceleration(:,1) + oldAccelerations(:,1))*deltaT;
    yvel = yvel + 0.5*(newAcceleration(:,2) + oldAccelerations(:,2))*deltaT;
    vel(:,1) = xvel;
    vel(:,2) = yvel;
    oldAccelerations = getAcc(pos, masses, sigma, epsilon, A, B);
    %progress the simulation and recalculate the dynamics for each body
    time = time + deltaT;
end

%% animation


axis(gca, "equal");
axis([0 boxwidth 0 boxwidth]);
grid on;

particles = gobjects(n);
particleColourMatrix = zeros(n,3);
% radii(n/2) = 0.6;

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



