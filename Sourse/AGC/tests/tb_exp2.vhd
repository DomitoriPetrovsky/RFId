library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_exp2 is 
end tb_exp2;

architecture rtl of tb_exp2 is

	component   exp2 is 
	generic(
		BITNESS 		: NATURAL;
		DIWL			: NATURAL;
		DIFL			: NATURAL;
		GIWL			: NATURAL;
		GIFL			: NATURAL;
		OWL				: NATURAL;
		OFL				: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		input_gain 	: in	std_logic_vector(GIWL-1 downto 0);
		input_data	: in 	std_logic_vector(DIWL-1 downto 0);
		output		: out	std_logic_vector(OWL-1 downto 0));
	end component;

constant table_len : natural := 7; 
constant bitness	: natural := 16;

constant		DIWL	: NATURAL := 16;
constant		DIFL	: NATURAL := 15;
constant		GIWL	: NATURAL := 20;
constant		GIFL	: NATURAL := 15;
constant		OWL	: NATURAL := 16;
constant		OFL	: NATURAL := 15;


signal test_gain 	: std_logic_vector(GIWL-1 downto 0);
signal test_in 		: std_logic_vector(DIWL-1 downto 0);
signal test_out 	: std_logic_vector(OWL-1 downto 0);

signal a : signed(3 downto 0):= "0010";
signal b : signed(7 downto 0):= "00010110";
signal c : signed(a'length + b'length - 1 downto 0);

signal test : NATURAL;
signal test1 : NATURAL;
signal test2 : NATURAL;
signal test3 : NATURAL;

begin
	process
	begin
		test_gain <= '1' & "1101" & "000011110100000";
		test_in <= "0010000000000000";
		wait for 10 ns;
		
	end process;

	test <= log_len(DIWL); --16
	test1 <= log_len(DIFL); -- 15
	test2 <= log_len(GIWL); -- 20
	test3 <= log_len(NATURAL(32)); --32
	c <= a * b;

u2: exp2 	generic map(BITNESS => bitness, 
						DIWL => DIWL, 
						DIFL => DIFL,
						GIWL => GIWL, 
						GIFL => GIFL, 
						OWL  => OWL,   
						OFL  => OFL, 
						TABLE_LENGTH => table_len)
			port map(input_gain =>test_gain,
					input_data => test_in, 
					output => test_out);

	
end rtl;