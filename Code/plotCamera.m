function h = plotCamera(h, C, R)
figure(h);

rot = [0 -1 0; 0 0 -1; 1 0 0];

camLoc = rot' * C;
camOri = R * rot;
plot3(camLoc(1), camLoc(2), camLoc(3), 'rs', 'MarkerSize', 10);
quiver3(camLoc(1), camLoc(2), camLoc(3), camOri(3, 1), camOri(3, 2), camOri(3, 3), 5);


end