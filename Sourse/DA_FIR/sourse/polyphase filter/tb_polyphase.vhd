library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;
use work.pkg_da_fir_constants.all;

entity tb_polyphase is 
end tb_polyphase;

architecture rtl of tb_polyphase is

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



	component polyphase_with_clk_manager is 
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
	end component;
	
	constant IWL 		: NATURAL := 16;
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
	signal new_clk :  std_logic;
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
		wait for 30 ns;
		nrst <= '1';
		wait;
	end process;
		
-- data:	process
	-- begin 
		-- wait for 50 ns;
		-- input <= x"7f";
		-- wait for 10 ns;
		-- input <= x"00";
		-- wait;
	-- end process;


poly: polyphase_with_clk_manager
		generic map(DATA => STD_POLY_MATRIX_in_DA_TABLES_FIR_2,
					IWL =>  IWL,
					OWL => OWL,
					ORDER => ORDER,
					DEC_COEF => DEC_COEF)
		port map(clk => clk,
				ce => ce,
				nrst => nrst,
				input =>  input,
				output => output);
				
gen: sin_gen_NS 	generic map(WL, F, Fs, DL, data_bit_len, A1, A0)
							port map(clk, DATA, input);				
				

		
end rtl;