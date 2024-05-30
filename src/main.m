timeStep = 1e-4;
runTime = 10;   
epsilon = 0.5;
N = 50;    
boxwidth = 12;
particleSize = 0.7;
A = 1;
B = 1;
initVel = 5;
particleMass = 1;
brownianMass = 1e5;

[xPositionMatrix, yPositionMatrix, timesLength] = ...
    nbodySimulation(runTime, timeStep, epsilon, A, B, ...
    particleMass, brownianMass, N, boxwidth, initVel, particleSize);

animate(boxwidth, xPositionMatrix, yPositionMatrix, timesLength, N);li




