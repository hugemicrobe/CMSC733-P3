function processMatchFile

matchFileDir = '../Data';

nImages = 6;


matches = cell(nImages);
hasMatches = false(nImages);

for i = 1:nImages-1    
    filename = sprintf('%s/matching%d.txt', matchFileDir, i);
    fid = fopen(filename);
    
    % skip the first line
    fgets(fid);
    tline = fgets(fid);
    
    while ischar(tline)
        m = str2num(tline);
        
        assert(numel(m) == 3*m(1)+3, 'Number of matches not correct ...');
        
        for k = 1:m(1)-1
            j = m(3*k+4);
            
            if hasMatches(i, j)
                matches{i, j}{1} = [matches{i, j}{1}; m(5) m(6)];
                matches{i, j}{2} = [matches{i, j}{2}; m(3*k+5) m(3*k+6)];
            else
                matches{i, j}{1} = [m(5) m(6)];
                matches{i, j}{2} = [m(3*k+5) m(3*k+6)];
                hasMatches(i, j) = true;
            end    
            
        end    
        
        tline = fgets(fid);
    end
    
    fclose(fid);
    
end
    save('../Data/matchesMeta.mat', 'matches', 'hasMatches');
end