function out = pyrGaussian(img)
    levels = floor(log(min(size(img,1),size(img,2))) / log(2)) - 1;
    list = [];
    kernel = [1,4,6,4,1];
    matrix = kernel' * kernel;
    matrix = matrix / sum(matrix(:));

    for i=1:levels
        %Detail layer
        ts   = struct('detail',img);
        list = [list, ts];  

        %Next level
        %Convolution followed by Downsampling
        imgB = imfilter(img, matrix, 'replicate');
        img = imresize(imgB, 0.5, 'bilinear');
    end

    %Base layer
    out = struct('list', list, 'base', img);
end
