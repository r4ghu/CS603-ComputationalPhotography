clc;close all;clear;
addpath('dataset');
fprintf('Question 1:\n');
im = im2double(imread('mblur_off.jpg'));

fprintf(strcat('Rank of each channel of the image before SVD:',num2str(rank(im(:,:,1))),'\n'));

[RU,RD,RV] = svd(im(:,:,1));
[GU,GD,GV] = svd(im(:,:,2));
[BU,BD,BV] = svd(im(:,:,3));
zR = zeros(size(RD));zB = zR;zG = zR;

zR(1:50,1:50) = RD(1:50,1:50);
zG(1:50,1:50) = GD(1:50,1:50);
zB(1:50,1:50) = BD(1:50,1:50);
clear RD GD BD

testR = RU*zR*RV';
testB = BU*zB*BV';
testG = GU*zG*GV';
clear RU BU GU zR zB zG RV BV GV

test = cat(3,testR,testG,testB);
clear testR testG testB

fprintf(strcat('Rank of each channel of the image after SVD:',num2str(50),'\n'));

figure;imshow([im test]),title('Original,Compressed');
clear im


imwrite(test,'results/Q1_submission.png');
clear test

fprintf('Question 2:');
imL = imread('l.png');
imR = imread('r.png');
imC = imread('c.png');
pointsL = detectHarrisFeatures(rgb2gray(imL));
pointsR = detectHarrisFeatures(rgb2gray(imR));
pointsC = detectHarrisFeatures(rgb2gray(imC));

[featuresL, valid_pointsL] = extractFeatures(rgb2gray(imL), pointsL);
[featuresC, valid_pointsC] = extractFeatures(rgb2gray(imC), pointsC);
[featuresR, valid_pointsR] = extractFeatures(rgb2gray(imR), pointsR);

indexPairsLC = matchFeatures(featuresL,featuresC);
indexPairsCR = matchFeatures(featuresC,featuresR);
indexPairsLR = matchFeatures(featuresL,featuresR);

matchedPointsL_C = valid_pointsL(indexPairsLC(:, 1), :);
matchedPointsC_L = valid_pointsC(indexPairsLC(:, 2), :);
matchedPointsR_C = valid_pointsR(indexPairsCR(:, 2), :);
matchedPointsC_R = valid_pointsC(indexPairsCR(:, 1), :);
matchedPointsR_L = valid_pointsR(indexPairsLR(:, 2), :);
matchedPointsL_R = valid_pointsL(indexPairsLR(:, 1), :);
[tform,matchedPointsR_L,matchedPointsL_R] = estimateGeometricTransform(matchedPointsR_L,matchedPointsL_R,'similarity');


figure; showMatchedFeatures(imL, imC, matchedPointsL_C, matchedPointsC_L);title('Left, Centre');
figure; showMatchedFeatures(imC, imR, matchedPointsC_R, matchedPointsR_C);title('Centre, Right');
figure; showMatchedFeatures(imL, imR, matchedPointsL_R, matchedPointsR_L);title('Left, Right');
