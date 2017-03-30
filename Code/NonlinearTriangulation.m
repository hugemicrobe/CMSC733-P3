function X = NonlinearTriangulation(K, C1, R1, C2, R2, x1, x2, X0)
%% Notes:
% (INPUT) C1 and R1: the 1st camera pose
% (INPUT) C2 and R2: the 2nd camera pose
% (INPUT) x1 and x2: two Nx2 matrices whose row represents correspondence 
%                    between the 1st and 2nd images where N is the number 
%                    of correspondences.
% (INPUT and OUTPUT) X: Nx3 matrix whose row represents 3D triangulated point.

%% Your code goes here
params0 = encodeParameters(X0);
% opts = optimoptions(@lsqnonlin, 'Algorithm', 'levenberg-marquardt', 'MaxIter', 1e3, 'Display', 'iter');
opts = optimoptions(@lsqnonlin, 'Algorithm', 'levenberg-marquardt', 'TolX', 1e-64, 'TolFun', 1e-64, 'MaxFunEvals', 1e64, 'MaxIter', 1e64, 'Display', 'iter');
paramsFinal = lsqnonlin(@(params)geoError(K, C1, R1, C2, R2, x1, x2, params), params0, [], [], opts);
X = decodeParameters(paramsFinal);

end

function params = encodeParameters(X0)
params = reshape(X0, [], 1);
end

function X = decodeParameters(params)
X = reshape(params, [], 3);
end

function f = geoError(K, C1, R1, C2, R2, x1, x2, params)
X = decodeParameters(params);
assert(size(x1, 1) == size(X, 1), 'The numbers of matching points in the first image are not the same');
assert(size(x2, 1) == size(X, 1), 'The numbers of matching points in the second are not the same');

% Do the projection and calculate geo error
N = size(X, 1);
f = zeros(N, 2, 2);
P1 = K * [R1, -R1 * C1];
P2 = K * [R2, -R2 * C2];
homX = [X, ones(N, 1)]; % N x 4
pX1 = P1 * homX'; % 3 x N
pX2 = P2 * homX'; % 3 x N
pX1 = pX1'; % N x 3
pX2 = pX2'; % N x 3
pX1 = pX1 ./ repmat(pX1(:, 3), 1, 3); % normalize
pX2 = pX2 ./ repmat(pX1(:, 3), 1, 3); % normalize
% error
f(:, :, 1) = x1 - pX1(:, 1:2);
f(:, :, 2) = x2 - pX2(:, 1:2);
end