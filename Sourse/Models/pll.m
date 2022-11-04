%% pll
close all;



Fs = 100;
F = 4;
n = 1:2*Fs;
in_sig = sin(2*pi*(F/Fs)*n);
 
ref_sig = sin(2*pi*(F/Fs)*n + pi/4);

figure;
plot(in_sig);
hold on;
plot(ref_sig);

%% bpsk modul



Fs = 1600;
F = 80;
n = 1:2*Fs;

phi =  0;

data = [0 1 0 1 0 0 1 1];


ref_sig  = sin(2*pi*(F/Fs)*n + phi);

new_data = ones(1, numel(ref_sig));

tmp = round(numel(ref_sig) / numel(data));

for i = 1:numel(data)
    
    if data(i) == 0 
        new_data(((i-1)*tmp + 1):(i*tmp)) = -1;
    end
end 


data_sig = ref_sig .* new_data;

figure
plot(data_sig);
hold on;
plot(new_data);

%% bpsk demodul


b = fir1(31, 0.02);

res = data_sig .* ref_sig;

fres = filter(b, 1, res);

figure
plot(res);
hold on;
plot(fres);

%%
Fs1 = 13.56 * 10^6;
tab = 0:Fs1-1;
sin_table = sin(2*pi/Fs1*tab);
cos_table = cos(2*pi/Fs1*tab);

step =  1;
const_s = 0;
const_c = 0;
alpha =  0.95;
for i = 1: numel(data_sig)

%sin cos gen 
s = sin_table(step);
c = cos_table(step);
%sin cos mpy
mp_in_s = data_sig(i) * s;
mp_in_c = data_sig(i) * c;
%constant sin
after_dc_s = mp_in_s - const_s;
const_s = after_dc_s * (1-alpha) + const_s;
%constant cos
after_dc_c = mp_in_c - const_c;
const_c = after_dc_c * (1-alpha) + const_c;

CONSTANT =  const_s * const_c;



end