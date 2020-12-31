function [ ] = cleanup( p, s, tx, ty, ds, de, output )

    for m = 1:tx
        for n = 1:ty
            for i = ds+1:de+1    
                if(strcmp(output, 'mat'));
                      filename3 = [p,s,'_',int2str(i-1),'_',int2str(m),'_',int2str(n),'.mat'];        
                else
                      filename3 = [p,s,'_',int2str(i-1),'_',int2str(m),'_',int2str(n),'.tif'];
                end
                delete(filename3);
            end
        end
    end

end

