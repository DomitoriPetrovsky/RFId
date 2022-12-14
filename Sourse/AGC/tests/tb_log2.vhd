library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_log2 is 
end tb_log2;

architecture rtl of tb_log2 is

	component  log2 is 
	generic(
		BITNESS 		: NATURAL;
		IWL				: NATURAL;
		IFL				: NATURAL;
		OWL				: NATURAL;
		OFL				: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		input 	: in	std_logic_vector(IWL-1 downto 0);
		output	: out	std_logic_vector(OWL-1 downto 0));
	end component;


constant table_len : natural := 7; 
constant bitness	: natural := 16;

constant		IWL	: NATURAL := 16;
constant		IFL	: NATURAL := 15;
constant		OWL	: NATURAL := 20;
constant		OFL	: NATURAL := 15;

constant		TEST1	: NATURAL := 20;
constant		TEST2	: NATURAL := 21;


signal test_in : std_logic_vector(IWL-1 downto 0);
signal test_out : std_logic_vector(OWL-1 downto 0);


begin
	--если условие верно то выводим ошибку!
	assert TEST1>TEST2
	report "we have a problem!"
	severity error;
	--severity failure;
	process
	begin
		test_in <= "0001000000010110"; --0.5
		wait for 5 ns;
		test_in <= (others => '0');
		wait for 5 ns;
		test_in <= (others => '1');
		wait for 5 ns;
		test_in <= "0100000000000000"; --0.5
		wait for 5 ns;
		test_in <= "0111000000000000"; --0.875
		wait for 5 ns;
		test_in <= "0000000000000001"; --2^-15
		wait for 5 ns;
		test_in <= "0000000000000100"; --2^-13
		wait for 5 ns;
		test_in <= "0010000000000000"; --0.25
		wait for 5 ns;
		test_in <= "0000000001000000"; --2^-9
		wait for 5 ns;
	end process;


u2: log2 	generic map(bitness,  IWL, IFL, OWL, OFL, table_len)
			port map(test_in, test_out);

	
end rtl;