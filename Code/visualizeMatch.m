function visualizeMatch(i1, i2, Mx, My, V)

I1 = imread(sprintf('../Data/%d.jpg', i1));
I2 = imread(sprintf('../Data/%d.jpg', i2));

[x1, x2, ~] = findCommonMatch(Mx, My, V, i1, i2);


dispMatchedFeatures(I1, I2, x1, x2, 'montage');

end