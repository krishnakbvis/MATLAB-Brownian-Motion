timeStep = 1e-4;
runTime = 10;   
epsilon = 0.15;
N = 120;    
boxwidth = 7;
particleSize = 1;
A = 0.2;
B = 1;
initVel = 5;
particleMass = 1;
brownianMass = 1e10;

[xPositionMatrix, yPositionMatrix, timesLength] = ...
    nbodySimulation(runTime, timeStep, epsilon, A, B, ...
    particleMass, brownianMass, N, boxwidth, initVel, particleSize);
animate(boxwidth, xPositionMatrix, yPositionMatrix, timesLength, N);
close all



