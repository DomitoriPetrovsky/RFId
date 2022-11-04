%% quad sig gen
%input 

Fs = 100;
F = 14;
n = 1:1000;
sin_theta = sin(2*pi*(F/Fs)*n);
%sin_theta = zeros(1, numel(n));
cos_theta = cos(2*pi*(F/Fs)*n);
%cos_theta = zeros(1, numel(n));

%% plot iput
figure 
plot(cos_theta);
hold on;
plot(sin_theta);

%% generator 
Ft = 14;
theta = 2*pi*Ft/Fs;

in_sin = sin(theta);%sin_theta;
in_cos = cos(theta);%cos_theta;


yi = zeros(1, numel(n)); % синфазная составляющая 
yq = zeros(1, numel(n)); % квадратурная составляющая

yi_delay = 1;
yq_delay = 0;
 
for i = 1 : numel(n)
   
    sin_mpy_di = in_sin * yi_delay;
    sin_mpy_dq = in_sin * yq_delay;
    
    cos_mpy_di = in_cos * yi_delay;
    cos_mpy_dq = in_cos * yq_delay;
    
    yi_1 = cos_mpy_di - sin_mpy_dq;
    yq_1 = cos_mpy_di + sin_mpy_dq;
    
    G = 1.5 - (yi_1^2 + yq_1^2);
    
    yi(i) = yi_1 * G;
    yq(i) = yq_1 * G;
    
    yi_delay = yi(i);
    yq_delay = yq(i);
    
 
end


%% plot signal
figure 
plot(yi+yq);

figure
plot(yi);
hold on;
plot(yq);



