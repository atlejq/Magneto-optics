clear;
filename1 = ['C:\magnetooptics\inversion\','N_YBCO14_4K_200.tif']; %No domain
filename2 = ['C:\magnetooptics\inversion\','D_YBCO14_4K_200.tif']; %Domain

Bz = imread(filename1);
Bz = Bz(1:1000,1:1300);
Bz = double(Bz);
Bz = flipud(Bz);
Bz = Bz/(1000*1000); %Scaling from microTesla to Tesla

BzD = imread(filename2);
BzD = BzD(1:1000,1:1300);
BzD = double(BzD);
BzD = flipud(BzD);
BzD = BzD/(1000*1000);

l = 620; %Pixel value at where to take cross section of maps

m = 4*pi*10^-7; %Mu zero
d = 200*10^-9;   %Thickness of film in m

%Invert Bz to j for the first image

% Matlab way of building matrices to generate a k-vector matrix
Bzsize = size(Bz); % Size of B-matrix
Kxgrid = 2*pi*(-floor(Bzsize(1)/2):ceil(Bzsize(1)/2) - 1)/Bzsize(1);
Kygrid = 2*pi*(-floor(Bzsize(2)/2):ceil(Bzsize(2)/2) - 1)/Bzsize(2);
[Kx, Ky] = ndgrid(Kxgrid, Kygrid); %Make 2-dimensional grid
K = sqrt(Kx.^2 + Ky.^2); % Building the actual k-matrix
K = fftshift(K); % Shifting Brillouin zones to get real numbers out
minfin = min(min(K(K>0))); % Artificial removal of singularity at k=0
K(find(K == 0)) = minfin;

Bzfft = fft2(Bz); % Fourier transform
gfft = (1/m)*Bzfft./sinh(K*d/2); %Find g by Biot-Savart law in Fourier space
g = real(ifft2(gfft)); 
jx = padarray(diff(g,1,1), [1 0], 0, 'pre'); % Differentiate g to find currents
jy = -padarray(diff(g,1,2), [0 1], 0, 'pre');
jval = sqrt(jx.^2 + jy.^2); %Find magnitude of the current density
Bz = Bz*1000; %Scale back to millitesla

%Repeat calculation above for the next image using he same K matrix
BzDfft = fft2(BzD); 
gDfft = (1/m)*BzDfft./sinh(K*d/2);
gD = real(ifft2(gDfft)); 
jxD = padarray(diff(gD,1,1), [1 0], 0, 'pre'); 
jyD = -padarray(diff(gD,1,2), [0 1], 0, 'pre');
jvalD = sqrt(jxD.^2 + jyD.^2);
BzD = BzD*1000; %Scale back to millitesla

%Averaged cross sections over Bz and |j| maps
BzPLOT = (Bz(l,:)+Bz(l-1,:)+Bz(l+1,:)+Bz(l-2,:)+Bz(l+2,:))./5;
BzDPLOT = (BzD(l,:)+BzD(l-1,:)+BzD(l+1,:)+BzD(l-2,:)+BzD(l+2,:))./5;
JPLOT = (jval(l,:)+jval(l-1,:)+jval(l+1,:)+jval(l-2,:)+jval(l+2,:))./5;
JDPLOT = (jvalD(l,:)+jvalD(l-1,:)+jvalD(l+1,:)+jvalD(l-2,:)+jvalD(l+2,:))./5;

%Define coordinate system with zero in the middle of the strip
xmax = 580;
xmin = 719;
x = -xmin:1:xmax;

%Scale with 866 pixels corresponding to 1000 micron
scale = 1000/866;
yscale = (scale)*0.001*(x);

%Show Bz and |j| maps with cross sections
figure(1)
imshow(uint16(Bz)*2*1000);
hold on;
plot([0,1300],[l,l],'r-','LineWidth',3);

figure(2)
imshow(uint16(BzD)*2*1000);
hold on;
plot([0,1300],[l,l],'b-','LineWidth',3);

figure(3)
imshow(uint16(jval/(3*10^6)));
hold on;
plot([0,1300],[l,l],'r-','LineWidth',3);

figure(4)
imshow(uint16(jvalD/(3*10^6)));
hold on;
plot([0,1300],[l,l],'b-','LineWidth',3);

%Plot Bz and |j| profiles
figure(5)
plot(yscale,BzPLOT,'r','LineWidth',2);
hold on;
plot(yscale,BzDPLOT,'b','LineWidth',2);
legend('B_z (No domain)', 'B_z (Domain)');
xlabel('x (mm)','FontSize',18,'FontName','Arial');            
ylabel('B_z (mT)','FontSize',18,'FontName','Arial');
axis([-0.8303 0.6697 0 25]);

figure(6)
plot(yscale,JPLOT,'r','LineWidth',2);
hold on;
plot(yscale,JDPLOT,'b','LineWidth',2);
legend('|j| (No domain)', '|j| (Domain)');
xlabel('x (mm)','FontSize',18,'FontName','Arial');            
ylabel('|j| (A/m^2)','FontSize',18,'FontName','Arial');
axis([-0.8303 0.6697 0 1.2*10^11]);




