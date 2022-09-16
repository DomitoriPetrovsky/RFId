library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_truncation is 
end tb_truncation;

architecture rtl of tb_truncation is

	component truncation is 
		generic(
			IWL 		: NATURAL;
			IFL			: NATURAL;
			OWL 		: NATURAL;
			OFL			: NATURAL);
		port(
			input 	: in	std_logic_vector(IWL-1 downto 0);
			output	: out	std_logic_vector(OWL-1 downto 0));
	end component;
	
constant IWL 	: natural := 42; 
constant IFL	: natural := 30;

constant OWL 	: natural := 21; 
constant OFL	: natural := 15;

signal test_in : std_logic_vector(IWL-1 downto 0);
signal test_out : std_logic_vector(OWL-1 downto 0);
--signal test_adres : std_logic_vector(table_len-1 downto 0);

begin

test:	process
	begin
		test_in <= (others => '0');
		wait for 5 ns;
		test_in <= (others => '1');
		wait for 5 ns;
		test_in <= "111111111111000000000000000000000000000000";
		wait for 5 ns;
		test_in <= "110000000000000000000000000000000000000000";
		wait for 5 ns;
		test_in <= "010000000000000000000000000000000000000000";
		wait for 5 ns;
		test_in <= "111111110101000000000000000000000000000000";
		wait for 5 ns;
		test_in <= "000000000111000000000000000000000000000000";
		wait for 5 ns;
		
	end process;


modul: truncation 	generic map(IWL, IFL, OWL, OFL)
				port map(test_in, test_out);

	
end rtl;