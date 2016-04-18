function res = energyRGB(I)

    res = 0;
    for i = 1:3,
        res = res + abs(imfilter(I(:, :, i), [-1,0,1], 'replicate')) + abs(imfilter(I(:, :, i), [-1;0;1], 'replicate')); 
    end
end

