function image = addOrDeleteSeams(transBitMask, sizeReduction, image, operation)

    i = size(transBitMask, 1);
    j = size(transBitMask, 2);

    for it = 1 : sum(sizeReduction)

        energy = energyRGB(image);
        if (transBitMask(i, j) == 0)
            [optSeamMask, ~] = findOptSeam(energy');
            image = operation(image, optSeamMask, 0);
            i = i - 1;
        else
            [optSeamMask, ~] = findOptSeam(energy);
            image = operation(image, optSeamMask, 1);
            j = j - 1;
        end;

    end;
end