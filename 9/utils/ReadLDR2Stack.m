function stack = ReadLDR2Stack(name_folder,format),
    list = dir([name_folder, '/*.', format]);
    n = length(list);
    name = [name_folder, '/', list(1).name];
    img_info = imfinfo(name);
    stack = zeros(img_info.Height, img_info.Width, img_info.NumberOfSamples, n, 'single');
    for i=1:n
        disp(list(i).name);
        stack(:,:,:,i) = single(imread([name_folder, '/', list(i).name]));    
    end
end