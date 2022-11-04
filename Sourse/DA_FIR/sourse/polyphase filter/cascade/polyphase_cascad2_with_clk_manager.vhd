library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;
use work.pkg_da_fir_constants.all;

entity polyphase_cascad2_with_clk_manager is 
	generic(
		DATA_FIR_1			: two_dim_array_of_stdv;
		DATA_FIR_2			: two_dim_array_of_stdv;
		IWL					: NATURAL;
		OWL					: NATURAL;
		ORDER_F_1			: NATURAL;
		ORDER_F_2			: NATURAL;
		SUB_ORDER_FIR_1		: NATURAL;
		SUB_ORDER_FIR_2		: NATURAL;
		DEC_COEF_1			: NATURAL;
		DEC_COEF_2			: NATURAL);
	port(
		clk		: in 	std_logic;
		nrst	: in	std_logic;
		cascad	: in 	std_logic;
		ce 		: out 	std_logic;
		input	: in	std_logic_vector(IWL_FIR_1-1 downto 0);
		output	: out	std_logic_vector(OWL_FIR_2-1 downto 0));
end polyphase_cascad2_with_clk_manager;

architecture rtl of polyphase_cascad2_with_clk_manager is

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

	component polyphase_clock_enable2_manager is 
	generic(
		DEC_COEF_1	: NATURAL;
		DEC_COEF_2	: NATURAL);
	port(
		clk			: in 	std_logic;
		ce_1		: out	std_logic;
		ce_2		: out	std_logic);
	end component;
	
	signal fir_1_out : std_logic_vector(OWL_FIR_1-1 downto 0);
	signal fir_2_out : std_logic_vector(OWL_FIR_2-1 downto 0);
	
	signal ce_work_1 : std_logic;
	signal ce_work_2 : std_logic;
	
	signal ce_wr_1 : std_logic;
	signal ce_wr_2 : std_logic;
	
	signal nrst_fir_2 :  std_logic;
	
begin
	
	
	ce_wr_1 <= '1';
	ce_wr_2 <= ce_work_1;
	
	ce <= ce_work_1 when cascad = '0' else ce_work_2;
	
	output <= fir_1_out when cascad = '0' else fir_2_out;
	
	nrst_fir_2 <= nrst and cascad;
	
clk_en_manager: 	polyphase_clock_enable2_manager
				generic map(
						DEC_COEF_1 => DEC_COEF_1,
						DEC_COEF_2 => DEC_COEF_2)
				port map( 
						clk		=> clk,
						ce_1 	=> ce_work_1,
						ce_2 	=> ce_work_2);
						
filter_1: polyphase_filter_decimator
				generic map(
						DATA 				=> DATA_FIR_1,
						IWL 				=> IWL,
						OWL 				=> OWL,
						FIR_PROTOTYPE_ORDER	=> ORDER_F_1,
						SUB_FILTER_ORDER 	=> SUB_ORDER_FIR_2,
						DEC_COEF 			=> DEC_COEF_1)
				port map(
						clk		=> clk,
						ce_wr	=> ce_wr_1,
						ce_work	=> ce_work_1,
						nrst	=> nrst,
						input	=> input,
						output	=> fir_1_out);
	
filter_2: polyphase_filter_decimator
				generic map(
						DATA 				=> DATA_FIR_2,
						IWL 				=> OWL,
						OWL 				=> OWL,
						FIR_PROTOTYPE_ORDER	=> ORDER_F_2,
						SUB_FILTER_ORDER 	=> SUB_ORDER_FIR_2,
						DEC_COEF 			=> DEC_COEF_2)
				port map(
						clk		=> clk,
						ce_wr	=> ce_wr_2,
						ce_work	=> ce_work_2,
						nrst	=> nrst_fir_2,
						input	=> fir_1_out,
						output	=> fir_2_out);	

		
end rtl;