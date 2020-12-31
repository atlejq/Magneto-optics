function [ jAbsValue ] = calc_jAbsValue( g )
    
    jx = padarray(diff(g,1,1), [1 0], 0, 'pre'); % Differentiate g to find currents
    jy = -padarray(diff(g,1,2), [0 1], 0, 'pre');
    jAbsValue = sqrt(jx.^2 + jy.^2); %Find magnitude of the current density
    
end

