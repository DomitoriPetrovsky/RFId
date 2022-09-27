library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_fir_iter is 
end tb_fir_iter;

architecture rtl of tb_fir_iter is

	component  fir_da_iter is 
	generic(
		IWL		: NATURAL := 8;
		ORDER	: NATURAL := 4);
	port(
		clk		: in 	std_logic;
		nrst	: in	std_logic;
		input	: in 	std_logic_vector(IWL-1 downto 0);
		done	: out 	std_logic;
		output	: out 	std_logic_vector(IWL-1 downto 0));
	end component;

 
constant bitness	: natural := 8;

signal input : std_logic_vector(bitness-1 downto 0) := (others => '0');
signal output : std_logic_vector(bitness-1 downto 0) := (others => '0');

signal clk : std_logic := '0';
signal nrst : std_logic := '0';
signal done : std_logic;

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
		wait for 30 ns;
		nrst <= '1';
		input <= "01111111";
		wait for 40 ns;
		input <= (others => '0');
		wait for 10 ns;
		wait;
	end process;

u: fir_da_iter 	generic map(IWL => bitness, ORDER => 4)
				port map(clk => clk,
						nrst =>  nrst,
						input => input,
						done =>  done,
						output =>  output);
	
end rtl;