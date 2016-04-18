clc;
clear all;
close all;
Ig=im2double(imread('pgreen.jpg'));
Ib=im2double(imread('pblue.jpg'));
B1=zeros(size(Ib));
B2=zeros(size(Ig));
B1(:,:,1)=61;
B1(:,:,2)=86;
B1(:,:,3)=166;
B2(:,:,1)=109;
B2(:,:,2)=190;
B2(:,:,3)=69;
alpa1=(Ib-Ig)./(B1-B2);
matte=ones(size(B1))-alpa1;
Foregnd=((Ib-B1)./matte)+B1;
imshow(Foregnd);

