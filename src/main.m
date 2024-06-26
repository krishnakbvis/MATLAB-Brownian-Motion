% timeStep = 1e-4;
% runTime = 30;               
% epsilon = 0.1;             
% N = 300;                   
% boxwidth = 23;               
% particleSize = 1;
% A = 0.4;
% B = 1;
% initVel = 20;
% particleMass = 1;
% brownianMass = 4.5*1e10;
% 
% [xPositionMatrix, yPositionMatrix, timesLength] = ...
%     nbodySimulation(runTime, timeStep, epsilon, A, B, ...
%     particleMass, brownianMass, N, boxwidth, initVel, particleSize);
animate(boxwidth, xPositionMatrix, yPositionMatrix, timesLength, N);
% filename = "simdata.mat";
% save(filename);
createHistogram(xPositionMatrix(:,N/2), yPositionMatrix(:,N/2), 15, N, A, B);
hold off