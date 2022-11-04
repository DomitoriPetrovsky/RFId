library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;
use work.pkg_da_fir_constants.all;
use work.pkg_log_func.all;

entity tb_Filt_DC_AGC_channel is 
end tb_Filt_DC_AGC_channel;

architecture rtl of tb_Filt_DC_AGC_channel is

	component Filt_Dc_Agc_channel is 
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
	end component;

	component sin_gen_channel_test is 
		generic(
			OWL	 	: NATURAL;
			F		: NATURAL;
			FS		: NATURAL;
			DL		: NATURAl;
			data_bit_len	: NATURAl;
			A1		: real;
			A0		: real;
			CONST_VALUE : REAL;
			PEAK_f		: NATURAL);
		port(
			clk		: in	std_logic;
			DATA	: in	std_logic_vector(DL-1 downto 0);
			output	: out	std_logic_vector(OWL-1 downto 0));
	end component;


	
	--
	constant IWL 		: NATURAL := 4;
	constant OWL 		: NATURAL := 16;
	constant ORDER 		: NATURAL := 16;
	constant DEC_COEF 	: NATURAL := 2;
	
	-- AGC
	constant COEFF_WL_AGC_FIR :  NATURAL := 5;
	constant LogWL :  NATURAL := log_len(OWL_FIR_2);
	
	constant CWL : natural := 4; 
	constant WL	: natural := IWL;
	constant F : NATURAL := 13560000;
	constant FData : NATURAL := F/16;--1695000;--678000;--1356000*10;--6780000;
	constant Fs : NATURAL := 60000000;
	constant DL : NATURAL := 10;
	constant data_bit_len : NATURAL := 264;

	constant A0 :  real := real(0.9);
	constant A1 :  real := real(0.9);
	
	constant CONST_VALUE :  real := real(0);
	constant PEAK_f :  NATURAL := 0;
	
	signal data :  std_logic_vector(DL-1 downto 0) := "0101100111";
	
	signal clk :  std_logic;
	signal cascad :  std_logic;
	signal ce : std_logic;
	signal nrst : std_logic;
	signal input : std_logic_vector(IWL-1 downto 0) := (others => '0');
	
	signal output : std_logic_vector(OWL-1 downto 0);
	
	
	
	signal 	wr_coeff_DC 			: std_logic;
	signal 	wr_coeff_AGC 			: std_logic;
	signal 	coeff_DC 				: std_logic_vector(OWL_FIR_2-1 downto 0);
	signal 	coeff_AGC_LogR 			: std_logic_vector(LogWL-1 downto 0);
	signal 	coeff_AGC_alpha 		: std_logic_vector(OWL_FIR_2-1 downto 0);
	signal 	coeff_AGC_aplpha_fir 	: std_logic_vector(COEFF_WL_AGC_FIR-1 downto 0);
	
	
begin
clock:	process
	begin 
		clk  <= '0';
		wait for 5 ns;
		clk  <= '1';
		wait for 5 ns;
	end process;
	
reset:	process
	begin 
		nrst <= '0';
		cascad <= '0';
		wait for 30 ns;
		nrst <= '1';
		wait for 10000 ns;
		cascad <= '1';
		wait;
	end process;
	
coeffs:	process
	begin 
		coeff_DC <= x"0635";
		coeff_AGC_LogR <= x"EF237";--"00000" & "000000000000000";
		coeff_AGC_alpha <= x"1366";
		coeff_AGC_aplpha_fir <= "00100";
		
		wr_coeff_AGC <= '1';
		wr_coeff_DC <= '1';
		
		wait for 30 ns;
		
		wr_coeff_AGC <= '0';
		wr_coeff_DC <= '0';
		wait;
	end process;
	


channel: Filt_Dc_Agc_channel
		generic map(
				DATA_FIR_1			=> STD_POLY_MATRIX_in_DA_TABLES_FIR_1,	
				DATA_FIR_2			=> STD_POLY_MATRIX_in_DA_TABLES_FIR_2,
				IWL					=> IWL_FIR_1,	
				OWL					=> OWL_FIR_2,		
				ORDER_F_1			=> ORDER_FIR_1,			
				ORDER_F_2			=> ORDER_FIR_2,		
				SUB_ORDER_FIR_1		=> POLYPHASE_LEN_FIR_1,		
				SUB_ORDER_FIR_2		=> POLYPHASE_LEN_FIR_2, 	
				DEC_COEF_1			=> COEFF_DEC_POLY_FIR_1,	
				DEC_COEF_2			=> COEFF_DEC_POLY_FIR_2,
				TABLE_LOG_LEN_AGC 	=> TABLE_LEN,
				COEFF_WL_AGC_FIR 	=> COEFF_WL_AGC_FIR,
				LogWL 				=> LogWL)	
		port map(clk 				=> clk,
				nrst 				=> nrst,
				cascad 				=> cascad,
				wr_coeff_DC 		=> wr_coeff_DC,
				wr_coeff_AGC 		=> wr_coeff_AGC,
				ce 					=> ce,
				coeff_DC 			=> coeff_DC,
				coeff_AGC_LogR 		=> coeff_AGC_LogR,
				coeff_AGC_alpha 	=> coeff_AGC_alpha,
				coeff_AGC_aplpha_fir => coeff_AGC_aplpha_fir,
				input 				=> input,
				output 				=> output);
				
gen: sin_gen_channel_test 	
		generic map(WL, FData, Fs, DL, data_bit_len, A1, A0, CONST_VALUE, PEAK_f)
		port map(clk, DATA, input);				
				

		
end rtl;