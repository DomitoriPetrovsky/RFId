library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_iir is 
end tb_iir;

architecture rtl of tb_iir is

	component iir_filter_exp_averaging is 
	generic(
		BITNESS 	: NATURAL;
		CWL			: NATURAL);
	port(
		clk			: in	std_logic;
		coef		: in	std_logic_vector(CWL-1 downto 0);
		input 		: in	std_logic_vector(BITNESS-1 downto 0);
		output		: out	std_logic_vector(BITNESS-1 downto 0));
	end component;


constant CWL : natural := 4; 
constant bitness	: natural := 16;
signal input : std_logic_vector(bitness-1 downto 0) := (others => '0');
signal output : std_logic_vector(bitness-1 downto 0) := (others => '0');
signal alpha : std_logic_vector(CWL-1 downto 0) := (others => '0');

signal test1 : unsigned(7 downto 0) := "10000001";
signal test2 : unsigned(15 downto 0) := (others => '0');

signal clk : std_logic := '0';

begin
	
	test2 <= resize(test1, test2'high+1); 
	
	process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;


	process
	begin 
		alpha <= "0111";
		wait for 10 ns;
		input <= (others => '1');
		input(input'high) <= '0';
		wait for 5 ns;
		input <= (others => '0');
		wait for 200 ns;
		input <= "0011010100101001";
		wait for 10 ns;
		input <= (others => '0');
		wait;
		
	
	end process;


u2: iir_filter_exp_averaging 	generic map(bitness, CWL)
								port map(clk, alpha, input, output);

	
end rtl;