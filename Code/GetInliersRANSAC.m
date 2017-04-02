function [y1,y2,idx] = GetInliersRANSAC(x1,x2)
%% Input:
% x1 and x2: Nx2 matrices whose row represents a correspondence.
%% Output:
% y1 and y2: Nix2 matrices whose row represents an inlier correspondence 
%            where Ni is the number of inliers.
% idx: Nx1 vector that indicates ID of inlier y1.


%% Your Code goes here
maxIter = 3000;
threshold = 0.005;

N = size(x1, 1);
bestNinliers = 0;

for i = 1:maxIter
    chosen = randperm(N, 8);
    F = EstimateFundamentalMatrix(x1(chosen,:), x2(chosen,:));
    d = evaluateF(x1, x2, F);
    
    inliers = (d < threshold);
    if sum(inliers) > bestNinliers
        bestNinliers = sum(inliers);
        idx = inliers;
    end
end    

y1 = x1(idx, :);
y2 = x2(idx, :);

end


function d = evaluateF(x1, x2, F)
    N = size(x1, 1);

    tmp = [x2 ones(N, 1)] * F;
    tmp = tmp .* [x1 ones(N, 1)]; 
    d = abs(sum(tmp, 2));
end
