function [ kx ky k ] = make_k( xlen, ylen )
    halfx = xlen / 2;
    halfy = ylen / 2;
    [kx ky] = meshgrid(pi.*(-halfx:(halfx-1))/(halfx), pi.*(-halfy:(halfy-1))/(halfy)); 
    kx = fftshift(kx);
    ky = fftshift(ky);
    k = sqrt(kx.^2+ky.^2);
    k(1,1) = 1e6;
end
