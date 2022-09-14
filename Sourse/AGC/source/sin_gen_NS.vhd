library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_log_func.all;


entity sin_gen_NS is 
	generic(
		BITNESS : NATURAL;
		F		: NATURAL;
		FS		: NATURAL);
	port(
		clk		: in	std_logic;
		output	: out	std_logic_vector(BITNESS-1 downto 0));
end sin_gen_NS;

architecture rtl of sin_gen_NS is

 constant pi : real := real(3.14);
 signal temp_out : std_logic_vector(BITNESS-1 downto 0) := (others => '0');

begin
	
	
gen:	process(clk)
		variable N : real := real(0);
		variable s : real := real(0);
		variable A : real := real(0.5);
		variable timer : real := real(0);
		constant cs : real := real(FS)*real(4);
		variable step : real := real(0.4);
		begin

			if(rising_edge(clk)) then
				
				if timer = cs then 
					timer := real(0);
					A := A + step;
					if A <= real(0)  then 
						A := A + real(0.5);
						step := step * real(-1);
					elsif A >= real(1) then 	
						A := A - real(0.5);
						step := step * real(-1);
					end if;
				end if;
			
			
				s := A * sin((real(2)*pi*real(F)*N)/real(FS)); 
				N := N + real(1);
				s := s*real(2**(BITNESS-1));
				timer := timer + real(1);
				temp_out <= std_logic_vector(to_signed(integer(s), BITNESS));
			end if;
		end process;
	
	
	output <= temp_out;
	
end rtl;