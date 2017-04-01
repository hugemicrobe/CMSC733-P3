clear clc;

%% load matching file
load('../Data/matchesMeta.mat', 'Mx', 'My', 'V', 'C');

%% load K here
K = [568.996140852 0 643.21055941;
     0 568.988362396 477.982801038;
     0 0 1];

imageNum = size(V, 2);

%% Find inliers between every image pair
inliersV = outliersRejection(Mx, My, V);

%% First image pair
initialImage1 = 1;
initialImage2 = 4;

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

%% Add to result
resultC{initialImage1} = zeros(3, 1);
resultR{initialImage1} = eye(3);
resultC{initialImage2} = C;
resultR{initialImage2} = R;
resultX = zeros(size(inliersV, 1), 2);
resultX(idx, :) = X;
reconstructedX = false(size(inliersV, 1), 1);
reconstructedX(idx) = 1;
reconstructedV = false(size(inliersV, 1), imageNum);
reconstructedV(idx, initialImage1) = 1;
reconstructedV(idx, initialImage2) = 1;
usedIdx = [initialImage1, initialImage2];

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
    %% add to result
    resultC{end + 1} = newC;
    resultR{end + 1} = newR;
    %% register new 3D points
    [resultX, reconstructedX, reconstructedV] = register3DPoints(K, Mx, My, inliersV, ...
                                                    nextImgIdx, resultC, resultR, resultX, ...
                                                    reconstructedX, reconstructedV, usedIdx);
    usedIdx(end + 1) = nextImgIdx;
    %% BA
    [resultC, resultR, resultX] = BundleAdjustment(K, resultC, resultR, resultX, ...
                                    reconstructedX, Mx(:, usedIdx), My(:, usedIdx));
end

%% test code for processed data
   
% display matched features
I1 = imread(sprintf('../Data/%d.jpg', initialImage1));
I2 = imread(sprintf('../Data/%d.jpg', initialImage2));
%dispMatchedFeatures(I1, I2, matches{1, 2}{1}, matches{1, 2}{2}, 'montage');

%F = EstimateFundamentalMatrix(matches{1, 2}{1}, matches{1, 2}{2});
[x2, x2] = GetInliersRANSAC(matches{initialImage1, initialImage2}{1}, matches{initialImage1, initialImage2}{2});
dispMatchedFeatures(I1, I2, x2, x2, 'montage');

fprintf('Original #matches = %d, Refined #matches = %d\n', size(matches{initialImage1, initialImage2}{1}, 1), size(x2, 1));


%% load K here
K = [568.996140852 0 643.21055941;
     0 568.988362396 477.982801038;
     0 0 1];

%% extract camera pose
F = EstimateFundamentalMatrix(x2, x2);
E = EssentialMatrixFromFundamentalMatrix(F, K);
[Cset, Rset] = ExtractCameraPose(E);

%% linear triangulation
Xset = cell(4, 1);
for i = 1:4
    Xset{i} = LinearTriangulation(K, zeros(3, 1), eye(3), Cset{i}, Rset{i}, x2, x2);
end

%% Disambihuate Camera Pose
[C, R, X0] = DisambiguateCameraPose(Cset, Rset, Xset);

%% Nonlinear triangulation
X = NonlinearTriangulation(K, zeros(3, 1), eye(3), C, R, x2, x2, X0);

for i = 1:imageNum
   if (ismember(i, usedIdx)) % has been processed
       continue
   end
end
