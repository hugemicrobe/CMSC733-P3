function m = projection(j, i, rt, xyz, r0, a)
% symbolic projection function
% code automatically generated with maple

K = [a(1) a(2) a(3); 0 a(4) a(5); 0 0 1];

%% Code to fill
% Build P matrix from rt
% rt is 7 dimensional vector-the first three are camera center and the rest are quaternion
R = q2R(rt(1:4)');
% C = -R' * rt(5:7)'; % rt(5:7)' = -R*C
C = rt(5:7)';
% P = K * [R, -R*C];

%% Get xyz
% X = xyz';

%% Code to fill
% Project the 3D point to the camera to produce (u,v)
x = reProject(xyz, K, R, C);
% Return reprojection
m(1) = x(1);
m(2) = x(2);



