function [ match1, match2, idx ] = findCommonMatch( Mx, My, V, imgIdx1, imgIdx2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

idx = find((V(:, imgIdx1) == 1) & (V(:, imgIdx2) == 1));
match1 = [Mx(idx, imgIdx1) My(idx, imgIdx1)];
match2 = [Mx(idx, imgIdx2) My(idx, imgIdx2)];

end

