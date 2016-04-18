close all;
clear all;
clc;

n=5;
hdr = hdrread('office.hdr');
L=(0.299*hdr(:,:,1) + 0.587*hdr(:,:,2) + 0.114*hdr(:,:,3));
L=(log(L));

I=cell(n,1);
temp=L;
I{1,1}=temp;
for i=2:n;
    img = impyramid(temp,'reduce'); 
    I{i,1}=img;
    temp=img;
end


grad=cell(n,1);
for i=1:n;
    temp=I{i,1};
    [Gmag, Gdir]=imgradient(temp,'central');
    grad{i,1}=Gmag*((0.5)^(i-1));
    figure;
    imshow(grad{i,1});
end

attncell=cell(n,1);
for i=1:n;
    temp=grad{i,1};
    alp=0.2*mean(temp(:));
    beta=0.89;
    temp1=(alp^(1-beta))*(temp.^(beta-1));
    attncell{i,1}=temp1;
end

for i=1:n-1;
    temp = imresize(attncell{n-i+1,1},size(attncell{n-i,1}),'bilinear');
    attncell{n-i,1}=attncell{n-i,1}.*temp;
end
phi=attncell{1,1};
phi(isinf(phi))=0;

[Hx,Hy]=imgradientxy(I{1,1},'intermediate');
Hx=Hx.*phi;
Hy=Hy.*phi;
Lnew=poisson_solver_function_neumann(Hx,Hy);
%Lnew(isinf(Lnew))=0;
s=0.6;
Image(:,:,1)=((hdr(:,:,1)./exp(L)).^(s)).*exp(Lnew);
Image(:,:,2)=((hdr(:,:,2)./exp(L)).^(s)).*exp(Lnew);
Image(:,:,3)=((hdr(:,:,3)./exp(L)).^(s)).*exp(Lnew);
imshow((Image))





%http://www.mathworks.com/matlabcentral/fileexchange/16201-toolbox-image/content/toolbox_image/tests/test_hdr_tonemapping.m