function [C,R] = NonlinearPnP(X, x, K, C, R)
%% Inputs and Outputs
% X and x: Nx3 and Nx2 matrices whose row represents correspondences 
%                  between 3D and 2D points, respectively.
% K: intrinsic parameter
% C and R: for pose

opts = optimoptions(@lsqnonlin, 'Algorithm', 'levenberg-marquardt', 'MaxIter', 1e3, 'Display', 'none');

%% Your code goes here
params0 = encodeParameters(C, R);
paramsFinal = lsqnonlin(@(params)geoError(X, x, K, params), params0, [], [], opts);
[C, R] = decodeParameters(paramsFinal);

end

function params = encodeParameters(C, R)
q = R2q(R);
params = [q; C];
end

function [C, R] = decodeParameters(params)
q = params(1:4);
R = q2R(q);
C = params(5:7);
end

function f = geoError(X, x, K, params)
[C, R] = decodeParameters(params);
assert(size(x, 1) == size(X, 1), 'The numbers of matching points in the image are not the same');

% Do the projection and calculate geo error
N = size(X, 1);
P = K * [R, -R * C];
homX = [X, ones(N, 1)]; % N x 4
pX = P * homX'; % 3 x N
pX = pX'; % N x 3
pX = pX ./ repmat(pX(:, 3), 1, 3);
% error
f = x - pX(:, 1:2);

end

