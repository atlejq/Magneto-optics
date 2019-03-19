clear;
o = clock;

path1 = 'C:\magnetooptics\powercal\cal\';  %Calibration images
path2 = 'C:\magnetooptics\powercal\data\'; %Data images
path3 = 'C:\magnetooptics\powercal\mag\';  %Temporary magnetic images
path4 = 'C:\magnetooptics\powercal\full\'; %Full magnetic images

string1 = 'YBCO14cal_100K'; %Calibration image name
string2 = 'YBCO14_4K';      %Data image name
output = 'tif'; %Set to 'mat' for double output, otherwise .tif output

ROI = 1;       %Set to 1 to show region of interest as a debug
calibrate = 0; %Fit calibration images 1 = Yes, 0 = No, load saved Q-matrices
write = 1;     %Calculate B-field from Q-matrices and physical images

warning('off','all')
a = 207; %Number of pixels in x-rectangles
b = 463; %Number of pixels in y-rectangles
g = 50;  %Number of cal images total
c = 25;  %Number of cal images used
t = 2;   %Top calibration current in A
d = 400; %Start at of data image
h = 400; %Stop at data image
e = 5;   %Number of temporary x-rectangles
f = 3;   %Number of temporary y-rectangles

x = 1; %Start at these x and y values 
y = 1; 

%Debug: ROI
if(ROI == 1)
figure(1)
number0 = int2str(h);
filename0 = [path2,string2,'_',number0,'.tif'];
I = imread(filename0);
I = I(x:(x+e*a),y:(y+f*b))-32768;
imshow(20*I);
else
end

A = zeros(a+1,b+1,c+1); %Matrix for calibration intensity values
B = zeros(1,c+1);       %Array for B-field values

%Calibration loop over rectangles
if(calibrate == 1)
for m = 1:e;
for n = 1:f
    n %Show which rectangle we are working on (n = x, m = y)
    m
    %Read calibration data
    for i = 1:c+1 %Loop over calibration images
      number1 = int2str((i-1)*g/c); %Not all calibration images are used
      filename1 = [path1,string1,'_',number1,'.tif']; %Build calibration image path
      I = imread(filename1); %Read calibration image from path
      I = I((x+a*(m-1)):(x+a*m),(y+b*(n-1)):(y+b*n)); 
      I = (I-32768); %Shift 16 bit image data starting at 32768 to start at zero
      A(:,:,i) = I;  %Insert calibration intensity rectangle into matrix
      B(i) = (i-1)*8.5*t/c; %8.5 mT pr A. 2 A/20 images = 0.1 A/image;
    end
   
    %Fit light intensity data to quadratic function
    B = double(B);        %Cast B-field array to double
    Q = zeros(a+1,b+1,3); %Define matrix for polynomial fit coefficients
    for j = 1:a+1         %Loop over pixels in rectangle (j,k)
        for k = 1:b+1 
        C(1:c+1) = A(j,k,:);   %Extract light intensity of a single pixel to array
        C = double(C);         %Cast light intensity to double
        coef = polyfit(B,C,2); %Fit light intensity 
        Q(j,k,:) = coef;       %Move polynomial fit coefficients to matrix            
        %Debug: I as a function of B
        %figure(2)
        %col = [rand,rand,rand];
        %plot(B,C,'*','MarkerSize',3,'color',col);
        %hold on;
        %plot(B,(coef(3)+coef(2).*B+coef(1).*B.*B),'-','color',col);
        %xlabel('B (mT)');
        %ylabel('Intensity');
        end
    end
    %Save fit coefficient matrices for each rectangle
    numberm = int2str(m);
    numbern = int2str(n);
    filenameq = [path1,'Q',numberm, numbern,'.mat'];
	save(filenameq,'Q');
end
end
else
end

p = clock;

if(write == 1)
for m = 1:e;
for n = 1:f  
    %Load fit coefficent matrices
    numberm = int2str(m);
    numbern = int2str(n);
    filenameq = [path1,'Q',numberm, numbern,'.mat'];
    load(filenameq);  
    %Write calibrated images
       for i = d+1:h+1 %Loop over data images
            MAG = zeros(a,b); %Define B-field image matrix
            number2 = int2str(i-1);
            filename2 = [path2,string2,'_',number2,'.tif']; %Build path 
            I = imread(filename2); %Read raw data intensity image
            I = I((x+a*(m-1)):(x+a*m),(y+b*(n-1)):(y+b*n)); %Select correct rectangle
            I = (I-32768); %Shift 16 bit raw data intensity image to start at zero
            I = double(I); %Cast raw data intensity image to double
            for j = 1:a+1  %Solve for magnetic field for each pixel j and k
            for k = 1:b+1  %The number 1000 below implies B-units of microtesla
            MAG(j,k) = 1000*real((-Q(j,k,2)+sqrt(Q(j,k,2)*Q(j,k,2)-4*Q(j,k,1)*(Q(j,k,3)-I(j,k))))/(2*Q(j,k,1))); 
            end
            end
            if(strcmp(output, 'mat'));
                filename3 = [path3,string2,number2,'_',numberm,'_',numbern,'.mat']; %Build path
                save(filename3,'MAG'); %Write B-field rectangle to temp folder                        
            else
                filename3 = [path3,string2,number2,'_',numberm,'_',numbern,'.tif']; %Build path
                MAG = uint16(MAG); %Cast B-field rectangle to 16 bit integer
                imwrite(MAG,filename3,'tif'); %Write B-field rectangle to temp folder
            end
    end
end
end

%Patch B-rectangles together and write full B-field images
for i = d+1:h+1
    FULL = [];
    for m = 1:e
        FULLY = [];
        for n = 1:f
            number2 = int2str(i-1);
            numberm = int2str(m);
            numbern = int2str(n);
            if(strcmp(output, 'mat'));
                filename4 = [path3,string2,number2,'_',numberm,'_',numbern,'.mat'];
                I = load(filename4); 
                I = I.MAG;
            else
                filename4 = [path3,string2,number2,'_',numberm,'_',numbern,'.tif'];
                I = imread(filename4);
            end               
            FULLY = [FULLY I];
        end
        FULL = [FULL; FULLY];
     end
     if(strcmp(output, 'mat'));
         filename5 = [path4,'FULL_',string2,'_',number2,'.mat'];  
         save(filename5,'FULL');  
     else
         filename5 = [path4,'FULL_',string2,'_',number2,'.tif'];
         imwrite(FULL,filename5,'tif');
     end
end

%Delete temporary rectangles
for m = 1:e
for n = 1:f
for i = d+1:h+1    
            number2 = int2str(i-1);
            numberm = int2str(m);
            numbern = int2str(n);
            if(strcmp(output, 'mat'));
                filename3 = [path3,string2,number2,'_',numberm,'_',numbern,'.mat'];        
            else
                filename3 = [path3,string2,number2,'_',numberm,'_',numbern,'.tif'];
            end
            delete(filename3);
end
end
end
else
end

figure(3)
imagesc(FULL); %Field values in microtesla can be read off to check calibration
colorbar; 
caxis([0 35000]);

%Evaluate time spent
q = clock;

o
p
q
