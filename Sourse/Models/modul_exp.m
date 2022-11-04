%% table exp 

%in 0x0804
%gain 0x2c3f4

exp_tab = 2.^(0:1/128:1-1/128);

%fexp_tab = fi(data, 1, WL, FL);
% [-16:1/(2^15):16]
GWL = 20;
GFL = 15;
WL = 16;
FL = 15;
gain = [-16:1/(2^15):(16-1/(2^15))];

%gain(854300) = double(0x2c3f4) / 2^15;
%fgain = fi(gain, 1, GWL, GFL);

%etal = 854300;
etal = 427937;



%data = 2^-3;%
data = double(0x0804) / 2^15;
%gain = gain(etal);
gain = double(0x2c3f4) / 2^15;

fdata = fi(data, 1, WL, FL);
fgain = fi(gain, 1, GWL, GFL);


% 0 1010 000100100011011 положительный


% 1 1101 000011110100000 отрицательный

shift = bitsliceget(fgain, 20 , 16); % получили представление целой части со знаком

if (double(shift) > 15 )
    shift = double(shift) - 32;
end

shift = fi(shift, 1, 5, 0 );

tab_addres = bitsliceget(fgain, 15 , 15-6);

tab_value = exp_tab(uint8(tab_addres)+1);

ftab = fi(tab_value, 1, WL+1, FL);

tab_value = tab_value / 2;

ftab = fi(tab_value, 1, WL, FL);

%fmult = fi(fdata * ftab, 1, WL+FL, FL*2); %работает!!!!
fmult = fi(fdata * ftab, 1, WL*2, FL*2+1);
fmult = bitsll(fmult, 1);

if (double(shift) > 0)
    res = bitsll(fmult, double(shift));
else
    res = bitsrl(fmult, -double(shift));
end

%res = bitsliceget(res, 31, 15 ) ;
ref_res = data * 2^(gain);
disp("fix := ");
disp(res);

disp("float := ");
disp(ref_res);

disp("error rate := ");
disp(abs(double(ref_res-res)));



%%%%%%%% урааааа рботает !!!!!!
%но переполнение не смотрит(((

