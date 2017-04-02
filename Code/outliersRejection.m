function [ outV ] = outliersRejection( Mx, My, V )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
imageNum = size(V, 2);
outV = V;

for i = 1:(imageNum - 1)
    for j = (i + 1):imageNum
        
        % the case that #of matches < 8
        [match1, match2, idx] = findCommonMatch(Mx, My, V, i, j);
        if (size(match1, 1) < 8)
            continue
        end
        [~, ~, inliers] = GetInliersRANSAC(match1, match2);
        
        disp(sprintf('i = %d, j = %d, # of inliers = %d / %d', i, j, sum(inliers), sum(idx)))
        %
        % idx(idx) = ~inliers <--- if use logical type idx
        changeIdx = idx;
        changeIdx(idx) = ~inliers;
%         outV(changeIdx, i) = 0;
        outV(changeIdx, j) = 0;
    end
end

end

