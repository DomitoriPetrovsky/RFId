library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;
use work.pkg_da_fir_constants.all;

entity polyphase_with_clk_manager is 
	generic(
		DATA		: two_dim_array_of_stdv;
		IWL			: NATURAL;
		OWL			: NATURAL;
		ORDER		: NATURAL;
		DEC_COEF	: NATURAL);
	port(
		clk		: in 	std_logic;
		ce 		: out 	std_logic;
		nrst	: in	std_logic;
		input	: in	std_logic_vector(IWL-1 downto 0);
		output	: out	std_logic_vector(OWL-1 downto 0));
end polyphase_with_clk_manager;

architecture rtl of polyphase_with_clk_manager is

	component polyphase_filter_decimator is 
	generic(
		DATA				: two_dim_array_of_stdv;
		IWL					: NATURAL;
		OWL					: NATURAL;
		FIR_PROTOTYPE_ORDER	: NATURAL;
		SUB_FILTER_ORDER 	: NATURAL;
		DEC_COEF			: NATURAL);
	port(
		clk		: in 	std_logic;
		ce_wr	: in 	std_logic;
		ce_work	: in 	std_logic;
		nrst	: in	std_logic;
		input	: in	std_logic_vector(IWL-1 downto 0);
		output	: out	std_logic_vector(OWL-1 downto 0));
	end component;

	component polyphase_clock_enable_manager is 
	generic(
		DEC_COEF	: NATURAL);
	port(
		clk			: in 	std_logic;
		ce		 : out	std_logic);
	end component;
	
	signal new_ce :  std_logic;
begin
	
	ce <= new_ce;
	
clk_manager: 	polyphase_clock_enable_manager
				generic map(
						DEC_COEF => DEC_COEF)
				port map( 
						clk => clk,
						ce => new_ce);
						
filter: polyphase_filter_decimator
				generic map(
						DATA => DATA,
						IWL => IWL,
						OWL => OWL,
						FIR_PROTOTYPE_ORDER	=> 12,
						SUB_FILTER_ORDER 	=> ORDER,
						DEC_COEF => DEC_COEF)
				port map(
						clk => clk,
						ce_wr => '1',
						ce_work => new_ce,
						nrst => nrst,
						input => input,
						output => output);
	
			
end rtl;