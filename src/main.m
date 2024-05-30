timeStep = 1e-4;
runTime = 30;   
epsilon = 0.15;
N = 190;    
boxwidth = 14;
particleSize = 1;
A = 0.2;
B = 1;
initVel = 30;
particleMass = 1;
brownianMass = 4.5*1e10;

[xPositionMatrix, yPositionMatrix, timesLength] = ...
    nbodySimulation(runTime, timeStep, epsilon, A, B, ...
    particleMass, brownianMass, N, boxwidth, initVel, particleSize);
animate(boxwidth, xPositionMatrix, yPositionMatrix, timesLength, N);



