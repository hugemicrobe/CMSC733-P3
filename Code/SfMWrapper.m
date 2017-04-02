clear clc;
clear;

addpath(genpath('.'))
%% load matching file
load('../Data/matchesMeta.mat', 'Mx', 'My', 'V', 'Color');

%% load K here
K = [568.996140852 0 643.21055941;
     0 568.988362396 477.982801038;
     0 0 1];

imageNum = size(V, 2);

%% Find inliers between every image pair
inliersV = outliersRejection(Mx, My, V);
disp('Outliers rejection done...')

%% First image pair
initialImage1 = 1;
initialImage2 = 2;

[x1, x2, idx] = findCommonMatch(Mx, My, inliersV, initialImage1, initialImage2);

%% extract camera pose
F = EstimateFundamentalMatrix(x1, x2);
E = EssentialMatrixFromFundamentalMatrix(F, K);
[Cset, Rset] = ExtractCameraPose(E);

%% linear triangulation
Xset = cell(4, 1);
for i = 1:4
    Xset{i} = LinearTriangulation(K, zeros(3, 1), eye(3), Cset{i}, Rset{i}, x1, x2);
end

%% Disambihuate Camera Pose
[C, R, X0] = DisambiguateCameraPose(Cset, Rset, Xset);

%% Nonlinear triangulation
X = NonlinearTriangulation(K, zeros(3, 1), eye(3), C, R, x1, x2, X0);
disp('NonlinearTriangulation done...')

%% Add to result
resultC{1} = zeros(3, 1);
resultR{1} = eye(3);
resultC{2} = C;
resultR{2} = R;
resultX = zeros(size(inliersV, 1), 3);
resultX(idx, :) = X;
reconstructedX = false(size(inliersV, 1), 1);
reconstructedX(idx) = 1;
reconstructedV = false(size(inliersV, 1), imageNum);
reconstructedV(idx, initialImage1) = 1;
reconstructedV(idx, initialImage2) = 1;
usedIdx = [initialImage1, initialImage2];
disp('First pair of images done...')

for i = 1:(imageNum - 2)
    %% find next image to process
    [nextImgIdx, nextCommonIdx] = findNextImgIdx(inliersV, reconstructedX, usedIdx);
    x1 = [Mx(nextCommonIdx, nextImgIdx), My(nextCommonIdx, nextImgIdx)];
    X = resultX(nextCommonIdx, :);
    %% estimate camera pose
    [newC, newR, inliers] = PnPRANSAC(X, x1, K);
%     inliersIdx = nextCommonIdx(inliers);
%     x1 = [Mx(inliersIdx, nextImgIdx), My(inliersIdx, nextImgIdx)];
%     X = resultX(inliersIdx, :);
    [newC, newR] = NonlinearPnP(X, x1, K, newC, newR);
    disp('NonlinearPnP done...')
    %% add to result
    resultC{end + 1} = newC;
    resultR{end + 1} = newR;
    %% register new 3D points
    [resultX, reconstructedX, reconstructedV] = register3DPoints(K, Mx, My, inliersV, ...
                                                    nextImgIdx, resultC, resultR, resultX, ...
                                                    reconstructedX, reconstructedV, usedIdx);
    disp('Register 3D points done')
    usedIdx(end + 1) = nextImgIdx;
    %% BA
    [resultC, resultR, resultX] = BundleAdjustment(K, resultC, resultR, resultX, ...
                                    reconstructedX, Mx(:, usedIdx), My(:, usedIdx));
    disp('BA done...')
    disp(sprintf('Reconstruct points from fame %d successful', nextImgIdx))
end

