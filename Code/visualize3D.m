function h = visualize3D(X, R, C, Color)


rot = [0 -1 0; 0 0 -1; 1 0 0];

h = figure;

mask = sqrt(sum(X.^2, 2)) < 15 & X(:,3) > 0;



camLoc = rot' * C;
camOri = R * rot;
plot3(camLoc(1), camLoc(2), camLoc(3), 'rs', 'MarkerSize', 10);
hold on
quiver3(camLoc(1), camLoc(2), camLoc(3), camOri(3, 1), camOri(3, 2), camOri(3, 3), 5);
showPointCloud(X(mask,:)*rot, Color(mask,:), 'MarkerSize', 15)

%plotCamera('Location', rot'*C, 'Orientation', R* rot, 'Opacity', 0);
end