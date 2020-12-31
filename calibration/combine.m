function [ FULL ] = combine( p, s, e, f, d, h, output )

    for i = d+1:h+1
        FULL = [];
        for m = 1:e
            FULLY = [];
            for n = 1:f
                if(strcmp(output, 'mat'));
                   filenameInput = [p,s,'_',int2str(i-1),'_',int2str(m),'_',int2str(n),'.mat'];
                   I = load(filenameInput); 
                   I = I.MAG;
                else
                   filenameInput = [p,s,'_',int2str(i-1),'_',int2str(m),'_',int2str(n),'.tif'];
                   I = imread(filenameInput);
                end               
                FULLY = [FULLY I];
            end
            FULL = [FULL; FULLY];
        end
        if(strcmp(output, 'mat'));
            filenameOutput = [p,'FULL_',s,'_',int2str(i-1),'.mat'];  
            save(filenameOutput,'FULL');  
        else
            filenameOutput = [p,'FULL_',s,'_',int2str(i-1),'.tif'];
            imwrite(FULL,filenameOutput,'tif');
        end
    end

end

