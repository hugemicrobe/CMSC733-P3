function [X] = LinearTriangulation(K, C1, R1, C2, R2, x1, x2)
%% Inputs:
% C1 and R1: the 1st camera pose
% C2 and R2: the 2nd camera pose
% x1 and x2: two Nx2 matrices whose row represents correspondence between the 
%            1st and 2nd images where N is the number of correspondences.
%% Outputs: 
% X: Nx3 matrix whose row represents 3D triangulated point.

%% Your Code goes here
N = size(x1, 1);
X = zeros(N, 3);

P1 = K * [R1, -R1*C1];
P2 = K * [R2, -R2*C2];

for i = 1:N
    A = [x1(i, 1) * P1(3, :) - P1(1, :);
         x1(i, 2) * P1(3, :) - P1(2, :);
         x2(i, 1) * P2(3, :) - P2(1, :);
         x2(i, 2) * P2(3, :) - P2(2, :)];
     
    % find least-square solution X
    [~, ~, v] = svd(A, 0);
    X(i, :) = v(1:3, end)' / v(end); 
end

end
