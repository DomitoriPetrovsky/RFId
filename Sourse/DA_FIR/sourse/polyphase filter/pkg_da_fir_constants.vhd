library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;

package pkg_da_fir_constants is
	
	
	
	
	
	constant IWL_FIR1 : NATURAL := 4;
	constant OWL_FIR1 : NATURAL := 8;
	constant OFL_FIR1 : NATURAL := 7;
	
	constant COEFF_DEC_POLY_1 : NATURAL := 4;
	
	constant NUM_COEFFS_FIR_FILTR_1 :  NATURAL := 12;
	
	constant SUB_FILTER1_LEn : NATURAL := 3;--NUM_COEFFS_FIR_FILTR_1/ COEFF_DEC_POLY_1;
	constant DA_TABLE_LEN_SUB_FILTER1 : NATURAL := 2**(SUB_FILTER1_LEn-1);
	
	
	constant REAL_FIR1_COEFFS : one_dim_array_of_real(NUM_COEFFS_FIR_FILTR_1-1 downto 0) :=(
		0  => real(0.0131),    
		1  => real(0.0252),    
		2  => real(0.0578),    
		3  => real(0.1005),    
		4  => real(0.1399),    
		5  => real(0.1634),    
		6  => real(0.1634),    
		7  => real(0.1399),    
		8  => real(0.1005),    
		9  => real(0.0578),    
		10 => real(0.0252),    
		11 => real(0.0131));
		
		
		
		
	constant REAL_TESTS : one_dim_array_of_real(NUM_COEFFS_FIR_FILTR_1-1 downto 0) :=(
		0  => real(0),    
		1  => real(1),    
		2  => real(2),    
		3  => real(3),    
		4  => real(4),    
		5  => real(5),    
		6  => real(6),    
		7  => real(7),    
		8  => real(8),    
		9  => real(9),    
		10 => real(10),    
		11 => real(11));
	
	--constant REAL_POLY_TESTS : two_dim_array_of_real(COEFF_DEC_POLY_1-1 downto 0)(NUM_COEFFS_FIR_FILTR_1/COEFF_DEC_POLY_1 -1  downto 0) := REAL_FIR_2_REAL_POLY_FILTER(REAL_TESTS, NUM_COEFFS_FIR_FILTR_1, COEFF_DEC_POLY_1);
	
	
	constant REAL_FIR1_POLY_COEFFS : two_dim_array_of_real(COEFF_DEC_POLY_1-1 downto 0)(SUB_FILTER1_LEn -1  downto 0) := REAL_FIR_2_REAL_POLY_FILTER(REAL_FIR1_COEFFS, NUM_COEFFS_FIR_FILTR_1, COEFF_DEC_POLY_1);
	
	constant REAL_FIR1_POLY_COEFFS_DA_TABLES : two_dim_array_of_real(COEFF_DEC_POLY_1-1 downto 0)(DA_TABLE_LEN_SUB_FILTER1-1  downto 0) := REAL_FIR_POLY_2_REAL_POLY_DA(REAL_FIR1_POLY_COEFFS, SUB_FILTER1_LEn, COEFF_DEC_POLY_1);
	
	constant STD_FIR1_POLY_COEFFS_DA_TABLES : two_dim_array_of_stdv
												(COEFF_DEC_POLY_1-1 downto 0)				--second dimention
												(DA_TABLE_LEN_SUB_FILTER1-1  downto 0)		-- first dimention
												(OWL_FIR1-1 downto 0) := 					-- std_logic_vector RANGE
												REAL_POLY_DA_2_STD_POLY_DA(					-- Function
													REAL_FIR1_POLY_COEFFS_DA_TABLES, 
													COEFF_DEC_POLY_1, 
													DA_TABLE_LEN_SUB_FILTER1, 
													OWL_FIR1, 
													OFL_FIR1);
													
													
	---------------------------------------------------------
	-- Coeffiisients for first Filter decimator
	---------------------------------------------------------
	constant ORDER_FIR_1 					: NATURAL := 64;
	constant IWL_FIR_1 						: NATURAL := 4;
	constant OWL_FIR_1 						: NATURAL := 16;
	constant OFL_FIR_1 						: NATURAL := 15;
	constant COEFF_DEC_POLY_FIR_1 			: NATURAL := 4;
	constant POLYPHASE_LEN_FIR_1 			: NATURAL := 16;--NUM_COEFFS_FIR_FILTR_1/ COEFF_DEC_POLY_1;
	constant DA_TABLE_LEN_POLYPHASE_FIR_1	: NATURAL := 2**(POLYPHASE_LEN_FIR_1-1);
	
	constant REAL_COEFFS_FIR_1 : one_dim_array_of_real(ORDER_FIR_1-1 downto 0) :=(
		0 => real(0.0001),
		1 => real(0.0003),
		2 => real(0.0006),
		3 => real(0.0007),
		4 => real(0.0004),
		5 => real(-0.007),
		6 => real(-0.023),
		7 => real(-0.040),
		8 => real(-0.049),
		9 => real(-0.040),
		10 => real(-0.010),
		11 => real(0.0031),
		12 => real(0.0065),
		13 => real(0.0069),
		14 => real(0.0032),
		15 => real(-0.037),
		16 => real(-0.106),
		17 => real(-0.134),
		18 => real(-0.088),
		19 => real(0.0025),
		20 => real(0.0159),
		21 => real(0.0238),
		22 => real(0.0194),
		23 => real(0.0013),
		24 => real(-0.242),
		25 => real(-0.443),
		26 => real(-0.442),
		27 => real(-0.142),
		28 => real(0.0450),
		29 => real(0.1203),
		30 => real(0.1899),
		31 => real(0.2317),
		32 => real(0.2317),
		33 => real(0.1899),
		34 => real(0.1203),
		35 => real(0.0450),
		36 => real(-0.142),
		37 => real(-0.442),
		38 => real(-0.443),
		39 => real(-0.242),
		40 => real(0.0013),
		41 => real(0.0194),
		42 => real(0.0238),
		43 => real(0.0159),
		44 => real(0.0025),
		45 => real(-0.088),
		46 => real(-0.134),
		47 => real(-0.106),
		48 => real(-0.037),
		49 => real(0.0032),
		50 => real(0.0069),
		51 => real(0.0065),
		52 => real(0.0031),
		53 => real(-0.010),
		54 => real(-0.040),
		55 => real(-0.049),
		56 => real(-0.040),
		57 => real(-0.023),
		58 => real(-0.007),
		59 => real(0.0004),
		60 => real(0.0007),
		61 => real(0.0006),
		62 => real(0.0003),
		63 => real(0.0001));
	
	constant REAL_POLY_MATRIX_FIR_1 : two_dim_array_of_real(COEFF_DEC_POLY_FIR_1-1 downto 0)(POLYPHASE_LEN_FIR_1-1 downto 0) 
								:= REAL_FIR_2_REAL_POLY_FILTER
								(REAL_COEFFS_FIR_1, ORDER_FIR_1, COEFF_DEC_POLY_FIR_1);
	
	constant REAL_POLY_MATRIX_in_DA_TABLES_FIR_1 : two_dim_array_of_real(COEFF_DEC_POLY_FIR_1-1 downto 0)(DA_TABLE_LEN_POLYPHASE_FIR_1-1  downto 0) 
								:= REAL_FIR_POLY_2_REAL_POLY_DA
								(REAL_POLY_MATRIX_FIR_1, POLYPHASE_LEN_FIR_1, COEFF_DEC_POLY_FIR_1);
	
	constant STD_POLY_MATRIX_in_DA_TABLES_FIR_1 : two_dim_array_of_stdv
													(COEFF_DEC_POLY_FIR_1-1 downto 0)				--second dimention
													(DA_TABLE_LEN_POLYPHASE_FIR_1-1  downto 0)		-- first dimention
													(OWL_FIR_1-1 downto 0)							-- std_logic_vector RANGE
													------------------------------
													:= REAL_POLY_DA_2_STD_POLY_DA(					-- Function
														REAL_POLY_MATRIX_in_DA_TABLES_FIR_1, 
														COEFF_DEC_POLY_FIR_1, 
														DA_TABLE_LEN_POLYPHASE_FIR_1, 
														OWL_FIR_1, 
														OFL_FIR_1);
														
	---------------------------------------------------------
	-- Coeffiisients for second Filter decimator
	---------------------------------------------------------												
	constant ORDER_FIR_2 					: NATURAL := 32;
	constant IWL_FIR_2 						: NATURAL := 16;
	constant OWL_FIR_2 						: NATURAL := 16;
	constant OFL_FIR_2						: NATURAL := 15;
	constant COEFF_DEC_POLY_FIR_2 			: NATURAL := 2;
	constant POLYPHASE_LEN_FIR_2 			: NATURAL := 16;--NUM_COEFFS_FIR_FILTR_1/ COEFF_DEC_POLY_1;
	constant DA_TABLE_LEN_POLYPHASE_FIR_2	: NATURAL := 2**(POLYPHASE_LEN_FIR_2-1);
	
	constant REAL_COEFFS_FIR_2 : one_dim_array_of_real(ORDER_FIR_2-1 downto 0) :=(
		0 => real(0.0008 ),
		1 => real(0.0023 ),
		2 => real(0.0006 ),
		3 => real(-0.0069),
		4 => real(-0.0100),
		5 => real(0.0025 ),
		6 => real(0.0147 ),
		7 => real(-0.0014),
		8 => real(-0.0268),
		9 => real(-0.0062),
		10 => real(0.0433 ),
		11 => real(0.0220 ),
		12 => real(-0.0734),
		13 => real(-0.0646),
		14 => real(0.1656 ),
		15 => real(0.4289 ),
		16 => real(0.4289 ),
		17 => real(0.1656 ),
		18 => real(-0.0646),
		19 => real(-0.0734),
		20 => real(0.0220 ),
		21 => real(0.0433 ),
		22 => real(-0.0062),
		23 => real(-0.0268),
		24 => real(-0.0014),
		25 => real(0.0147 ),
		26 => real(0.0025 ),
		27 => real(-0.0100),
		28 => real(-0.0069),
		29 => real(0.0006 ),
		30 => real(0.0023 ),
		31 => real(0.0008 ));
	
	constant REAL_POLY_MATRIX_FIR_2 : two_dim_array_of_real(COEFF_DEC_POLY_FIR_2-1 downto 0)(POLYPHASE_LEN_FIR_2-1 downto 0) 
								:= REAL_FIR_2_REAL_POLY_FILTER
								(REAL_COEFFS_FIR_2, ORDER_FIR_2, COEFF_DEC_POLY_FIR_2);
	
	constant REAL_POLY_MATRIX_in_DA_TABLES_FIR_2 : two_dim_array_of_real(COEFF_DEC_POLY_FIR_2-1 downto 0)(DA_TABLE_LEN_POLYPHASE_FIR_2-1  downto 0) 
								:= REAL_FIR_POLY_2_REAL_POLY_DA
								(REAL_POLY_MATRIX_FIR_2, POLYPHASE_LEN_FIR_2, COEFF_DEC_POLY_FIR_2);
	
	constant STD_POLY_MATRIX_in_DA_TABLES_FIR_2 : two_dim_array_of_stdv
													(COEFF_DEC_POLY_FIR_2-1 downto 0)				--second dimention
													(DA_TABLE_LEN_POLYPHASE_FIR_2-1  downto 0)		-- first dimention
													(OWL_FIR_2-1 downto 0)							-- std_logic_vector RANGE
													------------------------------
													:= REAL_POLY_DA_2_STD_POLY_DA(					-- Function
														REAL_POLY_MATRIX_in_DA_TABLES_FIR_2, 
														COEFF_DEC_POLY_FIR_2, 
														DA_TABLE_LEN_POLYPHASE_FIR_2, 
														OWL_FIR_2, 
														OFL_FIR_2);
	
	

end pkg_da_fir_constants;

package body pkg_da_fir_constants is
	

	

end pkg_da_fir_constants;