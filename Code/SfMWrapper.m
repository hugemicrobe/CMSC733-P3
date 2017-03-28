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
%%