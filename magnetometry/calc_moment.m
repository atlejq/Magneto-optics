function [ m ] = calc_moment( Hz , sample )
    outside = 1 - sample;
    g = calc_g(Hz);
    g = g - sum(sum(g .* outside)) ./ sum(sum(outside));
    g = g.*sample;
    m = sum(sum(g));
end

