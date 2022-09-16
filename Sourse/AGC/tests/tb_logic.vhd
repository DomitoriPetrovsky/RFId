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
		BITNESS 		: NATURAL;
		n_size			: NATURAL);
	port(
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		out_x	: out	std_logic_vector(BITNESS-1 downto 0);
		out_n	: out	std_logic_vector(n_size-1 downto 0));
	end component;



constant bitness	: natural := 8;
constant n_size		: natural := 4;
signal test : std_logic_vector(bitness-1 downto 0);
signal test_n : std_logic_vector(n_size-1 downto 0);
signal test_adres : std_logic_vector(bitness-1 downto 0);

begin

	process
	begin
		test_adres <= (others => '0');
		wait for 5 ns;
		test_adres <= (others => '1');
		wait for 5 ns;
		test_adres <= "00011010";
		wait for 5 ns;
		test_adres <= "00001111";
		wait for 5 ns;
		test_adres <= "00101010";
		wait for 5 ns;
		test_adres <= "10001000";
		wait for 5 ns;
	end process;


u2: logic 	generic map(bitness, n_size)
				port map(test_adres, test, test_n);

	
end rtl;