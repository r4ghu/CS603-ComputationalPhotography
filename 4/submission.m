clc;clear;close all;
addpath('./panorama');

im = imread('1.jpg');
points_im = detectSURFFeatures(rgb2gray(im));
[features_im, valid_points_im] = extractFeatures(rgb2gray(im), points_im);

tforms(1) = affine2d(eye(3));
[x(1,:) y(1,:)] = outputLimits(tforms(1),[1 size(im,2)],[1 size(im,1)]);

for i = 2:11,
    im_new = imread(strcat(num2str(i),'.jpg'));
    points = detectSURFFeatures(rgb2gray(im_new));
    [features, valid_points] = extractFeatures(rgb2gray(im_new), points);
    
    indexPairs = matchFeatures(features_im,features);
    matchedPoints_im = valid_points_im(indexPairs(:, 1), :);
    matchedPoints = valid_points(indexPairs(:, 2), :);
    
    [tform,matchedPoints_im,matchedPoints] = estimateGeometricTransform(matchedPoints_im,matchedPoints,'similarity');
    tforms(i) = estimateGeometricTransform(matchedPoints, matchedPoints_im,'affine','Confidence',99.9,'MaxNumTrials',2000);
    tforms(i).T = (tforms(i-1).T * tforms(i).T);
    
    [x(i,:) y(i,:)] = outputLimits(tforms(i),[1 size(im,2)],[1 size(im,1)]);
    % Update features_im,points_im
    features_im = features;
    points_im = points;valid_points_im = valid_points;
end

% Find the centre image
% In Panaromic mode we will usually slide the camera horizontally and take
% the images, so we are considering the case where there is shift in both 
% X and Y coordinates. We know that the images are given in an sequential 
% order. If the input order is jumbled this will help us to find out the 
% center image.
[~,id] = sort(abs(mean(x,2)+mean(y,2)));
center = 6;
centerImage = id(center);

tform_center_inv = invert(tforms(centerImage));

for i=1:11,
    tforms(i).T = tform_center_inv.T * tforms(i).T;
    [x(i,:) y(i,:)] = outputLimits(tforms(i),[1 size(im,2)],[1 size(im,1)]);
end
%initialising the panorama
xMin = min(1,min(x(:))); 
xMax = max(size(im,2),max(x(:)));
yMin = min(1,min(y(:))); 
yMax = max(size(im,1),max(y(:)));

panImg = zeros([round(yMax-yMin) round(xMax-xMin) 3],'uint8');
panViewer = imref2d([round(yMax-yMin) round(xMax-xMin)], [xMin xMax], [yMin yMax]);
blend = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port');
for i=1:11,
    im = imread(strcat(num2str(i),'.jpg'));
    im_warp = imwarp(im,tforms(i), 'OutputView', panViewer);
    panImg = step(blend,panImg,im_warp,im_warp(:,:,1));
end

out = panImg(181:920,61:4500,:);
out = cat(3,medfilt2(out(:,:,1),[3 3]),medfilt2(out(:,:,2),[3 3]),medfilt2(out(:,:,3),[3 3]));
figure;imshow(out);

imwrite(out,'./results/Panorama.png');





    