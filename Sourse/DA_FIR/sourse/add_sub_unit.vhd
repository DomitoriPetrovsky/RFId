
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity add_sub_unit is 
	generic(
		IWL			: NATURAL := 16);
	port(
		add_sub			: in 	std_logic;
		A	 		: in	std_logic_vector(IWL-1 downto 0);		
		B	 		: in	std_logic_vector(IWL-1 downto 0);
		C			: out	std_logic_vector(IWL-1 downto 0));
end add_sub_unit;

architecture rtl of add_sub_unit is

	signal add, sub : signed(IWL-1  downto 0);
	
begin
	
	add <= signed(a) + signed(b);
	sub <= signed(a) - signed(b);
	
	c <= std_logic_vector(add) when add_sub = '0' else std_logic_vector(sub);
	
end rtl;