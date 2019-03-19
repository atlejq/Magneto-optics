clear

m=4*pi*10^-7; %Mu zero
d=420*10^-9;   %Thickness of film

filename = 'C:\magnetooptics\magnetometry\misc\FULL_nbntri26_3_5K_31.mat';

Bzmat = load(filename);   
Bz = Bzmat.FULL;
Bz = Bz(20:995,175:1190); % Crops the MO image
Bz = medfilt2(Bz,[3 3]); %Median filter to remove noise

%Invert Bz to j 

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

%Show Bz and |j| maps with current lines
figure(1)
imshow(uint16(Bz)*1.5);

figure(2)
imshow(uint16(jval/(1.5*10^12)));
hold on;
contour(g,10,'w');
