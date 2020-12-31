clear;

jc = 1;    %Magnitude of critical current
w = 1;     %Half-width of sample 
o = 0.5;   %Length outside of sample 
Bas = 1;   %Applied field for slab
Baf = 1;   %Applied field for thin film
Bs = 1;    %Characteristic field for slab
Bf = 1;    %Characteristic field for a thin film
s = 1000;  %Scale used when calculating in arrays

w = w*s;
o = o*s;

%Calculations for a slab

a = w*(1-Bas/Bs); %Field-free depth for slab
a = round(a);     %Round value for use in arrays

%Build the current distribution in a slab

jySlabOutside = zeros(1,o);
jySlabInside = jc*ones(1,w-a);
jySlabMiddle = zeros(1,2*a);
jySlab = [jySlabOutside jySlabInside jySlabMiddle -jySlabInside jySlabOutside];

%Plot jy_slab vs x

x = 1:1:length(jySlab);
x = x-(o+w);
xScale = x/s;

figure(1);
hold on;
plot(xScale,jySlab,'k','LineWidth',2);
axis([-1.5 1.5 -1.2 1.2])
xlabel('x','FontSize',18,'FontName','Arial');            
ylabel('j_y/j_c','FontSize',18,'FontName','Arial');

%Build the magnetic field distribution in a slab

BzslabOutside = Bas*ones(1,o);
BzslabInside = Bas-jc*(1:1:(w-a))*Bs/w;
BzslabMiddle = zeros(1,2*a);
BzSlab = [BzslabOutside BzslabInside BzslabMiddle flip(BzslabInside) BzslabOutside]/Bs;  %Normalize to Bs

%Plot Bz_slab vs x

figure(2);
hold on;
plot(xScale, BzSlab,'k','LineWidth',2);
axis([-1.5 1.5 0 1.2])
xlabel('x','FontSize',18,'FontName','Arial');            
ylabel('B_z/B_s','FontSize',18,'FontName','Arial');

%Calculations for a thin film

a = w/cosh(Baf/Bf); %Field-free depth for a thin film
a = round(a);       %Round value for use in arrays

%Build the current distribution in a thin film

jyFilmOutside = zeros(1,o);
jyFilmInside = jc*ones(1,w-a);
jyFilmMiddle = -(2*jc/pi).*atan(((-a:1:a-1)/w).*(sqrt(w^2-a^2)./sqrt(a.^2-(-a:1:a-1).^2)));
jyFilm = [jyFilmOutside jyFilmInside jyFilmMiddle -jyFilmInside jyFilmOutside];

%Plot jy_film vs x

figure(3);
hold on;
plot(xScale, jyFilm,'k','LineWidth',2);
axis([-1.5 1.5 -1.2 1.2])
xlabel('x','FontSize',18,'FontName','Arial');            
ylabel('j_y/j_c','FontSize',18,'FontName','Arial');

%Build the magnetic field distribution in a thin film

x = a:1:(o+w);
x = flip(x);
BzFilmOutside = Bf*log((abs(x).*sqrt(w^2-a^2)+w*(sqrt(x.^2-a^2)))./(a*sqrt(abs(x.^2-w^2))));
BzFilmMiddle = zeros(1,2*a-2);
BzFilm = [BzFilmOutside BzFilmMiddle flip(BzFilmOutside)]/Bf; %Normalize to Bf

%Plot Bz_film vs x

figure(4);
hold on;
plot(xScale, BzFilm,'k','LineWidth',2);
axis([-1.5 1.5 0 5])
xlabel('x','FontSize',18,'FontName','Arial');            
ylabel('B_z/B_f','FontSize',18,'FontName','Arial');