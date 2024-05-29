function [acceleration] = getAcc(pos, masses, sigmas, epsilon, A, B)
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
    distSquared = dx.^2 + dy.^2;
    sep = sqrt(distSquared);

    s = size(sep);
    index = 1:s(1)+1:s(1)*s(2);  

    % Compute 1/r^7 and 1/r^13
    inv_r7 = distSquared.^(-3.5);
    inv_r13 = distSquared.^(-6.5);
    % Replace entries along diag with zero
    inv_r7(index) = 0;
    inv_r13(index) = 0;

    % Unit vectors
    unitX = dx ./ sep;
    unitY = dy ./ sep;

    % Forces computation (avoid NaN/Inf propagation)
    forces = 4 * epsilon * ((A * sigmas.^6) .* inv_r7 - (B * sigmas.^12) .* inv_r13);
    % replace entries along diag with zero
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