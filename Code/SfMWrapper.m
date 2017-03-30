clear clc;

load('../Data/matchesMeta.mat', 'matches', 'hasMatches');


%% test code for processed data

ii = 1;
jj = 3;

% display matched features
I1 = imread(sprintf('../Data/%d.jpg', ii));
I2 = imread(sprintf('../Data/%d.jpg', jj));
%dispMatchedFeatures(I1, I2, matches{1, 2}{1}, matches{1, 2}{2}, 'montage');

%F = EstimateFundamentalMatrix(matches{1, 2}{1}, matches{1, 2}{2});
[x1, x2] = GetInliersRANSAC(matches{ii, jj}{1}, matches{ii, jj}{2});
dispMatchedFeatures(I1, I2, x1, x2, 'montage');

fprintf('Original #matches = %d, Refined #matches = %d\n', size(matches{ii, jj}{1}, 1), size(x1, 1));


%% load K here
K = [568.996140852 0 643.21055941;
     0 568.988362396 477.982801038;
     0 0 1];

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
