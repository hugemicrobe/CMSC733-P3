function [C, R] = LinearPnP(X, x, K)
%% Inputs
% X and x: Nx3 and Nx2 matrices whose row represents correspondences between 
%          3D and 2D points, respectively.
% K: intrinsic parameter
%% Output
% C and R: camera pose (C;R)

%% Your Code goes here 
N = size(X, 1);
assert(size(x, 1) == N, 'The numbers of the points are not the same');
assert(N > 5, 'The numbers of the matching is not enough to solve LinearPnP');
A = zeros(N * 3, 12);
homX = [X, ones(N, 1)];
homx = [x, ones(N, 1)];
newHomx = K \ homx;
for i = 1:N
    x_temp = [0, -1,  newHomx(i, 2); ...
              1,  0, -newHomx(i, 1); ...
              -xhom(i, 2), newHomx(i, 1), 0];
    X_temp = [homX(i, :), zeros(1, 8); ...
              zeros(1, 4), homX(i, :), zeros(1, 8); ...
              zeros(1, 8), homX(i, :)];
    index = (i - 1) * 3 + 1;
    A(index:(index + 3), :) = x_temp * X_temp;
end

[U, D, V] = svd(A);
v = V(:, end);
R = reshape(v(1:9), 3, 3)';
T = v(10:12)';
% correct rotation matrix
[rU, rD, rV] = svd(R);
R = rU * rV';
if det(R) < 0
    R = -R;
    T = -T;
end

T = T / rD(1, 1);
C = -R' * T;

end
