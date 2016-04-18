clc;clear;close all;
addpath('./dataset');
%Question 1
im = imread('600.jpg');
imN = imnoise(im,'gaussian',0.55,0.001);
j = imread('1600.jpg');
figure;imshow([im imN j]);title('Adding Noise:(from left to right) Original, Created, Noise\_Original');

[peaksnr, ~] = psnr(j, im);
disp(strcat('The value of PSNR for the original noisy image is:',num2str(peaksnr)));

[peaksnr, ~] = psnr(imN, im);
disp(strcat('The value of PSNR for the generated noisy image is:',num2str(peaksnr)));

%Question 2
df_b = imread('Fm2.jpg');
df_f = imread('Finf.jpg');

H = fspecial('average',[25 25]);
b = imfilter(df_f,H,'replicate');
figure; imshow([df_f b df_b]);title('Adding Blur:(from left to right) Original, Created, Blurred\_Original');

grad_df_b = avgGradMag(df_b);
grad_df_f = avgGradMag(df_f);
grad_b = avgGradMag(b);
disp(strcat('The value of average gradient magnitude measure for the original image is:',num2str(grad_df_b)));
disp(strcat('The value of average gradient magnitude measure for the original blurred image is:',num2str(grad_df_f)));
disp(strcat('The value of average gradient magnitude measure for the created blurred image is:',num2str(grad_b)));

%Question 3
motion = imread('mblur_off.jpg');
m_blur = imread('mblur_on.jpg');

m = imcrop(motion,[1920 130 1152 1310]);
H = fspecial('motion',100,0);
m_b = imfilter(m,H,'replicate');
test = motion;
test(130:(130+1310),1920:(1920+1152),:) = m_b;

figure;imshow([motion test m_blur]);title('Adding Motion Blur:(from left to right) Original, Created, Motion Blurred\_Original');

grad_motion = avgGradMag(motion);
grad_test = avgGradMag(test);
grad_m_b = avgGradMag(m_b);
disp(strcat('The value of average gradient magnitude measure for the original image is:',num2str(grad_motion)));
disp(strcat('The value of average gradient magnitude measure for the original blurred image is:',num2str(grad_test)));
disp(strcat('The value of average gradient magnitude measure for the created blurred image is:',num2str(grad_m_b)));

% Write the results
imwrite(im,'./results/1_Original_Noiseless.png');
imwrite(imN,'./results/1_Created_Noise.png');
imwrite(j,'./results/1_Original_Noise.png');
imwrite(df_f,'./results/2_Original_Focused.png');
imwrite(b,'./results/2_Created_Defocused.png');
imwrite(df_b,'./results/2_Original_Defocused.png');
imwrite(motion,'./results/3_Original_Motion.png');
imwrite(test,'./results/3_Created_MotionBlur.png');
imwrite(m_blur,'./results/3_Original_MotionBlur.png');