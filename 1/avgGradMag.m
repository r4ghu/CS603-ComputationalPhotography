function [grad] = avgGradMag(img),

for i=1:3,
    %[Gx, Gy] = imgradientxy(img(:,:,i));
    [Gmag, Gdir] = imgradient(img(:,:,i),'CentralDifference');
    grad_(i) = mean(Gmag(:));
end
grad = mean(grad_);

end