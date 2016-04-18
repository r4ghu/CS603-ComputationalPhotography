clc;clear;close all;
addpath('./dataset');

im1 = double(imread('lena.png'));
im2 = double(imread('girl.png'));

H_h = [0,-1,1];
H_v = H_h.';
im1_h = imfilter(im1,H_h,'replicate');
im1_v = imfilter(im1,H_v,'replicate');
im2_h = imfilter(im2,H_h,'replicate');
im2_v = imfilter(im2,H_v,'replicate');

% Creating the mask parameters
mask_width = 55; mask_height = 15;
im1_X = 125;im1_Y = 125;
im2_X = 90;im2_Y = 100;


im1(im1_Y:im1_Y+mask_height,im1_X:im1_X+mask_width,:) = im2(im2_Y:im2_Y+mask_height,im2_X:im2_X+mask_width,:);
im1_h(im1_Y:im1_Y+mask_height,im1_X:im1_X+mask_width,:) = im2_h(im2_Y:im2_Y+mask_height,im2_X:im2_X+mask_width,:);
im1_v(im1_Y:im1_Y+mask_height,im1_X:im1_X+mask_width,:) = im2_v(im2_Y:im2_Y+mask_height,im2_X:im2_X+mask_width,:);
mask = zeros(size(im1));
mask(im1_Y:im1_Y+mask_height,im1_X:im1_X+mask_width,:) = 1;
%figure;imshow(uint8(im1));

%Poisson image editing (using Jacobi algorithm)
n_iter = 1000;
eps = 10^-3;
K = [0,1,0;1,0,1;0,1,0];
%Gradient to laplacian
lap = circshift(im1_h,[0,1]) + circshift(im1_v,[1,0]) - im1_h - im1_v;
ref = im1;
tmp = im1;p = mask>0;diff_m0 = 10^32;
for i=1:n_iter,
    lpf = imfilter(im1,K,'replicate');
    im1(p) = (lap(p)+lpf(p))/4;
    diff = abs(im1-tmp);
    diff_m = max(diff(:));
    if (diff_m0-diff_m)/diff_m0 < eps,
        break
    end
    tmp = im1;
    diff_m0 = diff_m;
end
figure;imshow(uint8([ref im1])),title('Poisson Compositing')


%Laplacian Compositing
im1 = double(imread('lena.png'));
im2 = double(imread('girl.png'));
%Generate pyramids with level 5
l_im1 = cell(1,5);
l_im2 = cell(1,5);
l_im1{1} = im1;
l_im2{1} = im2;

