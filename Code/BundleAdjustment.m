function [Cset, Rset, Xset] = BundleAdjustment(K, Cset, Rset, X, reconstructedX, Mx, My)
% 1st level wrapper function for running sba
%% Inputs:
% (K, Cr_set, Rr_set, X3D, ReconX, V_bundle, Mx_bundle, My_bundle)
% K - Camera callibration Matrix
% Cr_set - Set of Camera Center Positions
% Rr_set - Set of Rotation matrices
% Pose is defined as P = KR[I,-C]
% X3D - 3D points corresponding to all possible feature points
% Xin - An indicator vector to indicate if a particular point has a
%       valid 3D triangulation associated with it
% V - Visibility matrix (NxM) => N features, M poses
% Mx - Set of pixel x-coordinates for each feature => NxM ?no use)
% My - Set of pixel y-coordinates for each featuer => NxM
%% Outputs
% Updated Cr_set, Rr_set and X3D 

%% Your code goes here
Xset = X;
validX = logical(reconstructedX);
X3D = X(validX, :);
featuresNum = size(X3D, 1);
framesNum = length(Cset);
measurements = zeros(2 * featuresNum, framesNum);
% camProj = cell(framesNum, 1);
camPose = cell(framesNum, 1);

for i = 1:framesNum
    % camProj{i} = K * [Rset{i}, -Rset{i}*Cset{i}];
    camPose{i} = [Rset{i}, Cset{i}];
    x = [Mx(validX, i), My(validX, i)];
    measurements(:, i) = reshape(x', [], 1);
end

% [newCamProj, newX] = sba_wrapper(measurements, camProj, X3D, K);
[newCamPose, newX] = sba_wrapper(measurements, camPose, X3D, K);
Xset(validX, :) = newX;
% [Cset, Rset] = cellfun(@(proj) extractCamPose(K, proj), newCamProj, 'UniformOutput', false);
Cset = cellfun(@(pose) pose(:, 4), newCamPose, 'UniformOutput', false);
Rset = cellfun(@(pose) pose(1:3, 1:3), newCamPose, 'UniformOutput', false);
end

function [C, R] = extractCamPose(K, P)
pose = K \ P;
R = pose(1:3, 1:3);
C = -R' * pose(:, 4);
end
