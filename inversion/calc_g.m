function [ g ] = calc_g( Hz, K, d )
    
    Hzfft = fft2(Hz); % Fourier transform
    gfft = Hzfft./sinh(K*d/2); %Find g by Biot-Savart law in Fourier space
    g = real(ifft2(gfft)); 
    
end

