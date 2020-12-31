clear

%Paths for mean images to make ordinary RGB image

pathR = 'C:\magnetooptics\RGB\1\'; %R
pathG = 'C:\magnetooptics\RGB\2\'; %G
pathB = 'C:\magnetooptics\RGB\3\'; %B
pathOutput = 'C:\magnetooptics\RGB\'; %Output path

%Sample names

sampleNameR = 'YBCO14_4K'; %R
sampleNameG = 'YBCO14_4K'; %G
sampleNameB = 'YBCO14_4K'; %B

a = 400; %Start at image
b = 400; %End at image
c = 1;   %Step length, 1 means make every image, 50 means every 50th etc

brightness = 2; %Multiplication factor for adjusting brightness

for j = a:c:b  
    
  %Generate filenames for R,G,B components 
  
  filename1 = [pathR,sampleNameR,'_',int2str(j),'.tif']; 
  filename2 = [pathG,sampleNameG,'_',int2str(j),'.tif'];
  filename3 = [pathB,sampleNameB,'_',int2str(j),'.tif'];
    
  %Read R, G and B components into uint16 arrays 
  
  R = uint16(imread(filename1));
  G = uint16(imread(filename2));
  B = uint16(imread(filename3));
   
  %Multiply to exploit more of the 16 bit array (0-65535)
  %You may want to run this code at individual steps and customize the
  %brightness number to images with uniform brightness
  
  R = R*brightness;
  G = G*brightness;
  B = B*brightness;
  
  %Region of interest
  
  R = R(100:880,1:1300);
  G = G(100:880,1:1300);
  B = B(100:880,1:1300);
     
  C = zeros(781,1300,3); %Make an 3D-array for the RGB image
  C = uint16(C); %Cast this array to 16 bit unsigned integer
  C(:,:,1) = R; %R image at position 1
  C(:,:,2) = G; %G image at position 2
  C(:,:,3) = B; %B image at position 3
    
  %Show the image
  
  imshow(C); 
  
  %Write image to file
  
  filenameOut = [pathOutput,'RGBord','_',int2str(j),'.tif'];
  imwrite(C,filenameOut,'tif');
end


