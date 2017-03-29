function [Cset,Rset] = ExtractCameraPose(E)
%% Input
% E: essential matrix
%% Output:
% Cset and Rset: four congurations of camera centers and rotations, 
% i.e., Cset{i}=Ci and Rset{i}=Ri.

%% Your Code goes here
W = [0 -1 0;
     1  0 0;
     0  0 1];
[U, D, V] = svd(E);
Cset = cell(4, 1);
Rset = cell(4, 1);

Cset{1} = U(:, 3);
Cset{2} = -U(:, 3);
Cset{3} = U(:, 3);
Cset{4} = -U(:, 3);
Rset{1} = U * W * V';
Rset{2} = Rset{1};
Rset{3} = U * W' * V';
Rset{4} = Rset{3};

if det(Rset{1}) < 0
    Cset{1} = -Cset{1};
    Rset{1} = -Rset{1};
    Cset{2} = -Cset{2};
    Rset{2} = -Rset{2};
end

if det(Rset{3}) < 0
    Cset{3} = -Cset{3};
    Rset{3} = -Rset{3};
    Cset{4} = -Cset{4};
    Rset{4} = -Rset{4};
end

end
