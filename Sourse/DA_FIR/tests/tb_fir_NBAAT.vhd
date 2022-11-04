library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;
use work.pkg_da_fir_constants.all;

entity tb_fir_NBAAT is 
end tb_fir_NBAAT;

architecture rtl of tb_fir_NBAAT is

	component  fir_da_NBAAT is 
	generic(
		DATA		: one_dim_array_of_stdv;
		IWL			: NATURAL;
		ExWL		: NATURAL;
		ORDER		: NATURAL);
	port(
		clk			: in 	std_logic;
		nrst		: in	std_logic;
		en 			: in 	std_logic;
		input		: in 	std_logic_vector(IWL-1 downto 0);
		output		: out	std_logic_vector(IWL-1 downto 0));
	end component;

 
constant bitness	: natural := 8;

signal DATA :  one_dim_array_of_stdv(3 downto 0)(bitness-1 downto 0) := STD_FIR1_POLY_COEFFS_DA_TABLES(1) ;



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
		wait for 10 ns;
		input <= (others => '0');
		wait for 10 ns;
		--input <= "00000001";
		wait;
	end process;

u: fir_da_NBAAT generic map(DATA => DATA,
							IWL => bitness,
							ExWL => 0,
							ORDER => 3)
				port map(clk => clk,
						nrst =>  nrst,
						en => '1',
						input => input,
						output =>  output);
	
end rtl;