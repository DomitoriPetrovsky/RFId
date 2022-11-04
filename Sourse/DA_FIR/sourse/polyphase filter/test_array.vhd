library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;
use work.pkg_da_fir_constants.all;

entity test_array is 
end test_array;

architecture rtl of test_array is

	-- signal test1 : one_dim_array_of_real(NUM_COEFFS_FIR_FILTR_1-1 downto 0) := REAL_FIR1_COEFFS;	
	-- signal test2 : two_dim_array_of_real(COEFF_DEC_POLY_1-1 downto 0, SUB_FILTER1_LEn-1  downto 0) := REAL_FIR1_POLY_COEFFS;	
	-- signal test3 : two_dim_array_of_real(COEFF_DEC_POLY_1-1 downto 0, DA_TABLE_LEN_SUB_FILTER1-1 downto 0) := REAL_FIR1_POLY_COEFFS_DA_TABLES;
	-- signal test4 : two_dim_array_of_stdv(COEFF_DEC_POLY_1-1 downto 0)(DA_TABLE_LEN_SUB_FILTER1-1 downto 0)(8-1 downto 0) := STD_FIR1_POLY_COEFFS_DA_TABLES;
	
	
	signal std :  two_dim_array_of_stdv(COEFF_DEC_POLY_FIR_1-1 downto 0)				--second dimention
										(DA_TABLE_LEN_POLYPHASE_FIR_1-1  downto 0)		-- first dimention
										(OWL_FIR_1-1 downto 0) := STD_POLY_MATRIX_in_DA_TABLES_FIR_1;
	
	signal  R_M_DA: two_dim_array_of_real(COEFF_DEC_POLY_FIR_1-1 downto 0)(DA_TABLE_LEN_POLYPHASE_FIR_1-1  downto 0) 
								:= REAL_POLY_MATRIX_in_DA_TABLES_FIR_1;
	
	signal RMATRIX : two_dim_array_of_real(COEFF_DEC_POLY_FIR_1-1 downto 0)(POLYPHASE_LEN_FIR_1-1 downto 0) 
								:= REAL_POLY_MATRIX_FIR_1;
	
	signal COEFFS : one_dim_array_of_real(ORDER_FIR_1-1 downto 0) := REAL_COEFFS_FIR_1;
	
	
	signal zero :  real :=  real(0);
	
	signal a :  std_logic := '0';
	
	signal len :  NATURAL := SUB_FILTER1_LEn;
	signal Tlen :  NATURAL := DA_TABLE_LEN_SUB_FILTER1;	
	
	
	
	type std_1dim is array (NATURAL range <>) of std_logic_vector;
	
	type std_2dim is array (NATURAL range <>) of std_1dim;

	
	signal my1 :  std_1dim(3 downto 0)(3 downto 0) := (
							0 => "0000",
							1 => "0001",
							2 => "0010",
							3 => "0011");
	signal my2 : std_2dim(3 downto 0)(3 downto 0)(3 downto 0);
	
begin
	my2(0) <= my1; 
	
	
	process
	begin 
		a <= '0';
		wait for 5 ns;
		a <= '1';
		wait for 5 ns;
	end process;
			
			
end rtl;