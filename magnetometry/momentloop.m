clear

a = 0; % First image in branch
b = 50; % Last image in branch
c = 10; % Step size, 1 if every image

m = 4*pi*10^-7; %Mu zero
scale = 194000; %Pixels in image pr meter

%Hysteresis loop: 0 mT -> +21.25 mT -> 0 mT -> -21.25 mT -> 0 mT-> +21.25 mT
field = [a:c:b, (b-(a:c:b)), -(a:c:b), (-b+(a:c:b)), (a:c:b)]*0.425; 

path = 'C:\magnetooptics\magnetometry\';
filename = [path,'misc\sample.mat']; 
samplemat = load(filename); %Loads a binarized optical image of the sample
sample = samplemat.outline;
sample = sample(35:1020,160:1235); %Crops the optical image as the MO image is cropped 
sample = im2double(sample);

filename2 = [path,'misc\DCM.txt']; 
DCM = dlmread(filename2,'\t'); %Loads DCM data for consistency checking

moment = []; %Array for magnetic moment values for the entire hysteresis loop

for branch=1:5 %The hysteresis loop is divided into 5 branches
number = int2str(branch);
path2 = [path,'5K\',number,'\FULL_nbntri26_5K_'];
branch; %Progress indicator
momentbranch = []; %Array for magnetic moment values for branch 
for j=a:c:b
    number=int2str(j);
    filename3 = [path2,number,'.mat'];    
    Bzmat = load(filename3); %Loads MO images
    Bz = Bzmat.FULL;
    Bz = Bz(35:1020,160:1235); %Crops the MO image
    Bz = medfilt2(Bz,[3 3]); %Median filter to remove noise
    Hz = Bz./(1000000.*m); %Divide by 10^6 to get Tesla and divide by mu zero to get H
    momentbranch = [momentbranch, real(calc_moment(Hz,sample))*(1/scale^3)];
end
moment = [moment, momentbranch]; %Appends branch to hysteresis loop
end

figure(1)
plot(field,moment,'r*')
hold on;
plot(DCM(:,1), DCM(:,2)/1000000,'k:','LineWidth',2) %DCM data is in micro-Am^2
xlabel('B_{a} (mT)','FontSize',18,'FontName','Arial')
ylabel('Moment (Am^2)','FontSize',18,'FontName','Arial')
legend('MOI','DCM')
axis([-25 25 -0.00025 0.00025])
