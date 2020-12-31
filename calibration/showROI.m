function [ ] = showROI( path2, string2, de, mx, my, scaling, offset )

    figure(1)
    filename0 = [path2,string2,'_',int2str(de),'.tif'];
    I = getImage(filename0,mx,my);
    imshow(scaling*I - offset);

end

