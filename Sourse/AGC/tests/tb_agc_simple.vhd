library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_agc_simple is 
end tb_agc_simple;

architecture rtl of tb_agc_simple is

	component  agc_simple is 
	generic(
		BITNESS : NATURAL);
	port(
		clk		: in	std_logic;
		wr_coef	: in 	std_logic;
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		R	 	: in 	std_logic_vector(BITNESS-1 downto 0);
		alfa 	: in 	std_logic_vector(BITNESS-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1 downto 0));
	end component;


	component sin_gen_NS is 
	generic(
		BITNESS : NATURAL;
		F		: NATURAL;
		FS		: NATURAL);
	port(
		clk		: in	std_logic;
		output	: out	std_logic_vector(BITNESS-1 downto 0));
	end component;
 
constant bitness	: natural := 16;
constant f			: natural := 2;
constant fs			: natural := 100;
signal input : std_logic_vector(bitness-1 downto 0) := (others => '0');
signal output : std_logic_vector(bitness-1 downto 0) := (others => '0');
signal alpha : std_logic_vector(bitness-1 downto 0) := (others => '0');
signal r : std_logic_vector(bitness-1 downto 0) := (others => '0');


signal test1 : unsigned(7 downto 0) := "10000001";
signal test2 : unsigned(15 downto 0) := (others => '0');

signal clk : std_logic := '0';
signal wr_coef : std_logic := '0';
begin
	
	
	process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;

	process
	begin
		wr_coef <= '1';
		alpha 	<= "0001110000000000";
		--r 		<= "0111110000000000";
		r 		<= "0011111001010110";
		wait for 10 ns;
		wr_coef <= '0';
		wait;
	end process;

u2: agc_simple 	generic map(bitness)
				port map(clk, wr_coef, input, r, alpha, output);
				
sin: sin_gen_NS generic map(bitness, f, fs)
				port map(clk, input);				

	
end rtl;