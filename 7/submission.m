clc;clear;close all;
addpath('./dataset');
addpath('./seamCarvingAlgo');


% Use small pictures because of slow implementation
im = im2double(imresize(imread('./dataset/sea-thai.jpg'),0.5));
%im = im2double(imread('./dataset/sea-thai.jpg'));


figure;imshow(im);
title(['Original picture: ' int2str(size(im, 1)) 'x' int2str(size(im, 2))]);
drawnow;
%imwrite(im, './results/sea-original.jpg');

newSize = [size(im, 1) - 10, size(im, 2) - 20];

%Reduce the image
fprintf('Reducing the image\n');
image = seamCarving(newSize, im, 0);

figure;imshow(image);
title(['Reduced picture: ' int2str(size(image, 1)) 'x' int2str(size(image, 2))]);

%imwrite(image, './results/sea-reduced.jpg');drawnow;

%Enlarge the image
fprintf('Enlarging the image\n');
image = seamCarving(newSize, im, 1);

figure;imshow(image);
title(['Enlarged picture: ' int2str(size(image, 1)) 'x' int2str(size(image, 2))]);drawnow;

%imwrite(image, './results/sea-enlarged.jpg');drawnow;

% Object removal
fprintf('Object Removal process will be too slow. Results are run and placed in the results folder\n');
%objectRemoval;