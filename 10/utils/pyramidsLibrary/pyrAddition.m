function pyramidOut = pyrAddition(pyramidA, pyramidB)
    %adding base levels
    pyramidOut.base = pyramidA.base + pyramidB.base;
    pyramidOut.list = pyramidA.list;

    %adding the detail of each level
    for i=1:length(pyramidA.list)
        pyramidOut.list(i).detail = pyramidA.list(i).detail + pyramidB.list(i).detail;
    end
end
