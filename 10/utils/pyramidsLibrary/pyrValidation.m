function img = pyrValidation(pyramid)
    img=[];
    for i=1:length(pyramid.list)
        ind = length(pyramid.list) - i + 1;
        [r, c] = size(pyramid.list(ind).detail);
        if(i == 1)        
            pyramid.base = imresize(pyramid.base, [r, c], 'bilinear');
            img  = pyramid.base + pyramid.list(ind).detail;
        else
            img = imresize(img, [r, c], 'bilinear');
            img = img + pyramid.list(ind).detail;        
        end
    end

end