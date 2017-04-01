function [ outV ] = outliersRejection( Mx, My, V )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
imageNum = size(V, 2);
outV = V;

for i = 1:(imageNum - 1)
    for j = i:imageNum
        [match1, match2] = findCommonMatch(Mx, My, V, i, j);
        [~, ~, inliers] = GetInliersRANSAC(match1, match2);
        outLiersIdx = idx(~inliers);
        outV(outLiersIdx, i) = 0;
        outV(outLiersIdx, j) = 0;
    end
end

end

