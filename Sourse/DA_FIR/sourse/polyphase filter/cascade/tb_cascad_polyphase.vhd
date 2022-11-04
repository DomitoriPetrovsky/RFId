library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;
use work.pkg_da_fir_constants.all;

entity tb_cascad_polyphase is 
end tb_cascad_polyphase;

architecture rtl of tb_cascad_polyphase is

	component sin_gen_NS is 
		generic(
			OWL	 	: NATURAL;
			F		: NATURAL;
			FS		: NATURAL;
			DL		: NATURAl;
			data_bit_len	: NATURAl;
			A1		: real;
			A0		: real);
		port(
			clk		: in	std_logic;
			DATA	: in	std_logic_vector(DL-1 downto 0);
			output	: out	std_logic_vector(OWL-1 downto 0));
	end component;



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
	
	constant IWL 		: NATURAL := 4;
	constant OWL 		: NATURAL := 16;
	constant ORDER 		: NATURAL := 16;
	constant DEC_COEF 	: NATURAL := 2;
	
	constant CWL : natural := 4; 
	constant WL	: natural := IWL;
	constant F : NATURAL := 678000;--1356000*10;--6780000;
	constant Fs : NATURAL := 60000000;
	constant DL : NATURAL := 10;
	constant data_bit_len : NATURAL := 264;

	constant A0 :  real := real(0.9);
	constant A1 :  real := real(0.9);
	
	signal data :  std_logic_vector(DL-1 downto 0) := "0101100111";
	
	signal clk :  std_logic;
	signal cascad :  std_logic;
	signal ce : std_logic;
	signal nrst : std_logic;
	signal input : std_logic_vector(IWL-1 downto 0) := (others => '0');
	signal input_fir : std_logic_vector(IWL-1 downto 0) := (others => '0');
	signal output : std_logic_vector(OWL-1 downto 0);

	
	
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
		


poly: polyphase_cascad2_with_clk_manager
		generic map(
				DATA_FIR_1		=> STD_POLY_MATRIX_in_DA_TABLES_FIR_1,	
				DATA_FIR_2		=> STD_POLY_MATRIX_in_DA_TABLES_FIR_2,
				IWL				=> IWL_FIR_1,	
				OWL				=> OWL_FIR_2,		
				ORDER_F_1		=> ORDER_FIR_1,			
				ORDER_F_2		=> ORDER_FIR_2,		
				SUB_ORDER_FIR_1	=> POLYPHASE_LEN_FIR_1,		
				SUB_ORDER_FIR_2	=> POLYPHASE_LEN_FIR_2, 	
				DEC_COEF_1		=> COEFF_DEC_POLY_FIR_1,	
				DEC_COEF_2		=> COEFF_DEC_POLY_FIR_2)	
		port map(clk => clk,
				nrst => nrst,
				cascad => cascad,
				ce => ce,
				input =>  input,
				output => output);
				
gen: sin_gen_NS 	generic map(WL, F, Fs, DL, data_bit_len, A1, A0)
							port map(clk, DATA, input);				
				

		
end rtl;