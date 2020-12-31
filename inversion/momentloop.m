clear

f = 0;  %First image in branch
l = 50; %Last image in branch
s = 10; %Step size, 1 if every image

m = 4*pi*10^-7; %Mu zero
scale = 194000; %Pixels in image pr meter

%Hysteresis loop: 0 mT -> +21.25 mT -> 0 mT -> -21.25 mT -> 0 mT-> +21.25 mT
field = [f:s:l, (l-(f:s:l)), -(f:s:l), (-l+(f:s:l)), (f:s:l)]*0.425; 

path = 'C:\magnetooptics\inversion\';
filename = [path,'misc\sample.mat']; 
sampleMatrix = load(filename); %Loads a binarized optical image of the sample
sample = sampleMatrix.outline;
sample = im2double(sample(35:1020,160:1235)); %Crops the optical image as the MO image is cropped, casts to double 

filename2 = [path,'misc\DCM.txt']; 
DCM = dlmread(filename2,'\t'); %Loads DCM data for consistency checking

momentLoop = []; %Array for magnetic moment values for the entire hysteresis loop

K = make_k(sample);

for b=1:5 %The hysteresis loop is divided into 5 branches    
    path2 = [path,'5K\',int2str(b),'\FULL_nbntri26_5K_'];
    momentBranch = []; %Array for magnetic moment values for branch  
    for j=f:s:l       
         filename3 = [path2,int2str(j),'.mat'];    
         Bzmat = load(filename3); %Loads MO images
         Bz = Bzmat.FULL;
         Bz = Bz(35:1020,160:1235); %Crops the MO image
         Bz = medfilt2(Bz,[3 3]); %Median filter to remove noise
         momentBranch = [momentBranch, real(calc_moment(Bz./m, sample, K))*(1/scale^3)];         
    end    
    momentLoop = [momentLoop, momentBranch]; %Appends branch to hysteresis loop
end

figure(1)
hold on;
plot(field,momentLoop/10^6,'r*') %Convert to Tesla
plot(DCM(:,1), DCM(:,2)/10^6,'k:','LineWidth',2) %DCM data is in micro-Am^2
xlabel('B_{a} (mT)','FontSize',18,'FontName','Arial')
ylabel('Moment (Am^2)','FontSize',18,'FontName','Arial')
legend('MOI','DCM')
axis([-25 25 -0.00025 0.00025])