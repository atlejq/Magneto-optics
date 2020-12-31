function [ ] = writerectagle(path1,path2,path3,string2,tx,ty,xi,yi,px,py,ds,de,output,theta,type)

for m = 1:tx;
     for n = 1:ty  
     %Load fit coefficent matrices
     filenameq = [path1,'Q',int2str(m), int2str(n),'.mat'];
     load(filenameq);  
     %Write calibrated images
     for i = ds+1:de+1 %Loop over data images
          MAG = zeros(px,py); %Define B-field image matrix
          filename2 = [path2,string2,'_',int2str(i-1),'.tif']; %Build path 
          I = getImage(filename2,(xi+px*(m-1)):(xi+px*m),(yi+py*(n-1)):(yi+py*n));           
          I = double(I); %Cast raw data intensity image to double
          for j = 1:px+1 %Solve for magnetic field for each pixel j and k
              for k = 1:py+1
                   if(type==0)
                        MAG(j,k) = 1000*real((-Q(j,k,2)+sqrt(Q(j,k,2)*Q(j,k,2)-4*Q(j,k,1)*(Q(j,k,3)-I(j,k))))/(2*Q(j,k,1))); 
                   else 
                        MAG(j,k) = 100*(1/Q(j,k,2))*real(asin(sqrt((I(j,k)-Q(j,k,3))/Q(j,k,1)))-theta);         
                   end
              end
          end
          if(strcmp(output, 'mat'));
              filename3 = [path3,string2,'_',int2str(i-1),'_',int2str(m),'_',int2str(n),'.mat']; %Build path
              save(filename3,'MAG'); %Write B-field rectangle to temp folder                        
          else
              filename3 = [path3,string2,'_',int2str(i-1),'_',int2str(m),'_',int2str(n),'.tif']; %Build path
              MAG = uint16(MAG); %Cast B-field rectangle to 16 bit integer
              imwrite(MAG,filename3,'tif'); %Write B-field rectangle to temp folder
          end
     end
     end
end

