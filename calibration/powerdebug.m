function [ ] = powerdebug( B, C, coef )
        col = [rand,rand,rand];
        figure(2);
        hold on;
        plot(B,C,'*','MarkerSize',3,'color',col);
        plot(B,(coef(3)+coef(2).*B+coef(1).*B.*B),'-','color',col);
        xlabel('B (mT)');
        ylabel('Intensity');
end

