%% Ask

Data = [0 1 0 0 1 1 0 1];
Fs = 100;
F = 4;
sampl_per_bit = 100;

A0 = 0.2;
A1 = 0.9;
%% Modulation
n = 1;
sig_data = zeros(1, numel(Data) * sampl_per_bit);

for i = 1:numel(Data)
    for j = 1:sampl_per_bit 
        if (Data(i) == 0)
            A = A0;
        else
            A = A1;
        end 
        
        sig_data(((i-1)*sampl_per_bit)+j) = A*sin(2*pi*(F/Fs)*n);
        n = n + 1;
    end
end

%% plot Modul sig
figure
plot(sig_data);

%% Demodulation

in_sig = sig_data .^ 2;
alf = 0.125;

filt_out = zeros(1, numel(in_sig));
z1 = 0;

b = fir1(16, 0.01);

f = filter(b,1, in_sig);


for i = 1:numel(in_sig)

filt_out(i) = in_sig(i)*alf + z1 - z1*alf;
z1 = filt_out(i);
end

%% plot deModul sig
figure
plot(filt_out);
hold on;
plot(f);

