%% automatic gain control 
close all;
clear;
%input signal

F = 2;
%A = [1 0.7 0.4 0.6];

A = [0.3 0.5 0.9 0.4];

%A = A * 0.2;

Fs = 100;
n = [6 4 7 10];

x = 0;
for i = 1:numel(n) 
    x = [x A(i)*sin(2*pi*F*(0:1/Fs:n(i)))];
end

%plot(x);

%% AGC simple
R = 0.487;
a = 0.125;
y = zeros(1, numel(x));
temp = zeros(1, numel(x));

%for j = 0:100000000

    
    
for i = 1:numel(x)
   
y(i) = temp(i) * x(i);

temp(i+1) = temp(i) + a*(R-y(i)^2);
    
    
end

    %if max(y) <= 1
        
      % break; 
        
    %end
    %R = R - 0.001;

%end
%figure;
%plot(y);
%title('Standart AGC')


%% AGC log
x(1:2) = x(3);
R = 0.487;
logR = log2(R);
a = 0.125;
temp = 0.001;


alf = 2^(-3);
z1 = 0;
filt_out = 0;

yl = zeros(1, numel(x));




for i = 1:numel(x)
   
yl(i) = 2^temp * x(i);

filt_out = (yl(i)^2)*alf + z1 - z1*alf;
z1 = filt_out;


temp = temp + a * (logR - log2(filt_out));
    
    
end


%plot(yl);
%title('Log AGC');
%% filter 
z1 = 0;
filt_out = 0;

xf = [0 0 0 1 zeros(1, 100)];
yf = zeros(1, numel(xf));
for i = 1: numel(xf)
    
yf(i) = (xf(i)^2)*alf + z1 - z1*alf;
z1 = yf(i);


end 

%% table logarifm



 

xlabel("Время в отсчетах)");



%% Graphs



close all;
figure;
%subplot(2, 1, 1);
plot(x);
%subplot(2, 1, 2);
figure;

hold on;
plot(y, 'blue');
plot(yl, 'red');

legend('Standart AGC', 'Log AGC');






