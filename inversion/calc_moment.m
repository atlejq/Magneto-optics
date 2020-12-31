function [ m ] = calc_moment(Hz, sample, K)

    outside = 1 - sample; 
    g = calc_g(Hz, K, 1); %Set sample thickness to 1
    g = g-sum(sum(g.*outside))./sum(sum(outside));
    g = g.*sample;
    m = sum(sum(g));
    
end