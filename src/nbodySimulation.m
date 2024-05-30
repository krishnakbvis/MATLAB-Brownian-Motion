function [xPositionMatrix, yPositionMatrix, timesLength] = nbodySimulation(rt, ts, e, Aparam, Bparam, particlesMass, brownianMass, numParticles, bw, initV, particleSize)
    time = 0;
    timeStep = ts;
    runTime = rt;   
    loopingTime = runTime/timeStep; 
    timesLength = loopingTime/100;
    epsilon = e;
    N = numParticles;    
    boxwidth = bw;
    onesMat = ones(N,N);
    
    radii = 0.15*ones(N,1);
    radii(N/2) = particleSize;
    
    A = Aparam;
    B = Bparam;
    % Position data of bodies
    xPositions = (boxwidth-1)*rand(1,N)+1;
    yPositions = (boxwidth-1)*rand(1,N)+1;
    xPositions(N/2) = boxwidth/2;
    yPositions(N/2) = boxwidth/2;
    
    pos = [xPositions', yPositions'];
    
    absv = initV;
    % Velocities
    xVelocities = 2*absv*rand(N,1) - absv;
    yVelocities = 2*absv*rand(N,1) - absv;
    xVelocities(N/2) = 0;
    yVelocities(N/2) = 0;
    vel = [xVelocities, yVelocities];
    
    % Matrices for animation
    xPositionMatrix = zeros(timesLength, N);
    yPositionMatrix = zeros(timesLength, N);
    
    masses = particlesMass*ones(N,1);
    masses(N/2) = brownianMass;
    % Kick-off simulator
    sigma = radii/(2^(1/6));
    oldAccelerations = computeAcceleration(pos, masses, sigma, epsilon, A, B, onesMat);
    %% Preallocate matrices
    numSteps = numel(0:100:length(time));
    xPositionMatrix = zeros(numSteps, size(pos, 1));
    yPositionMatrix = zeros(numSteps, size(pos, 1));
    
    %% Main simulation loop
    for count = 1:loopingTime
        % Store positions every 100 steps
        if mod(count, 100) == 0
            xPositionMatrix(count/100, :) = pos(:, 1)';
            yPositionMatrix(count/100, :) = pos(:, 2)';
        end
    
        %% Dynamics 
        xvel = vel(:, 1);
        yvel = vel(:, 2);
        xpos = pos(:, 1);
        ypos = pos(:, 2);
        
        % Update positions
        xpos = xpos + xvel * timeStep + 0.5 * oldAccelerations(:, 1) * timeStep^2;
        ypos = ypos + yvel * timeStep + 0.5 * oldAccelerations(:, 2) * timeStep^2; 
        pos = [xpos, ypos];
        newAccelerations = computeAcceleration(pos, masses, sigma, epsilon, A, B, onesMat);
    
        % Container collision physics
        inboundX = (xpos - radii <= 0) | (xpos + radii >= boxwidth);
        inboundY = (ypos - radii <= 0) | (ypos + radii >= boxwidth);
        xvel(inboundX) = -xvel(inboundX);
        yvel(inboundY) = -yvel(inboundY);
        
        % Update velocities
        xvel = xvel + 0.5 * (newAccelerations(:, 1) + oldAccelerations(:, 1)) * timeStep;
        yvel = yvel + 0.5 * (newAccelerations(:, 2) + oldAccelerations(:, 2)) * timeStep;
        
        % Update arrays
        vel = [xvel, yvel];
        

        %set oldAccelerations to the new value of accelerations
        oldAccelerations = newAccelerations;
        
        % Progress simulation
        time = time + timeStep;
    end
end





