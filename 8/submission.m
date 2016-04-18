clear;close all;clc;
addpath('./imageAbstraction');
addpath('./dataset');
fprintf('Reading the image...\n');
str = 'academy.jpg';
img = im2double(imread(str));
fprintf('Initialising the filtered parameters...\n');
w = 5;
sigma = [3 0.1];
fprintf('Applying the Bilateral Filter: ');
filteredImage = bilateralFilter(img,w,sigma);
fprintf('Done\nShowing the image...\n');
figure;imshow([img filteredImage]);title('Original(Left) and Filtered(Right) Images');drawnow;
fprintf('Initialising the Cartoon Process...\n');
cartoonImage = cartoonify(filteredImage);
fprintf('Showing the Cartoon image...\n');
figure;imshow(cartoonImage);title('Cartoon Image');
fprintf('\n\nAlgorithm Credits:\nHolger Winnemoller, Sven C. Olsen, and Bruce Gooch.\nReal-Time Video Abstraction. In Proceedings of ACM\nSIGGRAPH, 2006.\n');

imwrite(cartoonImage,['./results/cartoon_' str]);



