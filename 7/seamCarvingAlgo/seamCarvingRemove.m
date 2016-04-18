function image = seamCarvingRemove(sizeReduction, image)
    if (sizeReduction == 0)
        return;
    end;
    [T, transBitMask] = findTransportMatrixRemover(sizeReduction, image);
    image = DeleteSeams(transBitMask, sizeReduction, image, @reduceImageByMask);
end
