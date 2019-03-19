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
jyslab0 = zeros(1,o);
jyslab1 = jc*ones(1,w-a);
jyslabm = zeros(1,2*a);
jyslab3 = -jyslab1;
jyslab4 = jyslab0;
jyslab = [jyslab0 jyslab1 jyslabm jyslab3 jyslab4];

%Plot jy_slab vs x
x = 1:1:length(jyslab);
x = x-(o+w);
xscale = x/s;
figure(1);
plot(xscale,jyslab,'k','LineWidth',2);
hold on;
axis([-1.5 1.5 -1.2 1.2])
xlabel('x','FontSize',18,'FontName','Arial');            
ylabel('j_y/j_c','FontSize',18,'FontName','Arial');

%Build the magnetic field distribution in a slab
Bzslab0 = Bas*ones(1,o);
Bzslab1 = Bas-jc*(1:1:(w-a))*Bs/w;
Bzslabm = zeros(1,2*a);
Bzslab3 = flip(Bzslab1);
Bzslab4 = Bzslab0;
Bzslab = [Bzslab0 Bzslab1 Bzslabm Bzslab3 Bzslab4]/Bs;

%Plot Bz_slab vs x
figure(2);
x = 1:1:length(Bzslab);
x = x-(o+w);
xscale = x/s;
plot(xscale, Bzslab,'k','LineWidth',2);
hold on;
axis([-1.5 1.5 0 1.2])
xlabel('x','FontSize',18,'FontName','Arial');            
ylabel('B_z/B_s','FontSize',18,'FontName','Arial');

%Calculations for a thin film

a = w/cosh(Baf/Bf); %Field-free depth for a thin film
a = round(a);       %Round value for use in arrays

%Build the current distribution in a thin film
jyfilm0 = zeros(1,o);
jyfilm1 = jc*ones(1,w-a);
jyfilmm = -(2*jc/pi).*atan(((-a:1:a)/w).*(sqrt(w^2-a^2)./sqrt(a.^2-(-a:1:a).^2)));
jyfilm3 = -jyfilm1;
jyfilm4 = jyfilm0;
jyfilm = [jyfilm0 jyfilm1 jyfilmm jyfilm3 jyfilm4];

%Plot jy_film vs x
figure(3);
x = 1:1:length(jyfilm);
x = x-(o+w);
xscale = x/s;
plot(xscale, jyfilm,'k','LineWidth',2);
hold on;
axis([-1.5 1.5 -1.2 1.2])
xlabel('x','FontSize',18,'FontName','Arial');            
ylabel('j_y/j_c','FontSize',18,'FontName','Arial');

%Build the magnetic field distribution in a thin film
x = a:1:(o+w);
x = flip(x);
Bzfilm0 = Bf*log((abs(x).*sqrt(w^2-a^2)+w*(sqrt(x.^2-a^2)))./(a*sqrt(abs(x.^2-w^2))));
Bzfilmm = zeros(1,2*a);
Bzfilm2 = flip(Bzfilm0);
Bzfilm = [Bzfilm0 Bzfilmm Bzfilm2]/Bf; %Normalize to Bf

%Plot Bz_film vs x
figure(4);
x = 1:1:length(Bzfilm);
x = x-(o+w);
xscale = x/s;
plot(xscale, Bzfilm,'k','LineWidth',2);
hold on;
axis([-1.5 1.5 0 5])
xlabel('x','FontSize',18,'FontName','Arial');            
ylabel('B_z/B_f','FontSize',18,'FontName','Arial');
