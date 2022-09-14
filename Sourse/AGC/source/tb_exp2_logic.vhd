library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_exp2_logic is 
end tb_exp2_logic;

architecture rtl of tb_exp2_logic is

	component exp2_logic is 
	generic(
		IWL 		: NATURAL;
		IFL			: NATURAL);
	port(
		input 		: in	std_logic_vector(IWL-1 downto 0);
		out_id		: out	std_logic_vector(IFL-1 downto 0);
		out_shift	: out	std_logic_vector(IWL-IFL-1 downto 0));
	end component;


constant IWL 	: natural := 21; 
constant IFL	: natural := 15;

signal input 	: std_logic_vector(IWL-1 downto 0) := (others => '0');
signal id 		: std_logic_vector(IFL-1 downto 0) := (others => '0');
signal shift	: std_logic_vector(IWL-IFL-1 downto 0) := (others => '0');

begin
	

	process
	begin 
		input <= (others => '1');
		input(input'high) <= '0';
		wait for 10 ns;
		input <= (others => '1');
		wait for 10 ns;
		input <= (others => '0');
		wait for 10 ns;
		input <= "010110011010100101001";
		wait for 10 ns;
		input <= (others => '0');
		wait;
		
	
	end process;


u2: exp2_logic 	generic map(IWL, IFL)
				port map(input, id, shift);

	
end rtl;