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
	constant F : NATURAL := 6780000;--1356000*10;--6780000;
	constant Fs : NATURAL := 60000000;
	constant DL : NATURAL := 10;
	constant data_bit_len : NATURAL := 16;

	constant A0 :  real := real(0.9);
	constant A1 :  real := real(0.9);
	
	signal data :  std_logic_vector(DL-1 downto 0) := "0101100111";
	
	signal clk :  std_logic;
	signal cascad :  std_logic;
	signal ce : std_logic;
	signal nrst : std_logic;
	signal input : std_logic_vector(IWL-1 downto 0) := (others => '0');
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
		wait;
	end process;
		


poly: polyphase_cascad2_with_clk_manager
		port map(clk => clk,
				nrst => nrst,
				cascad => ,
				ce => ce,
				input =>  input,
				output => output);
				
gen: sin_gen_NS 	generic map(WL, F, Fs, DL, data_bit_len, A1, A0)
							port map(clk, DATA, input);				
				

		
end rtl;