library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_logic is 
end tb_logic;

architecture rtl of tb_logic is
	component logic is 
	generic(
		BITNESS 		: NATURAL);
	port(
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		out_x	: out	std_logic_vector(BITNESS-1 downto 0);
		out_n	: out	std_logic_vector(4 downto 0));
	end component;



constant bitness	: natural := 16;
signal test : std_logic_vector(bitness-1 downto 0);
signal test_n : std_logic_vector(4 downto 0);
signal test_adres : std_logic_vector(bitness-1 downto 0);

begin

	process
	begin
		test_adres <= (others => '0');
		wait for 5 ns;
		test_adres <= (others => '1');
		wait for 5 ns;
		test_adres <= "0000001010101000";
		wait for 5 ns;
		test_adres <= "0000111110000000";
		wait for 5 ns;
		test_adres <= "0010001000100000";
		wait for 5 ns;
		test_adres <= "1000000010000000";
		wait for 5 ns;
	end process;


u2: logic 	generic map(bitness)
				port map(test_adres, test, test_n);

	
end rtl;