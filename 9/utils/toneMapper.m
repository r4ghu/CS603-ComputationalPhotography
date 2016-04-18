function imgOut = toneMapper(img,pAlpha)
    % Computing tone mapped image in linear domain
    L = 0.2126 * img(:,:,1) + 0.7152 * img(:,:,2) + 0.0722 * img(:,:,3);
    [n,m] = size(L);
    L_sort = sort(reshape(L, n * m, 1));
    LMax = L_sort(max([round(n * m * 0.99), 1]));
    LMin = L_sort(max([round(n * m * 0.01), 1]));
    pWhite = 1.5 * 2^(log2(LMax + 1e-9) - log2(LMin + 1e-9) - 5);
    pPhi = 8;
    delta = 1e-6;
    Lwa = log(L + delta);
    Lwa = exp(mean(Lwa(:)));
    Lscaled = (pAlpha * L) / Lwa;
    
    %Parameters taken from online
    sMax    = 8;     
    epsilon = 0.05;
    alpha1  = (((2^pPhi) * pAlpha) / (sMax^2)) * epsilon;
    alpha2  = round(1.6^sMax);    

    L_tmp = Lscaled ./ (Lscaled + 1);
    L_adapt = bilateralFilter(L_tmp,3, [alpha2, alpha1]);
    L_adapt = L_adapt ./ (1 - L_adapt);

    %Range compression
    pWhite2 = pWhite * pWhite;
    Ld = (Lscaled .* (1 + Lscaled/ pWhite2))./(1 + L_adapt);

    %Changing luminance
    imgOut = zeros(size(img));

    for i=1:size(img, 3)
        imgOut(:,:,i) = (img(:,:,i) .* Ld) ./ L;
    end
    imgOut(isnan(imgOut) | isinf(imgOut)) = 0;
    
    % Applying the Gamma TMO
    imgOut = imgOut.^(1/2.2);
    imgOut(imgOut>1) = 1;
    imgOut(imgOut<0) = 0;
end


