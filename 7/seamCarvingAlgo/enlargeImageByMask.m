function imageEnlarged = enlargeImageByMask(image, seamMask, isVerical)

    
    if (isVerical)
        avg = @(image, i, j, k) (image(i, j-1, k) + image(i, j+1, k))/2;
        imageEnlarged = zeros(size(image, 1), size(image, 2) + 1, size(image, 3));
        for i = 1 : size(seamMask, 1)
            j = find(seamMask(i, :) ~= 1);
            for k=1:3,
                imageEnlarged(i, :, k) = [image(i, 1:j, k), avg(image, i, j, k), image(i, j+1:end, k)];
            end
        end;
    else
        avg = @(image, i, j, k) (image(i-1, j, k) + image(i+1, j, k))/2;
        seamMask = seamMask';
        imageEnlarged = zeros(size(image, 1) + 1, size(image, 2), size(image, 3));
        for j = 1 : size(seamMask, 2)
            i = find(seamMask(:, j) ~= 1);
            for k=1:3,
                imageEnlarged(:, j, k) = [image(1:i, j, k); avg(image, i, j, k); image(i+1:end, j, k)];
            end
        end;
    end;
end

