function F = EstimateFundamentalMatrix(X1,X2)
%% Input
% X1 and X2: Nx2 matrices whose row represents a correspondence
%% Output
% F: 3x3 Fundamental Matrix of Rank 2

%% Your Code goes here
% X1 --> X2
% X2' * F * X1 = 0


N = size(X1, 1);

[X1, T1] = normPoints(X1);
[X2, T2] = normPoints(X2);

% solve for hat{F}

X1_ = [X1(:, [1 2]), ones(N, 1), X1(:, [1 2]), ones(N, 3), X1(:, [1 2]), ones(N, 3)];
X2_ = [X2(:, [1 1 1 2 2 2]), ones(N, 3)];

A = X1_ .* X2_;

[~,~,f] = svd(A, 0);
F = reshape(f(:,end), 3, 3)';
[U,D,V] = svd(F);
D(end) = 0;
F = U*D*V';
F = T2'*F*T1;


end


function [Y, T] = normPoints(X)

N = size(X, 1);

% subtract mean
T = eye(N) - ones(N)/N;
X = T*X;

% scaling such that MS distance = 2
s = sqrt(2 * N / sum(X(:).^2));
Y = s*X;
T = s*T;

end