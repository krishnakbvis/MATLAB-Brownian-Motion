function [acceleration] = computeAcceleration(pos, masses, sigmas, epsilon, A, B, onesMat)
    % pos is an N x 2 matrix of positions
    % masses is an N x 1 vector of inverse masses
    % sigmas is assumed to be an N x 1 vector
    % epsilon, A, and B are scalars
    % Extract positions
    
    
    x = pos(:, 1);
    y = pos(:, 2);

    % Compute pairwise particle separations
    dx = x' - x;
    dy = y' - y;
    % Compute squared distances and avoid computing sqrt unless necessary
    distSquared = dx.*dx + dy.*dy;

%     distSquared = gpuArray(distSquared);
    sep = sqrt(distSquared);
%     sep = gather(sep);

    s = size(sep);  
    s = s(1);
    index = 1:s+1:s*s; 
    % Compute 1/r^7 and 1/r^13
    temp = sep.*sep.*sep.*sep.*sep.*sep.*sep; %sep^7
    inv_r7 = onesMat./temp;
    temp = temp.*temp./sep; %sep^13
    inv_r13 = onesMat./temp;
    % Replace entries along diag with zero
    inv_r7(index) = 0;
    inv_r13(index) = 0;

    % Unit vectors
    unitX = dx ./ sep;
    unitY = dy ./ sep;

    temp = sigmas.*sigmas.*sigmas.*sigmas.*sigmas.*sigmas; 

    % Forces computation (avoid NaN/Inf propagation)
    forces = 4 * epsilon * ((A * temp) .* inv_r7 - (B * temp.*temp) .* inv_r13);
    % replace entries along diag with zero to avoid Infs and NaNs
    unitX(index) = 0;
    unitY(index) = 0;
    Fx = (unitX .* forces);
    Fy = (unitY .* forces);
    FtotX = sum(Fx, 2);
    FtotY = sum(Fy, 2);
    % Accelerations
    ax = FtotX ./ masses;
    ay = FtotY ./ masses;
    

    % Pack together the acceleration components
    acceleration = [ax, ay];
end