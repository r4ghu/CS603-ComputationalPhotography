function imageReduced = reduceImageByMask( image, seamMask, isVerical )

    if (isVerical)
        imageReduced = zeros(size(image, 1), size(image, 2) - 1, size(image, 3));
        for i = 1 : size(seamMask, 1),
            for k= 1:3,
                imageReduced(i, :, k) = image(i, seamMask(i, :), k);
            end
        end
    else
        seamMask = seamMask';
        imageReduced = zeros(size(image, 1) - 1, size(image, 2), size(image, 3));
        for j = 1 : size(seamMask, 2),
            
            imageReduced(:, j, 1) = image(seamMask(:, j), j, 1);
            imageReduced(:, j, 2) = image(seamMask(:, j), j, 2);
            imageReduced(:, j, 3) = image(seamMask(:, j), j, 3);
        end
    end;
end
