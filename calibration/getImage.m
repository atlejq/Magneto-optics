function [ I ] = getImage( filename2, x, y )

    I = imread(filename2); %Read raw data image
    I = I(x,y); %Select correct rectangle
    I = (I-32768); %Shift 16 bit raw data image to start at zero

end

