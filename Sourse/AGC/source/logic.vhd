library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_log_func.all;


entity logic is 
	generic(
		BITNESS 		: NATURAL);
	port(
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		out_x	: out	std_logic_vector(BITNESS-1 downto 0);
		out_n	: out	std_logic_vector(4 downto 0));
end logic;

architecture rtl of logic is
signal n :  signed(out_n'length-1 downto 0);
signal x :	std_logic_vector(BITNESS-1 downto 0);
	
begin

u1:	process(input)
	
	variable zeros	: signed(out_n'length-1 downto 0);
	variable shift	: std_logic_vector(BITNESS-1 downto 0);
	variable flag	: std_logic;
	
	begin
		zeros := (others => '0');
		flag := '0';
		shift := input;
		
		for I in BITNESS-1 downto 0 loop
			--if input(I) = '0' then
			if flag = '0' then
				if input(I) = '0' then
					zeros := zeros - 1;
					shift := shift(BITNESS-2 downto 0) & '0';
				else
					flag := '1';
				end if;
			end if;
		end loop;
	
		
		n <= zeros;
		x <= shift;
	
	end process;
	
	
	out_n <= std_logic_vector(n);
	out_x <= x;
	
end rtl;