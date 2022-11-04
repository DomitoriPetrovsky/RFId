library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;



entity sin_gen_channel_test is 
	generic(
		OWL	 	: NATURAL;
		F		: NATURAL;
		FS		: NATURAL;
		DL		: NATURAl;
		data_bit_len	: NATURAl;
		A1		: real;
		A0		: real;
		
		CONST_VALUE : REAL;
		PEAK_f		: NATURAL);
	port(
		clk		: in	std_logic;
		DATA	: in	std_logic_vector(DL-1 downto 0);
		output	: out	std_logic_vector(OWL-1 downto 0));
end sin_gen_channel_test;

architecture rtl of sin_gen_channel_test is

 constant pi : real := real(3.14);
 signal temp_out : std_logic_vector(OWL-1 downto 0) := (others => '0');

begin
	
	
gen:	process(clk)
		variable N : NATURAL := 0;
		variable s : real := real(0);
		variable A : real := real(0.5);
		variable count : NATURAL := 0;
		variable i :  NATURAL := 0;
		variable peak_count : NATURAL := 0;
		begin

			if(rising_edge(clk)) then
				if (DATA(i) = '0') then
					A := A0;
				else
					A := A1;
				end if;
				
				if (count = data_bit_len-1) then 
					count := 0;
					if (i = DL-1) then 
						i := 0;
					else 
						i := i + 1;
					end if;
				else 
					count := count + 1;
				end if;
				s := CONST_VALUE + A * sin((real(2)*pi*real(F)*real(N))/real(FS)); 
				N := N + 1;
				
				if peak_count = PEAK_f + 1 then 
					s := real(0.9);
					peak_count := 0;
				end if;
				
				if PEAK_f /= 0 then 
					peak_count := peak_count + 1;
				end if;
					
				
				s := round(s*real(2**(OWL-1)));
				
				temp_out <= std_logic_vector(to_signed(integer(s), OWL));
				
			end if;
		end process;
	
	
	output <= temp_out;
	
end rtl;