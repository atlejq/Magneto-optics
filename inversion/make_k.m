function [ K ] = make_k( Bz )
    
    Bzsize = size(Bz); % Size of B-matrix
    Kxgrid = 2*pi*(-floor(Bzsize(1)/2):ceil(Bzsize(1)/2) - 1)/Bzsize(1);
    Kygrid = 2*pi*(-floor(Bzsize(2)/2):ceil(Bzsize(2)/2) - 1)/Bzsize(2);
    [Kx, Ky] = ndgrid(Kxgrid, Kygrid); %Make 2-dimensional grid
    K = sqrt(Kx.^2 + Ky.^2); % Building the actual k-matrix
    K = fftshift(K); % Shifting Brillouin zones to get real numbers out
    minfin = min(min(K(K>0))); % Artificial removal of singularity at k=0
    K(find(K==0)) = minfin;
    
end