im = im2double(imread('Beach.jpg'));
temp = imread('pigeonMask.jpg');
temp = im2double(temp(:,:,1));
temp(temp>220) = -1000;
temp(temp>0) = 255;
mask = im2double(temp);

%% Process too slow
im = cat(3,im(:,:,1).*mask,im(:,:,2).*mask,im(:,:,3).*mask);

newSize = [size(im, 1) - 60, size(im, 2) - 80];
%Reduce the image
fprintf('Reducing the image\n');
image = seamCarvingRemove(newSize, im);

figure;imshow(image);
title(['Reduced picture: ' int2str(size(image, 1)) 'x' int2str(size(image, 2))]);

