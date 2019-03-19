clear

%Paths for mean images to make differential RGB image
pathr = 'C:\magnetooptics\RGB\1\'; %R
pathg = 'C:\magnetooptics\RGB\2\'; %G
pathb = 'C:\magnetooptics\RGB\3\'; %B
pathd = 'C:\magnetooptics\RGB\'; %Output path

%Sample names
samplenamer = 'YBCO14_4K'; %R
samplenameg = 'YBCO14_4K'; %G
samplenameb = 'YBCO14_4K'; %B

offset = 500; %Offset to avoid clipping 

a = 400; %Start at image
b = 400; %End at image
c = 1;   %Step length, 1 means make every image, 50 means every 50th etc

brightness = 20; %Multiplication factor for adjusting brightness

for j = a:c:b
    
    %RGB images are made from three uint16 arrays.
    R1 = uint16(0);
    G1 = uint16(0);
    B1 = uint16(0);
    
    R2 = uint16(0);
    G2 = uint16(0);
    B2 = uint16(0);
    
    %Convert loop number to string 
    number1 = int2str(j-1);
    number2 = int2str(j);

    %Generate filenames for R,G,B components for two subsequent images
    filename1 = [pathr,samplenamer,'_',number1,'.tif']; 
    filename2 = [pathg,samplenameg,'_',number1,'.tif'];
    filename3 = [pathb,samplenameb,'_',number1,'.tif'];
    
    filename4 = [pathr,samplenamer,'_',number2,'.tif']; 
    filename5 = [pathg,samplenameg,'_',number2,'.tif'];
    filename6 = [pathb,samplenameb,'_',number2,'.tif'];
    
    %Read R,G,B components 
    R1 = double(imread(filename1));
    G1 = double(imread(filename2));
    B1 = double(imread(filename3));
    
    R2 = double(imread(filename4));
    G2 = double(imread(filename5));
    B2 = double(imread(filename6));
    
    %Add offset to avoid clipping
    %Multiply to exploit more of the 16 bit array (0-65535)
    DIFFR = offset+(R2-R1)*brightness;
    DIFFG = offset+(G2-G1)*brightness;
    DIFFB = offset+(B2-B1)*brightness;
    
    %Region of interest
    DIFFR = DIFFR(100:880,1:1300);
    DIFFG = DIFFG(100:880,1:1300);
    DIFFB = DIFFB(100:880,1:1300);
    
    C = zeros(781,1300,3); %Make an 3D-array for the RGB image
    C = uint16(C); %Cast this array to 16 bit unsigned integer
    C(:,:,1) = DIFFR; %R image at position 1
    C(:,:,2) = DIFFG; %G image at position 2
    C(:,:,3) = DIFFB; %B image at position 3
    
    %Show the differential image
    imshow(C); 
    %Write image to file
    filename4 = [pathd,'RGBdiff','_',number2,'.tif'];
    imwrite(C,filename4,'tif');
end


