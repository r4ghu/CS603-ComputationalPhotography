function image = seamCarvingReduce(sizeReduction, image)
    if (sizeReduction == 0)
        return;
    end;
    [T, transBitMask] = findTransportMatrix(sizeReduction, image);
    image = addOrDeleteSeams(transBitMask, sizeReduction, image, @reduceImageByMask);
end
