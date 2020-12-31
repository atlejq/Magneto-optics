clear;

filename1 = ['C:\magnetooptics\inversion\misc\','N_YBCO14_4K_200.tif']; %No domain
filename2 = ['C:\magnetooptics\inversion\misc\','D_YBCO14_4K_200.tif']; %Domain

BzN = imread(filename1);
BzN = flipud(double(BzN(1:1000,1:1300)));

BzD = imread(filename2);
BzD = flipud(double(BzD(1:1000,1:1300)));

%Define coordinate system with zero in the middle of the strip

xmax = 580;
xmin = 719;
x = -xmin:1:xmax;

%Scale with 866 pixels corresponding to 1000 micron

scale = 1000/866;
yscale = (scale)*0.001*(x);

l = 620; %Pixel value at where to take cross section of maps
m = 4*pi*10^-7; %Mu zero
d = 200*10^-9;  %Thickness of film in m

%Invert Bz to j for the images

K = make_k(BzN); %Make K-matrix
gN = calc_g(BzN/m, K, d); %Calculate g from Hz, K and d
jAbsN = calc_jAbsValue(gN); %Calculate absolute value of current from g

gD = calc_g(BzD/m, K, d);
jAbsD = calc_jAbsValue(gD);

%Averaged cross sections over Bz and |j| maps

BzPLOT = (BzN(l,:)+BzN(l-1,:)+BzN(l+1,:)+BzN(l-2,:)+BzN(l+2,:))./5;
BzDPLOT = (BzD(l,:)+BzD(l-1,:)+BzD(l+1,:)+BzD(l-2,:)+BzD(l+2,:))./5;
JPLOT = (jAbsN(l,:)+jAbsN(l-1,:)+jAbsN(l+1,:)+jAbsN(l-2,:)+jAbsN(l+2,:))./5;
JDPLOT = (jAbsD(l,:)+jAbsD(l-1,:)+jAbsD(l+1,:)+jAbsD(l-2,:)+jAbsD(l+2,:))./5;

%Show Bz and |j| maps with cross sections

figure(1)
imshow(uint16(BzN)*2);
hold on;
plot([0,1300],[l,l],'r-','LineWidth',3);

figure(2)
imshow(uint16(BzD)*2);
hold on;
plot([0,1300],[l,l],'b-','LineWidth',3);

figure(3)
imshow(uint16(jAbsN/(3*10^12)));
hold on;
plot([0,1300],[l,l],'r-','LineWidth',3);

figure(4)
imshow(uint16(jAbsD/(3*10^12)));
hold on;
plot([0,1300],[l,l],'b-','LineWidth',3);

%Plot Bz and |j| profiles

figure(5)
hold on;
plot(yscale,BzPLOT/10^3,'r','LineWidth',2);
plot(yscale,BzDPLOT/10^3,'b','LineWidth',2);
legend('B_z (No domain)', 'B_z (Domain)');
xlabel('x (mm)','FontSize',18,'FontName','Arial');            
ylabel('B_z (mT)','FontSize',18,'FontName','Arial');
axis([-0.8303 0.6697 0 25]);

figure(6)
hold on;
plot(yscale,JPLOT/10^6,'r','LineWidth',2);
plot(yscale,JDPLOT/10^6,'b','LineWidth',2);
legend('|j| (No domain)', '|j| (Domain)');
xlabel('x (mm)','FontSize',18,'FontName','Arial');            
ylabel('|j| (A/m^2)','FontSize',18,'FontName','Arial');
axis([-0.8303 0.6697 0 1.2*10^11]);