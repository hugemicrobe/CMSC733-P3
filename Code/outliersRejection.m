function [ outV ] = outliersRejection( Mx, My, V )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
imageNum = size(V, 2);
outV = V;

for i = 1:(imageNum - 1)
    for j = i:imageNum
        
        % the case that #of matches < 8
        [match1, match2, idx] = findCommonMatch(Mx, My, V, i, j);
        [~, ~, inliers] = GetInliersRANSAC(match1, match2);
        %
        % idx(idx) = (idx(idx) & ~inliers) <--- if use logical type idx
%         outLiersIdx = idx(~inliers);
%         outV(outLiersIdx, i) = 0;
%         outV(outLiersIdx, j) = 0;
        outV(~inliers, i) = 0;
        outV(~inliers, j) = 0;
    end
end

end

