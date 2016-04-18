function image = seamCarving(newSize, image,type)
    sizeX = size(image, 1) - newSize(1);
    sizeY = size(image, 2) - newSize(2);
    
    mmax = @(left, right) max([left right]);
    
    if type==0,
        image = seamCarvingReduce([mmax(0, sizeX), mmax(0, sizeY)], image);
    
    else,
        image = seamCarvingEnlarge([mmax(0, sizeX), mmax(0, sizeY)], image);
    end
end