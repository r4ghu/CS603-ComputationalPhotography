function res = energyRGBRemove(I)

    res = 0;
    for i = 1:3,
        res = res + abs(imfilter(I(:, :, i), [-1,0,1], 'replicate')) + abs(imfilter(I(:, :, i), [-1;0;1], 'replicate')); 
    end
    res(I(:,:,1)==0) = -1000;
end

