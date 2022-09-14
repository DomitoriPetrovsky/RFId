library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;


entity log_table is 
	generic(
		BITNESS 		: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		adress 	: in	std_logic_vector(TABLE_LENGTH-1 downto 0);
		output_i	: out	std_logic_vector(BITNESS-1 downto 0);
		output_ip	: out	std_logic_vector(BITNESS-1 downto 0));
end log_table;

architecture rtl of log_table is

	--type type_table is array (natural range <>) of std_logic_vector(BITNESS-1 downto 0);
	
	signal log_table : return_data(0 to 2**TABLE_LENGTH-1) := formation_log_table(TABLE_LENGTH);

begin

u1:	process(adress)
	begin
	
		output_i <= log_table(natural(to_integer(unsigned(adress))));
		output_ip <= log_table(natural(to_integer(unsigned(adress) + 1)));
	end process;

	
end rtl;