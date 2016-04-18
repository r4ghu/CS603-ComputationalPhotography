function rgb = raghu_lab2rgb(lab)
    cform = makecform('lab2srgb');
    rgb = applycform(lab,cform);
end