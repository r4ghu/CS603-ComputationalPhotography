function imgOut = buildHDRfromStack(stack, exposure, lin_fun)
    [r, c, col, n] = size(stack);
    imgOut    = zeros(r, c, col, 'single');
    totalWeight = zeros(r, c, col, 'single');
    if max(stack(:))>1,
        scale = max(stack(:));
    else
        scale = 1.0;
    end
    stack = stack/scale;
    for i=1:n,
        tmp = stack(:,:,:,i);
        tmp(tmp<0.0) = 0.0;
        tmp(tmp>1.0) = 1.0;
        weight = ones(size(tmp));
        tmp = round(tmp * 255) + 1;

        for i=1:size(tmp, 3)
            work = zeros(size(tmp(:,:,i)));
            values = unique(tmp(:,:,i));
            for j=1:length(values)
                work(tmp(:,:,i) == values(j)) = lin_fun(values(j), i);
            end
            tmp(:,:,i) = work;
        end
        imgOut = imgOut + weight .* (log(tmp) - log(exposure(i)));
        totalWeight = totalWeight + weight;

    end
    imgOut = double(exp(imgOut ./ totalWeight));
    
end

