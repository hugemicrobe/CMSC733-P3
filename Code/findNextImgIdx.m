function [ maxImgIdx, maxCommonIdx ] = findNextImgIdx( inliersV, reconstructedX, usedIdx )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
imageNum = size(inliersV, 2);
maxCommonIdx = 0;
maxImgIdx = 1;
for i = 1:imageNum
    if (ismember(i, usedIdx))
        continue;
    end
    n = length(usedIdx);
    for j = 1:n
        refImgIdx = usedIdx(j);
        idx = find(reconstructedX & (inliersV(:, i) == 1) & (inliersV(:, refImgIdx) == 1));
        if length(idx) > length(maxCommonIdx)
            maxImgIdx = i;
            maxCommonIdx = idx;
        end
    end
end

end

