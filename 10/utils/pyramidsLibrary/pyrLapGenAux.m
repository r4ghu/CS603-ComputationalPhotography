function [l, b] = pyrLapGenAux(img)
    k = [1,4,6,4,1];
    matrix = k' * k;
    matrix = matrix / sum(sum(matrix));
    %Convolution
    imgOut = imfilter(img, matrix, 'replicate');
    %Downsampling
    l = imresize(imgOut, 0.5, 'bilinear');
    %Upsampling
    [r, c] = size(img);
    imgE = imresize(l, [r, c], 'bilinear');
    %Difference between the two levels
    b = img - imgE;
end