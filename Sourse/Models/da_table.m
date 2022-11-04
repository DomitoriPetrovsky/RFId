%h = [0.125 -0.25 0.0625 -0.5];



%0.0131    0.0252    0.0578    0.1005    0.1399    0.1634    0.1634    0.1399    0.1005    0.0578    0.0252    0.0131
h = [0.0131 0.1399 0.1005];
Wl = 8;
Fl = 7;

%i = 1:2^(numel(h)-1);

%z = zeros(numel(i), numel(h)-1);

%for j = 1:numel(h)-1
    
    %z(:,j) = mod(i, 2^(j));
    
%end

z = [-1 -1 -1 ;...
    -1 -1 1 ;...
    -1 1 -1 ;...
    -1 1 1 ];
     

for i =  1:4
    
    s(i) = sum(z(i,:) .* h);
    
end 

%f_h =  fi(h, 1, 9, 7);

%f_s =  fi(s, 1, 8, 7);

s = s/2;

f_h = fi(h,'WordLength', Wl, ...
             'FractionLength', Fl,...
             'OverflowMode','wrap',...
             'ProductMode','SpecifyPrecision',...
             'ProductWordLength',Wl,...
             'ProductFractionLength',Fl,...
             'SumMode','SpecifyPrecision',...
             'SumWordLength',Wl,...
             'SumFractionLength',Fl);
         
 f_s = fi(s,'WordLength', Wl, ...
             'FractionLength', Fl,...
             'OverflowMode','wrap',...
             'ProductMode','SpecifyPrecision',...
             'ProductWordLength',Wl,...
             'ProductFractionLength',Fl,...
             'SumMode','SpecifyPrecision',...
             'SumWordLength',Wl,...
             'SumFractionLength',Fl);
         

adr = [3 3 3 3 3 3 3 1] ;

%%
tmp(1) = f_s(1);

for i =1:8
    if i == 8
        tmp(i+1) = tmp(i) - f_s(adr(i));
        %tmp(i+1) = bitshift(tmp(i+1), -1);
    else 
        tmp(i+1) = tmp(i) + f_s(adr(i));
        tmp(i+1) = bitshift(tmp(i+1), -1);
    end
end 

