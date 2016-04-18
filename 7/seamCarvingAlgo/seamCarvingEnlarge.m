function image = seamCarvingEnlarge(sizeEnlarge, image)
    if (sizeEnlarge == 0)
        return;
    end;
    [T, transBitMask] = findTransportMatrix(sizeEnlarge, image);
    image = addOrDeleteSeams(transBitMask, sizeEnlarge, image, @enlargeImageByMask);
end
