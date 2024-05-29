timeStep = 1e-4;
runTime = 30;   
epsilon = 0.1;
N = 100;    
boxwidth = 12;
particleSize = 0.7;
A = 3;
B = 1;
initVel = 8;
particleMass = 1;
brownianMass = 1e5;

[xPositionMatrix, yPositionMatrix, timesLength] = ...
    nbodySimulation(runTime, timeStep, epsilon, A, B, ...
    particleMass, brownianMass, N, boxwidth, initVel, particleSize);

animate(boxwidth, xPositionMatrix, yPositionMatrix, timesLength, N);




