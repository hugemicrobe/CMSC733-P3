function [C,R,idx] = PnPRANSAC(X, x, K)
%% Inputs
% K : camera calibration matrix
% X : 3D coordinates
% x : image pixel coordinates
%% Outputs
% C : camera center
% R : Rotation matrix
% idx : inlier index

%% Your code goes here
maxIter = 3000;
threshold = 20;

N = size(x, 1);
bestNinliers = 0;

for i = 1:maxIter
    chosen = randperm(N, 6);
    [estC, estR] = LinearPnP(X(chosen, :), x(chosen, :), K);
    d = evaluateCR(X, x, K, estC, estR);
    
    inliers = (d < threshold);
    if sum(inliers) > bestNinliers
        bestNinliers = sum(inliers);
        C = estC;
        R = estR;
        idx = inliers;
    end
end


end

function error = evaluateCR(X, x, K, C, R)
N = size(X, 1);
homX = [X, ones(N, 1)];

P = K * [R, -R*C];
pHomX = P * homX'; % 3 x N
pHomX = pHomX';
pHomX = pHomX ./ repmat(pHomX(:, 3), 1, 3);
dist = x - pHomX(:, 1:2);
error = sum(dist .^ 2, 2);

end
