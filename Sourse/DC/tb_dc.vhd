library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_dc is 
end tb_dc;

architecture rtl of tb_dc is

	component   dc_component is 
	generic(
		IWL 	: NATURAL);
	port(
		clk		: in	std_logic;
		wr_coef	: in 	std_logic;
		A 		: in 	std_logic_vector(BITNESS-1 downto 0);
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1 downto 0));
	end component;


	component sin_gen_NS_dc_test is 
	generic(
		BITNESS : NATURAL;
		F		: NATURAL;
		FS		: NATURAL);
	port(
		clk		: in	std_logic;
		output	: out	std_logic_vector(BITNESS-1 downto 0));
	end component;
 
constant bitness	: natural := 16;
constant cwl		: natural := 4;
constant f			: natural := 2;
constant fs			: natural := 100;
signal input  : std_logic_vector(bitness-1 downto 0) := (others => '0');
signal output : std_logic_vector(bitness-1 downto 0) := (others => '0');
signal alpha  : std_logic_vector(bitness-1 downto 0) := (others => '0');


signal test : signed(7 downto 0) := "10000001";
signal test1 : signed(7 downto 0);
signal test2 : signed(7 downto 0);


signal clk : std_logic := '0';
signal wr_coef : std_logic := '0';
begin
	
	test1 <= test sll -1;
	--test2 <= test sra 1;
	
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
		alpha 	<= x"0666";
		wait for 10 ns;
		wr_coef <= '0';
		wait;
	end process;

u2: dc_component 	generic map(IWL => bitness)
					port map(clk => clk, 
							wr_coef => wr_coef, 
							A => alpha, 
							input => input, 
							output => output);
				
sin: sin_gen_NS_dc_test generic map(bitness, f, fs)
						port map(clk, input);				

	
end rtl;