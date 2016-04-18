function out = bilateralFilter(image, w, sigma)
    % Convert RGB color space of the image to LAB color space
    image = raghu_rgb2lab(image);
    out = zeros(size(image));
    % Gaussian Domain
    [X,Y] = meshgrid(-w:w,-w:w);
    G = exp(-(X.^2+Y.^2)/(2*sigma(1)^2));
    for i = 1:size(image,1),
        for j = 1:size(image,2),
            local = image(max(i-w,1):min(i+w,size(image,1)),max(j-w,1):min(j+w,size(image,2)),:);
            % Gaussian Range
            gauRange_LAB = zeros(size(local));
            for k=1:3,
                gauRange_LAB(:,:,k) = local(:,:,k)-image(i,j,k);
            end
            H = exp(-(gauRange_LAB(:,:,1).^2+gauRange_LAB(:,:,2).^2+gauRange_LAB(:,:,3).^2)/(2*(100*sigma(2))^2));
            
            bFilter = H.*G((max(i-w,1):min(i+w,size(image,1)))-i+w+1,(max(j-w,1):min(j+w,size(image,2)))-j+w+1);
            for k=1:3,
                out(i,j,k) = sum(sum(bFilter.*local(:,:,k)))/sum(bFilter(:));
            end
        end
    end
    out = raghu_lab2rgb(out);
end