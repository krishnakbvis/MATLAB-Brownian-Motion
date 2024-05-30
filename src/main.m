timeStep = 1e-4;
runTime = 30;   
epsilon = 0.15;
N = 200;    
boxwidth = 12;
particleSize = 1;
A = 0.2;
B = 1;
initVel = 18;
particleMass = 1;
brownianMass = 4*1e10;

[xPositionMatrix, yPositionMatrix, timesLength] = ...
    nbodySimulation(runTime, timeStep, epsilon, A, B, ...
    particleMass, brownianMass, N, boxwidth, initVel, particleSize);
animate(boxwidth, xPositionMatrix, yPositionMatrix, timesLength, N);
close all



