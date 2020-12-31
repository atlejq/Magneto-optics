function [ ] = sigmadebug( B, C, guess, coef, theta )
        col = [rand,rand,rand];
        figure(2);
        hold on;
        plot(B,C,'.','MarkerSize',3,'color',col);
        plot(B,(guess(1)*(((sin(guess(2)*B)+theta).^2))+guess(3)),'*')
        plot(B,(coef(1)*(((sin(coef(2)*B)+theta).^2))+coef(3)),'-','color',col);
        xlabel('B (mT)');
        ylabel('Intensity');
end

