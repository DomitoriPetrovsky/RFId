library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ring_shift_rg_mas is 
	generic(
		IWL			: NATURAL := 16;
		numb_reg	: Natural := 4;
		shLeft		: BOOlEAN := FALSE);
	port(
		clk			: in 	std_logic;
		nrst			: in	std_logic;
		shR			: in	std_logic;
		input	 	: in	std_logic_vector(IWL-1 downto 0);
		cout		: out	std_logic_vector(numb_reg-1 downto 0);
		output		: out	std_logic_vector(IWL-1 downto 0));
end ring_shift_rg_mas;

architecture rtl of ring_shift_rg_mas is

	component ring_shift_rg_with_parallel_record is 
	generic(
		IWL			: NATURAL;
		shLeft		: BOOlEAN);
	port(
		clk			: in 	std_logic;
		nrst			: in	std_logic;
		shR			: in	std_logic;
		input	 	: in	std_logic_vector(IWL-1 downto 0);
		cout		: out	std_logic;
		output		: out	std_logic_vector(IWL-1 downto 0));
	end component;

	type mas is array (NATURAL range <>) of std_logic_vector(IWL-1 downto 0);
	
	signal vectors  : mas(0 to numb_reg);
	signal mas_cout : std_logic_vector(numb_reg-1 downto 0); 
	
begin

gen_reg	: for I in 0 to numb_reg-1 generate
reg: ring_shift_rg_with_parallel_record 
	generic map(IWL => IWL, shLeft => shLeft)
	port map (	clk => clk,
				nrst => nrst,
				shR => shR, 
				input => vectors(I),
				cout => mas_cout(I),
				output => vectors(I+1));
end generate;
	
	vectors(0) <= input;
	cout <= mas_cout;
	output <= vectors(numb_reg);
	
end rtl;