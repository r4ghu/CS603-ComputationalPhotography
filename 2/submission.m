clc;clear;close all;
addpath('./dataset');
%Question 1
im = im2double(imread('mblur_off.jpg'));
% Adding motion blur
PSF = fspecial('motion',100,0);
m = imcrop(im,[1920 130 1152 1310]);
m_blurred = imfilter(m,PSF,'conv','circular');
% Additive Gaussian noise
gaussian_mean = 0;gaussian_var = 0.0001;
m_blurred_noisy = imnoise(m_blurred,'gaussian',gaussian_mean,gaussian_var);
% Image Restoration
E_nsr = gaussian_var/var(m(:));
weiner_m = weinerFilter(m_blurred_noisy, PSF, E_nsr);
% test = im;
% test(130:(130+1310),1920:(1920+1152),:) = weiner_m;
figure;imshow([weiner_m m m_blurred_noisy]);title('Removing Gaussian noise and Motion Blur:(from left to right) Recovered, Original, Noise+Motion Blurred');

% Question 2
im = im2double(imread('Finf.jpg'));
% Adding defocus blur
PSF = fspecial('average',[25 25]);
im_blurred = imfilter(im,PSF,'conv','circular');
% Additive Gaussian noise
gaussian_mean = 0;gaussian_var = 0.0001;
im_blurred_noisy = imnoise(im_blurred,'gaussian',gaussian_mean,gaussian_var);
% Image Restoration
E_nsr = gaussian_var/var(im(:));
weiner_d = weinerFilter(im_blurred_noisy, PSF, E_nsr);
figure;imshow([weiner_d im im_blurred_noisy]);title('Removing Gaussian noise and Defocus Blur:(from left to right) Recovered, Original(Cropped), Noise+Defocus Blurred');

% Write the results
imwrite(weiner_m,'./results/Recovered_Noise_MotionBlur_0_0001.png');
imwrite(weiner_d,'./results/Recovered_Noise_DefocusBlur_0_0001.png');