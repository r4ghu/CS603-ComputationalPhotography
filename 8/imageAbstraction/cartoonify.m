function cartoonImage = cartoonify(img),
    img = raghu_rgb2lab(img);
    % Initialising the image abstraction parameters (Source: Mathworks)
    max_gradient      = 0.2;    % maximum gradient (for edges)
    sharpness_levels  = [3 14]; % soft quantization sharpness
    quant_levels      = 8;      % number of quantization levels
    min_edge_strength = 0.3;    % minimum gradient (for edges)
    
    %Gradient magnitude of luminance (G)
    [X,Y] = gradient(img(:,:,1)/100);
    G = sqrt(X.^2+Y.^2);
    G(G>max_gradient) = max_gradient;
    G = G/max_gradient;
    
    %Compute the edge map
    E = G;
    E(E<min_edge_strength) = 0;
    %Sharpening 
    S = (G*(sharpness_levels(2)-sharpness_levels(1)))+sharpness_levels(1);
    
    %Soft luminicance quantization
    q_img = img;
    q_img(:,:,1) = (100/(quant_levels-1))*round((1/(100/(quant_levels-1)))*q_img(:,:,1));
    q_img(:,:,1) = q_img(:,:,1)+((100/(quant_levels-1))/2)*tanh(S.*(img(:,:,1)-q_img(:,:,1)));
    
    q_img = raghu_lab2rgb(q_img);
    
    cartoonImage = repmat(1-E,[1 1 3]).*q_img;
    

end