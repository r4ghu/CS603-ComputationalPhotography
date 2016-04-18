clc;clear;close all;

addpath('./utils');
name_folder = 'datasets';
format = 'jpg';

fprintf('Reading LDR images into a Stack...\n');
stack = ReadLDR2Stack(name_folder,format);
fprintf('Exposure values of LDR images...\n');
exposure = [32;8;128];
fprintf('Computing the Camera Response Function...\n');
lin_fun = computeCameraResponseFunction(stack, exposure, 512);
figure;plot(lin_fun);title('Camera Response Function');
drawnow;
fprintf('Build the HDR image from stack...\n');
imgHDR = buildHDRfromStack(stack, exposure, lin_fun);
fprintf('Tone mapping...\n');
imgHDR_tonemap = toneMapper(imgHDR,0.18);
figure;imshow(imgHDR_tonemap);