library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;
use work.pkg_da_fir_types_func.all;
use work.pkg_da_fir_constants.all;

entity Filt_Dc_Agc_channel is 
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
		DEC_COEF_2			: NATURAL;
		
		TABLE_LOG_LEN_AGC	: NATURAL;
		COEFF_WL_AGC_FIR	: NATURAL;
		LogWL				: NATURAL);
	port(
		clk 					: in 	std_logic;
		nrst 					: in 	std_logic;
		cascad					: in 	std_logic;
		wr_coeff_DC 			: in 	std_logic;
		wr_coeff_AGC 			: in 	std_logic;
		ce						: out 	std_logic;
		coeff_DC 				: in 	std_logic_vector(OWL-1 downto 0);
		coeff_AGC_LogR 			: in 	std_logic_vector(LogWL-1 downto 0);
		coeff_AGC_alpha 		: in 	std_logic_vector(OWL-1 downto 0);
		coeff_AGC_aplpha_fir 	: in 	std_logic_vector(COEFF_WL_AGC_FIR-1 downto 0);
		input 					: in 	std_logic_vector(IWL-1 downto 0); 
		output 					: out 	std_logic_vector(OWL-1 downto 0)
		
		);
end Filt_Dc_Agc_channel;

architecture rtl of Filt_Dc_Agc_channel is

	component polyphase_cascad2_with_clk_manager is 
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
	end component;

	component  dc_component is 
		generic(
			IWL : NATURAL);
		port(
			clk		: in	std_logic;
			wr_coef	: in 	std_logic;
			ce		: in 	std_logic;
			nrst	: in 	std_logic;
			A 		: in 	std_logic_vector(IWL-1 downto 0);
			input 	: in	std_logic_vector(IWL-1 downto 0);
			output	: out	std_logic_vector(IWL-1 downto 0));
	end component;

	component agc_log is 
		generic(
			BITNESS 		: NATURAL;
			IIR_WCL 		: NATURAL;
			TABLE_LENGTH 	: NATURAL;
			LogWL			: NATURAL);
		port(
			clk			: in	std_logic;
			nrst		: in	std_logic;
			ce			: in	std_logic;
			wr_coef		: in 	std_logic;
			input 		: in	std_logic_vector(BITNESS-1 downto 0);
			R	 		: in 	std_logic_vector(BITNESS-1 downto 0);
			alfa 		: in 	std_logic_vector(BITNESS-1 downto 0);
			iir_coef	: in 	std_logic_vector(IIR_WCL-1 downto 0);
			log_in_sig 	: out 	std_logic_vector(LogWL-1 downto 0);
			output		: out	std_logic_vector(BITNESS-1 downto 0));
	end component;
	
	
	signal tmp_in : std_logic_vector(IWL-1 downto 0);
	signal tmp_out : std_logic_vector(OWL-1 downto 0);
	
	signal tmp_ce : std_logic;
	
	signal poly_out : std_logic_vector(OWL-1 downto 0);
	signal dc_out : std_logic_vector(OWL-1 downto 0);
	signal agc_out : std_logic_vector(OWL-1 downto 0);
	signal agc_log_out : std_logic_vector(LogWL-1 downto 0);
	--signal mosynost : std_logic_vector();
	
	
begin
	tmp_in <= input;
	output <= agc_out;
	ce <= tmp_ce;
	
poly: polyphase_cascad2_with_clk_manager
		generic map(
				DATA_FIR_1		=> DATA_FIR_1,	
				DATA_FIR_2		=> DATA_FIR_2,
				IWL				=> IWL,	
				OWL				=> OWL,		
				ORDER_F_1		=> ORDER_F_1,			
				ORDER_F_2		=> ORDER_F_2,		
				SUB_ORDER_FIR_1	=> SUB_ORDER_FIR_1,		
				SUB_ORDER_FIR_2	=> SUB_ORDER_FIR_2, 	
				DEC_COEF_1		=> DEC_COEF_1,	
				DEC_COEF_2		=> DEC_COEF_2)	
		port map(clk 	=> clk,
				nrst 	=> nrst,
				cascad 	=> cascad,
				ce 		=> tmp_ce,
				input 	=> tmp_in,
				output 	=> poly_out);
	
	
	
dc: dc_component 	
		generic map(IWL => OWL)
		port map(clk 	=> clk, 
				nrst 	=> nrst,
				ce 		=> tmp_ce,
				wr_coef => wr_coeff_DC, 
				A 		=> coeff_DC, 
				input 	=> poly_out, 
				output 	=> dc_out);	
	
agc: agc_log 	
		generic map(BITNESS 		=> OWL, 
					IIR_WCL 		=> COEFF_WL_AGC_FIR, 
					TABLE_LENGTH 	=> TABLE_LOG_LEN_AGC,
					LogWL 			=> LogWL)
		port map(clk 		=> clk, 
				nrst 		=> nrst,
				ce 			=> tmp_ce,
				wr_coef 	=> wr_coeff_AGC, 
				input 		=> dc_out, 
				R 			=> coeff_AGC_LogR, 
				alfa 		=> coeff_AGC_alpha, 
				iir_coef 	=> coeff_AGC_aplpha_fir,
				log_in_sig	=> agc_log_out,
				output 		=> agc_out);
		
	
	
	
end rtl;