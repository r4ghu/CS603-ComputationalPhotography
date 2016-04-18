function imgOut = deghosting(stack, iters, erosion_kernel_size, dilation_kernel_size, ward_percentile)
    [r,c,col,n] = size(stack);
    total = zeros(r,c);
    weight = ones(r,c,n);
    moveMask = zeros(r,c);
    
    for i=1:n,
        img = stack(:,:,:,i);
        L = 0.2126 * img(:,:,1) + 0.7152 * img(:,:,2) + 0.0722 * img(:,:,3);
        
        % Calculating Mertens Well Exposedness
        sigma  = 0.2; %taken from original paper's parameters
        sigma2 = 2.0*sigma^2;

        well_exposedness = ones(r,c);

        for j=1:col,
            well_exposedness = well_exposedness .* exp(-(img(:,:,j)-0.5).^2/sigma2);
        end
        
        % Calculating Mertens Contrast
        imgEdge = imfilter(L,[0 1 0; 1 -4 1; 0 1 0],'replicate');
        contrast = abs(imfilter(imgEdge,[-1,-1,-1;-1,8,-1;-1,-1,-1],'replicate'));
        
        %Calculating Mertens Saturation
        mean_rgb = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;
        saturation = sqrt(((img(:,:,1)-mean_rgb).^2 + (img(:,:,2)-mean_rgb).^2 + (img(:,:,3)-mean_rgb).^2)/3);
        
        %Calculating weights
        weight(:,:,i) = (well_exposedness .* contrast .* saturation) + 1e-12;
        
        % Move mask
        grey = (54 * img(:,:,1) + 183 * img(:,:,2) +  19 * img(:,:,3)) / 256;
        matrix = sort(reshape(grey, r * c, 1));
        medVal = matrix(max([round(r * c * ward_percentile), 1]));
        mask = zeros(size(grey));
        mask(grey > medVal) = 1.0;
        moveMask = moveMask + mask;
    end
    moveMask(moveMask > 0) = 1;
    dilation_kernel = strel('disk', dilation_kernel_size);
    erosion_kernel = strel('disk', erosion_kernel_size);

    for i=1:iters
        moveMask = imdilate(moveMask, dilation_kernel);
        moveMask = imerode(moveMask, erosion_kernel);
    end

    %calculate connected components
    [moveMask_tmp, num] = bwlabel(moveMask, 4);

    moveMask_final = moveMask_tmp .* moveMask; 
    moveMask_final(moveMask == 0) = -1;
    moveMask = moveMask_final;
    
    weight_move = weight;
    
    for i=0:num
        Weightvec = zeros(n,1);
        for j=1:n
            Weight_layer = weight(:,:,j);
            Weightvec(j) = mean(Weight_layer(moveMask == i));
        end
        [~, j] = max(Weightvec);

        Weight_layer = zeros(r, c);
        Weight_layer(moveMask == i) = 1;
        weight_move(:,:,j) = weight_move(:,:,j) .* (1 - Weight_layer) + Weight_layer;

        for k=1:n
            if(j ~= k)
                weight_move(:,:,k) = weight_move(:,:,k) .* (1 - Weight_layer);
            end
        end
    end
    
    % Weight normalizing and pyramid generation
    for i=1:n,
        total = total + weight_move(:,:,i);
    end
    for i=1:n,
        pyrImg = [];
        for j = 1:col,
            pyrImg = [pyrImg, pyrLaplacian(stack(:,:,j,i))];
        end
        weight_i = weight_move(:,:,i)./total;
        weight_i(isnan(weight_i) | isinf(weight_i)) = 0;
        pyrWeight = pyrGaussian(weight_i);
        
        %Multiplication image times weights
        len = length(pyrImg);
        tmpVal = [];
        for j=1:len
            p = pyrMultiplication(pyrImg(j), pyrWeight);
            tmpVal = [tmpVal, p];
        end

   
        if(i == 1)
            tf = tmpVal;
        else
            tf_temp = [];
             
            for j=1:length(tf)
                p = pyrAddition(tf(j), tmpVal(j));
                tf_temp = [tf_temp, p];
            end

            tf = tf_temp;
        end
    end
    imgOut = zeros(r, c, col);
    for i=1:col
        imgOut(:,:,i) = pyrValidation(tf(i));
    end
    imgOut(imgOut<0) = 0;
    imgOut(imgOut>1) = 1;

end




