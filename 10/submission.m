clc;clear;close all;

addpath(genpath('./utils'));
name_folder = 'datasets';
format = 'jpg';

fprintf('Reading LDR images into a Stack...\n');
stack = ReadLDR2Stack(name_folder,format);
iters = 1;
erosion_kernel_size = 3;
dilation_kernel_size = 17;
ward_percentile = 0.6;

fprintf('Performing Pece and Kautz Algorithm...\n');
hdr_deghosting = deghosting(stack, iters, erosion_kernel_size, dilation_kernel_size, ward_percentile);

fprintf('Comparing our result with Mertens Algorithm (without deghosting)...\n');
load mertens;
figure;imshow(mertens);title('Ghosting Image(Mertens) for reference');
figure;imshow(hdr_deghosting);title('Result: Deghosting');


fprintf('\n\nAlgorithm Credits:\nFabrizio Pece, and Jan Kautz.\nBitmap Movement Detection: HDR for Dynamic Scenes.\nIn Conference on Visual Media Production (CVMP), 2010\n');


