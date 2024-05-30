timeStep = 1e-4;
runTime = 50;   
epsilon = 0.3;
N = 70;    
boxwidth = 6;
particleSize = 0.6;
A = 0.3;
B = 1;
initVel = 8;
particleMass = 1;
brownianMass = 1e7;

[xPositionMatrix, yPositionMatrix, timesLength] = ...
    nbodySimulation(runTime, timeStep, epsilon, A, B, ...
    particleMass, brownianMass, N, boxwidth, initVel, particleSize);

animate(boxwidth, xPositionMatrix, yPositionMatrix, timesLength, N);