cw = 0.375; %Kernel centre weight
ker1d = [0.25-cw/2 0.25 cw 0.25 0.25-cw/2]; %kernel in 1D
kernel = kron(ker1d,ker1d'); %Kronecker product for getting the 2D version of kernel

for i = 2:5,
    img1 = [];img2 = [];
    for j = 1:size(im1,3),
        imgF1 = imfilter(l_im1{i-1}(:,:,j),kernel,'replicate','same');
        imgF2 = imfilter(l_im2{i-1}(:,:,j),kernel,'replicate','same');
        img1(:,:,j) = imgF1(1:2:size(imgF1,1),1:2:size(imgF1,2));
        img2(:,:,j) = imgF2(1:2:size(imgF2,1),1:2:size(imgF2,2));
    end
    l_im1{i} = img1;l_im2{i} = img2;
end
        
%Adjust the image size
for i = 4:-1:1
	sz1 = size(l_im1{i+1})*2-1;
	l_im1{i} = l_im1{i}(1:sz1(1),1:sz1(2),:);
    sz2 = size(l_im2{i+1})*2-1;
	l_im2{i} = l_im2{i}(1:sz2(1),1:sz2(2),:);
end
kernel = kernel*4;
kw = 5; %default kernel width
% expand [a] to [A00 A01;A10 A11] with 4 kernels
ker00 = kernel(1:2:kw,1:2:kw); % 3*3
ker01 = kernel(1:2:kw,2:2:kw); % 3*2
ker10 = kernel(2:2:kw,1:2:kw); % 2*3
ker11 = kernel(2:2:kw,2:2:kw); % 2*2
for i = 1:4,
    sz1 = size(l_im1{i+1}(:,:,1))*2-1;
    sz2 = size(l_im2{i+1})*2-1;
    img1 = zeros(sz1(1),sz1(2),size(l_im1{i+1},3));
    img2 = zeros(sz2(1),sz2(2),size(l_im2{i+1},3));
    for j=1:size(im1,3),
        img1_h = padarray(l_im1{i+1}(:,:,j),[0,1],'replicate','both');
        img1_v = padarray(l_im1{i+1}(:,:,j),[1,0],'replicate','both');
        img2_h = padarray(l_im2{i+1}(:,:,j),[0,1],'replicate','both');
        img2_v = padarray(l_im2{i+1}(:,:,j),[1,0],'replicate','both');
        
        img1(1:2:sz1(1),1:2:sz1(2),j) = imfilter(l_im1{i+1}(:,:,j),ker00,'replicate','same');
        img1(1:2:sz1(1),2:2:sz1(2),j) = conv2(img1_v,ker01,'valid'); % imfilter doesn't support 'valid'
        img1(2:2:sz1(1),1:2:sz1(2),j) = conv2(img1_h,ker10,'valid');
        img1(2:2:sz1(1),2:2:sz1(2),j) = conv2(l_im1{i+1}(:,:,j),ker11,'valid');
        
        img2(1:2:sz2(1),1:2:sz2(2),j) = imfilter(l_im2{i+1}(:,:,j),ker00,'replicate','same');
        img2(1:2:sz2(1),2:2:sz2(2),j) = conv2(img2_v,ker01,'valid');
        img2(2:2:sz2(1),1:2:sz2(2),j) = conv2(img2_h,ker10,'valid');
        img2(2:2:sz2(1),2:2:sz2(2),j) = conv2(l_im2{i+1}(:,:,j),ker11,'valid');
    end
    l_im1{i} = l_im1{i}-img1;
    l_im2{i} = l_im2{i}-img2;
end

blurKernel = fspecial('gauss',30,15);
mask1 = imfilter(1-mask,blurKernel,'replicate');
mask2 = imfilter(mask,blurKernel,'replicate');

l_im = cell(1,5);
for i = 1:5,
    mask1i = imresize(mask1,[size(l_im1{i},1),size(l_im1{i},2)]);
    mask2i = imresize(mask2,[size(l_im2{i},1),size(l_im2{i},2)]);
    l_im{i} = l_im1{i}.*mask1i + l_im2{i}.*mask2i;
end

for i = 4:-1:1,
    sz = size(l_im{i+1}(:,:,1))*2-1;
    img = zeros(sz(1),sz(2),size(l_im{i+1},3));
    
    for j=1:size(im1,3),
        img_h = padarray(l_im{i+1}(:,:,j),[0,1],'replicate','both');
        img_v = padarray(l_im{i+1}(:,:,j),[1,0],'replicate','both');
        
        img(1:2:sz(1),1:2:sz(2),j) = imfilter(l_im{i+1}(:,:,j),ker00,'replicate','same');
        img(1:2:sz(1),2:2:sz(2),j) = conv2(img_v,ker01,'valid'); % imfilter doesn't support 'valid'
        img(2:2:sz(1),1:2:sz(2),j) = conv2(img_h,ker10,'valid');
        img(2:2:sz(1),2:2:sz(2),j) = conv2(l_im{i+1}(:,:,j),ker11,'valid');
    end
    l_im{i} = l_im{i}+img;
end

img_ref_l = mask1.*im1+mask2.*im2;
figure,imshow(uint8([img_ref_l imresize(l_im{1},[size(img_ref_l,1) size(img_ref_l,2)])]));title('Laplacian Compositing');
   
    
