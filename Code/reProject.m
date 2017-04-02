function x = reProject(X, K, R, C)

N = size(X, 1);
homX = [X ones(N, 1)];
P = K * [R -R*C];

homx = homX * P';

x = homx(:, 1:2) ./ repmat(homx(:,3), [1 2]);


end