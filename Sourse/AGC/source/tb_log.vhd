library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_log is 
end tb_log;

architecture rtl of tb_log is
	component log_table is 
		generic(
			BITNESS 		: NATURAL;
			TABLE_LENGTH	: NATURAL);
		port(
			adress 		: in	std_logic_vector(TABLE_LENGTH-1 downto 0);
			output_i	: out	std_logic_vector(BITNESS-1 downto 0);
			output_ip	: out	std_logic_vector(BITNESS-1 downto 0));
	end component;


constant table_len : natural := 7; 
constant bitness	: natural := 16;
signal test_1 : std_logic_vector(bitness-1 downto 0);
signal test_2 : std_logic_vector(bitness-1 downto 0);
signal test_adres : std_logic_vector(table_len-1 downto 0);

begin

	process
	begin
		test_adres <= (others => '0');
		wait for 5 ns;
		test_adres <= (others => '1');
		wait for 5 ns;
		test_adres <= "0000001";
		wait for 5 ns;
		test_adres <= "0000100";
		wait for 5 ns;
		test_adres <= "0010000";
		wait for 5 ns;
		test_adres <= "1000000";
		wait for 5 ns;
	end process;


u2: log_table 	generic map(bitness, table_len)
				port map(test_adres, test_1, test_2);

	
end rtl;