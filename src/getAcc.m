function [ acceleration ] = getAcc(pos, invmasses, sigmas, epsilon, A, B)
%   pos  is an N x 2 matrix of positions
%   masses is an N x 1 vectors of masses
%   a is N x 2 matrix of accelerations

% positions r = [x,y,z] for all particles
x = pos(:,1);
y = pos(:,2);

% matrix that stores all pairwise particle separations: r_j - r_i
dx = x' - x;
dy = y' - y;

% matrix that stores 1/r^3 for all particle pairwise particle separations 
sep = sqrt(dx.^2 + dy.^2);
inv_r7 = sep.^(-7);
inv_r13 = sep.^(-13);

% fix diagonal values (representing j=i interaction), which are currently 1/0=Infinity. Set to 0
inv_r7(inv_r7 == Inf) = 0;
inv_r13(inv_r13 == Inf) = 0;

unitX = dx./sep;
unitY = dy./sep;

unitX(isnan(unitX)) = 0;
unitY(isnan(unitY)) = 0;


forces = 4*epsilon*((A*sigmas.^6).*inv_r7 - (B*sigmas.^12).*inv_r13);
ax = (unitX .* forces) * invmasses;
ay = (unitY .* forces) * invmasses;

% pack together the acceleration components
acceleration = [ax ay];

end

