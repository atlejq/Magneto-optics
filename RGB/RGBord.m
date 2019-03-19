clear

%Paths for mean images to make ordinary RGB image
pathr = 'C:\magnetooptics\RGB\1\'; %R
pathg = 'C:\magnetooptics\RGB\2\'; %G
pathb = 'C:\magnetooptics\RGB\3\'; %B
pathd = 'C:\magnetooptics\RGB\'; %Output path

%Sample names
samplenamer = 'YBCO14_4K'; %R
samplenameg = 'YBCO14_4K'; %G
samplenameb = 'YBCO14_4K'; %B

a = 400; %Start at image
b = 400; %End at image
c = 1;   %Step length, 1 means make every image, 50 means every 50th etc

brightness = 2; %Multiplication factor for adjusting brightness

for j = a:c:b
    
  %RGB images are made from three uint16 arrays.
  R = uint16(0);
  G = uint16(0);
  B = uint16(0);
    
  %Convert loop number to string 
  number = int2str(j);
    
  %Generate filenames for R,G,B components 
  filename1 = [pathr,samplenamer,'_',number,'.tif']; 
  filename2 = [pathg,samplenameg,'_',number,'.tif'];
  filename3 = [pathb,samplenameb,'_',number,'.tif'];
    
  %Read R,G,B component 
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
  filename4 = [pathd,'RGBord','_',number,'.tif'];
  imwrite(C,filename4,'tif');
end


