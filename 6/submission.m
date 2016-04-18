clc;clear;close all;
addpath('./dataset');
addpath('./openexr-matlab');

beta = 0.91;
im = hdrread('./dataset/memorial.hdr');
% Calculate the Luminanace of im in log scale
L=log(0.299*im(:,:,1) + 0.587*im(:,:,2) + 0.114*im(:,:,3));

levels = 5;
I=cell(levels,1);I{1} = L;
gradient = cell(levels,1); 
[Gmag, Gdir] = imgradient(L,'central');
gradient{1} = Gmag;
att = cell(levels,1);
alpha = 0.1*mean(gradient{1}(:));
att{1} = (alpha^(1-beta))*(gradient{1}.^(beta-1));


for i=2:levels;
    I{i} = impyramid(I{i-1},'reduce'); 
    [Gmag,Gdir] = imgradient(I{i},'central');
    gradient{i} = Gmag*((0.5)^(i-1));
    alpha = 0.2*mean(gradient{i}(:));
    att{i} = (alpha^(1-beta))*(gradient{i}.^(beta-1));

end

for i=1:levels-1;
    att{levels-i,1}=att{levels-i,1}.*imresize(att{levels-i+1,1},size(att{levels-i,1}),'bilinear');
end
phi = att{1};
phi(isinf(phi))=0;

[grad_x,grad_y]=imgradientxy(I{1},'intermediate');
grad_x=grad_x.*phi; grad_y=grad_y.*phi;

%Poission Neumann
[height,width] = size(grad_x);
grad_x(:,end) = 0;
grad_y(end,:) = 0;
grad_x = padarray(grad_x,[1 1],0,'both');
grad_y = padarray(grad_y,[1 1],0,'both');

grad_xx = zeros(size(grad_x)); grad_yy = grad_xx;

% Laplacian
grad_yy((1:height+1)+1,1:width+1) = grad_y((1:height+1)+1,1:width+1) - grad_y((1:height+1),1:width+1);
grad_xx((1:height+1),(1:width+1)+1) = grad_x((1:height+1),(1:width+1)+1) - grad_x((1:height+1),1:width+1);
f = grad_xx + grad_yy;
f = dct2(f(2:end-1,2:end-1));
%eigen values
[x,y] = meshgrid(0:width-1,0:height-1);
den = (2*cos(pi*x/(width))-2) + (2*cos(pi*y/(height)) - 2);

%divide, avoiding zero division
f(2:end) = f(2:end)./den(2:end);
Lnew = idct2(f);
s=0.6345;
for i=1:3,
    out(:,:,i)=((im(:,:,i)./exp(L)).^(s)).*exp(Lnew);
end

figure;imshow([im out]);title('original HDR');
hdrwrite(out,'./results/out.hdr');

clear;



% Blue and green screen matting
im_g=im2double(imread('./dataset/greenbg.jpg'));
G=zeros(size(im_g));
G(:,:,1)=109;G(:,:,2)=190;G(:,:,3)=69;
im_b=im2double(imread('./dataset/bluebg.jpg'));
B=zeros(size(im_b));
B(:,:,1)=61;B(:,:,2)=86;B(:,:,3)=166;

alpha=(im_b-im_g)./(B-G);
mat=ones(size(B))-alpha;
FG=((im_b-B)./mat)+B;
figure;imshow([im_g im_b FG]);title('green;blue;final');
% imwrite(FG,'./results/FG.png');

clear