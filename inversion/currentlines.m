clear

m = 4*pi*10^-7; %Mu zero
d = 420*10^-9;  %Thickness of film

filename = 'C:\magnetooptics\inversion\misc\FULL_nbntri26_3_5K_31.mat';

Bzmat = load(filename);   
Bz = Bzmat.FULL;
Bz = Bz(20:995,175:1190); % Crops the MO image
Bz = medfilt2(Bz,[3 3]); %Median filter to remove noise

%Invert Bz to j 

K = make_k(Bz); %Make K-matrix
g = calc_g(Bz/m, K, d); %Calculate g from Hz, K and d
jAbs = calc_jAbsValue(g); %Calculate absolute value of current from g

%Show Bz and |j| maps with current lines

figure(1)
imshow(uint16(Bz)*1.5);

figure(2)
imshow(uint16(jAbs/(1.5*10^12)));
hold on;
contour(g,10,'w');