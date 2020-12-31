clear;
p = fix(clock)

path1 = 'C:\magnetooptics\calibration\scal\'; %Calibration images
path2 = 'C:\magnetooptics\calibration\data\'; %Data images
path3 = 'C:\magnetooptics\calibration\full\'; %Magnetic images

string1 = 'nbntri26cal_20K'; %Calibration image name
string2 = 'nbntri26_8K';     %Data image name
output = 'mat';              %Set to 'mat' for double output, otherwise .tif output

ROI = 1;       %Set to 1 to show region of interest as a debug
calibrate = 0; %Fit calibration images 1 = Yes, 0 = No, load saved Q-matrices
write = 1;     %Calculate B-field from Q-matrices and physical images

warning('off','all')

px = 207; %Number of pixels in x-rectangles
py = 463; %Number of pixels in y-rectangles
tx = 5;   %Number of temporary x-rectangles
ty = 3;   %Number of temporary y-rectangles
xi = 1;   %Start at these x-value
yi = 1;   %Start at these x-value

ct = 50;  %Number of calibration images total
cu = 25;  %Number of calibration images used
tc = 10;  %Top calibration current in A
ds = 50;  %Start at data image
de = 50;  %Stop at data image

angle = 0.5;            %Polarizer angle in degrees
theta = angle/(180/pi); %Polarizer angle in radians

%Debug: ROI
if(ROI == 1)
     showROI(path2,string2,de,xi:(xi+tx*px),yi:(yi+ty*py),60,45000)
else
end

%Guess for the fit coeficcients/
guess = [600,0.018,800];

A = zeros(px+1,py+1,cu+1); %Matrix for calibration intensity values
B = zeros(1,cu+1);         %Array for B-field values

%Calibration loop over rectangles
if(calibrate == 1)
    for m = 1:tx;
         for n = 1:ty   
         [n, m] %Show which rectangle we are working on (n = x, m = y)   
              %Read calibration data
              for i = 1:cu+1 %Loop over calibration images
                   filename1 = [path1,string1,'_',int2str((i-1)*ct/cu),'.tif']; %Build calibration image path
                   I = getImage(filename1,(xi+px*(m-1)):(xi+px*m),(yi+py*(n-1)):(yi+py*n)); %Read calibration image
                   A(:,:,i) = I;  %Insert calibration intensity rectangle into matrix
                   B(i) = (i-1)*8.5*tc/cu; %8.5 mT pr A. 10 A/20 images = 0.5 A/image
              end
              %Fit light intensity data to physical sigmoid function
              B = double(B); %Cast B-field array to double
              thetaarray = zeros (1, length(B)); %Trick to fix theta in the fit
              thetaarray(1) = theta; 
              Bt = [B; thetaarray];   %The dependent variables have to be passed as a matrix
              Q = zeros(px+1,py+1,3); %Define matrix for polynomial fit coefficients
              for j = 1:px+1          %Loop over pixels in rectangle (j,k)
                   for k = 1:py+1
                        C(1:cu+1) = A(j,k,:); %Extract light intensity of a single pixel to array
                        C = double(C);        %Cast light intensity to double
                        %Define inline function for nlinfit
                        my_func = inline('beta(1)*(((sin(beta(2)*x(1,:))+x(2,1)).^2))+beta(3)','beta','x');
                        %beta1 = I_0, beta2 = theta_sat/B_a, beta3 = I_leak
                        coef = nlinfit(Bt, C, my_func, guess); %Fit light intensity 
                        Q(j,k,:) = coef; %Move sigmoidal fit coefficients to matrix        
                        %sigmadebug( B, C, guess, coef, theta ) %Debug: I as a function of B, together with the guessed fit
                   end
             end
             %Save fit coefficient matrices for each rectangle
             filenameq = [path1,'Q',int2str(m), int2str(n),'.mat'];
             save(filenameq,'Q');
        end
   end
else
end

if(write == 1)
     writerectagle(path1,path2,path3,string2,tx,ty,xi,yi,px,py,ds,de,output,theta,1)        
     FULL = combine(path3,string2,tx,ty,ds,de,output); %Patch B-rectangles together and write full B-field images
     cleanup(path3,string2,tx,ty,ds,de,output) %Delete temporary rectangles
else
end


figure(3)
imagesc(FULL); %Field values in microtesla*10 can be read off to check calibration
colorbar
caxis([0 4500]);

%Evaluate time spent
q = fix(clock)


