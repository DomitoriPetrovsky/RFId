close all;
%%
close all;

Fs = 60 * 10^6;
M1 = 4;
M2 = 2;

N1 = 63; % >
N2 = 31;

Ast = 90;

Apass = 0.3 ;
Fp = 0.2;% 0.25

fir1 = fdesign.decimator(M1, 'lowpass','N,Fp,Ap,Ast', N1, Fp, Apass, Ast);
%fir2 = fdesign.decimator(M2, 'lowpass','N,Fp,Ap,Ast', N2, Fp*2, Apass, Ast);


fvtool(design(fir1, 'equiripple', 'SystemObject', true));
%fvtool(design(fir2, 'equiripple', 'SystemObject', true));

fir_decim_4 = design(fir1, 'equiripple', 'SystemObject', true);
%fir_decim_2 = design(fir2, 'equiripple', 'SystemObject', true);

coeffs_fir1 = fir_decim_4.coeffs;
%coeffs_fir2 = fir_decim_2.coeffs;
%
%methods
%

%fvtool(Fdes)

coeffs_fir2 = firhalfband(32,0.4);
fvtool(coeffs_fir2);
%%




b = fir1(3*4-1, 0.125/7.3);

b_p = [b(1:4:end); b(2:4:end); b(3:4:end); b(4:4:end)];
b1 = b(1:4:end);
b2 = b(2:4:end);
b3 = b(3:4:end); 
b4 = b(4:4:end);

n = 1:120;
F1 = 20*10^6;
F2 = 1.5*10^6;
Fs = 100*10^6;
x = [1 1 1 1 zeros(1, 116)];
%x = sin(2*pi*(F1/Fs)*n) + sin(2*pi*(F2/Fs)*n);


H = mfilt.firdecim(4, b);
r = zeros(1, 30);

for i = 1:4

    tmp =  x(i:4:end);
    tmp2 = filter(b_p(i, :),1,tmp);
    r = r + [0 tmp2(1:end-1)];
end

filt = filter(b,1,x);
etal_poly = filter(H, x);


figure;
%plot(filt);
hold on;
plot(etal_poly);
plot(r);

