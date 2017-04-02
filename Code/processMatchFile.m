function processMatchFile

matchFileDir = '../Data';

nImages = 6;

Mx = [];
My = [];
V = [];
C = [];


for i = 1:nImages-1    
    filename = sprintf('%s/matching%d.txt', matchFileDir, i);
    fid = fopen(filename);
    
    % the first line: 'nFeatures: [number]'
    fscanf(fid, '%s', 1);
    nFeats = fscanf(fid, '%d', 1);
    
    % store matching, visibility, color info for the current image
    curr_x = zeros(nFeats, nImages);
    curr_y = zeros(nFeats, nImages);
    curr_V = zeros(nFeats, nImages);
    curr_C = zeros(nFeats, 3);
    
    for n = 1:nFeats
        
        matches = fscanf(fid, '%d', 1);
        curr_C(n, :) = fscanf(fid, '%d %d %d', 3);
        curr_x(n, i) = fscanf(fid, '%f', 1);
        curr_y(n, i) = fscanf(fid, '%f', 1);
        curr_V(n, i) = 1;
        
        for k = 1:matches-1
            j = fscanf(fid, '%d', 1);
            curr_x(n, j) = fscanf(fid, '%f', 1);
            curr_y(n, j) = fscanf(fid, '%f', 1);
            curr_V(n, j) = 1;
        end
    end    
    
    Mx = [Mx; curr_x];
    My = [My; curr_y];
    V = [V; curr_V];
    C = [C; curr_C];
    
    
    fclose(fid);
    
end

    Color = cast(C, 'uint8');
    V = cast(V, 'logical');
    save('../Data/matchesMeta.mat', 'Mx', 'My', 'V', 'Color');
end