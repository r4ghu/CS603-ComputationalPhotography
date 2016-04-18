function lab = raghu_rgb2lab(rgb)
    cform = makecform('srgb2lab');
    lab = applycform(rgb,cform);
end