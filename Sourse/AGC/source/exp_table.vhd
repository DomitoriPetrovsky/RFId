library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;


entity exp_table is 
	generic(
		BITNESS 		: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		adress 	: in	std_logic_vector(TABLE_LENGTH-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1 downto 0));
end exp_table;

architecture rtl of exp_table is

	signal exp_table : return_data(0 to 2**TABLE_LENGTH-1) := formation_exp_table(TABLE_LENGTH);

begin

u1:	process(adress)
	begin
	
		output <= exp_table(natural(to_integer(unsigned(adress))));
	end process;

	
end rtl;