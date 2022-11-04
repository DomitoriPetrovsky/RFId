

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;

entity ROM is 
	generic(
		DATA		: one_dim_array_of_stdv;
		DWL			: NATURAL;
		AWL			: NATURAL);
	port(
		adress 		: in	std_logic_vector(AWL-1 downto 0);
		data_out	: out	std_logic_vector(DWL-1 downto 0));
end ROM;

architecture rtl of ROM is

	type da_rom is array (2**AWL-1 downto 0) of std_logic_vector(DWL-1 downto 0);
	
	constant content : one_dim_array_of_stdv(2**AWL-1 downto 0)(DWL-1 downto 0) := DATA;
	
	
begin
			data_out <=  content(NATURAL(to_integer(unsigned(adress))));
end rtl;