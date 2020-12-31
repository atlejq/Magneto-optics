clear

%Paths for mean images to make differential RGB image

pathR = 'C:\magnetooptics\RGB\1\'; %R
pathG = 'C:\magnetooptics\RGB\2\'; %G
pathB = 'C:\magnetooptics\RGB\3\'; %B
pathOutput = 'C:\magnetooptics\RGB\'; %Output path

%Sample names

sampleNameR = 'YBCO14_4K'; %R
sampleNameG = 'YBCO14_4K'; %G
sampleNameB = 'YBCO14_4K'; %B

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

    %Generate filenames for R,G,B components for two subsequent images
    
    filename1 = [pathR,sampleNameR,'_',int2str(j-1),'.tif']; 
    filename2 = [pathG,sampleNameG,'_',int2str(j-1),'.tif'];
    filename3 = [pathB,sampleNameB,'_',int2str(j-1),'.tif'];
    
    filename4 = [pathR,sampleNameR,'_',int2str(j),'.tif']; 
    filename5 = [pathG,sampleNameG,'_',int2str(j),'.tif'];
    filename6 = [pathB,sampleNameB,'_',int2str(j),'.tif'];
    
    %Read R, G and B components 
    
    R1 = double(imread(filename1));
    G1 = double(imread(filename2));
    B1 = double(imread(filename3));
    
    R2 = double(imread(filename4));
    G2 = double(imread(filename5));
    B2 = double(imread(filename6));
    
    %Add offset to avoid clipping
    %Multiply to exploit more of the 16 bit array (0-65535)
    
    diffR = offset+(R2-R1)*brightness;
    diffG = offset+(G2-G1)*brightness;
    diffB = offset+(B2-B1)*brightness;
    
    %Region of interest
    
    diffR = diffR(100:880,1:1300);
    diffG = diffG(100:880,1:1300);
    diffB = diffB(100:880,1:1300);
    
    C = zeros(781,1300,3); %Make an 3D-array for the RGB image
    C = uint16(C); %Cast this array to 16 bit unsigned integer
    C(:,:,1) = diffR; %R image at position 1
    C(:,:,2) = diffG; %G image at position 2
    C(:,:,3) = diffB; %B image at position 3
    
    %Show the differential image
    
    imshow(C); 
    
    %Write image to file
    
    filenameOut = [pathOutput,'RGBdiff','_',int2str(j),'.tif'];
    imwrite(C,filenameOut,'tif');
end


