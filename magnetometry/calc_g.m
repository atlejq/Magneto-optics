function [ g ] = calc_g( Hz )
    %% Calculates the magnetization from the magnetic field up to a constant value
    [kx, ky, k] = make_k(size(Hz,2), size(Hz,1));
    Hz_fft = fft2(Hz);
    g_fft = Hz_fft .* (2 ./ k);
    g = ifft2(g_fft);
end

