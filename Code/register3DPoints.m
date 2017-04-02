function [ outResultX, outReconstructedX, outReconstructedV ] = register3DPoints( K, Mx, My, inliersV, currentImgIdx, resultC, resultR, resultX, reconstructedX, reconstructedV, usedIdx )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
outResultX = resultX;
outReconstructedX = reconstructedX;
outReconstructedV = reconstructedV;
n = length(usedIdx);

for i = 1:n
    refImgIdx = usedIdx(i);
    %% register new 3D points
    commonIdx = find(~outReconstructedX & (inliersV(:, currentImgIdx) == 1) & (inliersV(:, refImgIdx) == 1));
    x1 = [Mx(commonIdx, refImgIdx), My(commonIdx, refImgIdx)];
    x2 = [Mx(commonIdx, currentImgIdx), My(commonIdx, currentImgIdx)];
    newX = LinearTriangulation(K, resultC{refImgIdx}, resultR{refImgIdx}, resultC{currentImgIdx}, resultR{currentImgIdx}, x1, x2);
    newX = NonlinearTriangulation(K, resultC{refImgIdx}, resultR{refImgIdx}, resultC{currentImgIdx}, resultR{currentImgIdx}, x1, x2, newX);
    outResultX(commonIdx, :) = newX;
    outReconstructedX(commonIdx) = 1;
    outReconstructedV(commonIdx, currentImgIdx) = 1;
end

end

