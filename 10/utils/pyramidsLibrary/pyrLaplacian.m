function out = pyrLaplacian(img)
    levels = floor(log(min(size(img,1),size(img,2))) / log(2)) - 1;
    list = [];
    for i=1:levels
        %Calculating detail and base layers
        [tempLayer0, tempBase0] = pyrLapGenAux(img);
        img = tempLayer0;
        ts   = struct('detail', tempBase0);
        list = [list, ts];  
    end
    %Base Layer
    out = struct('list', list, 'base', tempLayer0);

end
