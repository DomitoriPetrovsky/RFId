library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

-- LIBRARY WORK;
-- use work.pkg_da_fir_constants.all;


package pkg_da_fir_types_func is
	
	--constant OWL_FIR1 :  NATURAL := 8;
	
	-- (NUM_COEFFS_FIR_FILTR_1-1 downto 0)
	type one_dim_array_of_real is array (NATURAL range <>) of REAL; 
	--(COEFF_DEC_POLY_1-1 downto 0)(NUM_COEFFS_FIR_FILTR_1/COEFF_DEC_POLY_1 -1  downto 0)
	type two_dim_array_of_real is array (NATURAL range <>) of one_dim_array_of_real;
	--(COEFF_DEC_POLY_1-1 downto 0)((NUM_COEFFS_FIR_FILTR_1/COEFF_DEC_POLY_1-1)**2-1  downto 0)
	type real_coeffs_poly_filtr is array (NATURAL range <>, NATURAL range <>) of REAL;
	
	
	type one_dim_array_of_stdv is array (NATURAL range <>) of std_logic_vector;
	type two_dim_array_of_stdv is array (NATURAL range <>) of one_dim_array_of_stdv;
	
	-- type std_coeffs_fir_filtr is array (NATURAL range <>) of std_logic_vector(OWL_FIR1-1 downto 0);
	-- type std_coeffs_poly_filtr is array (NATURAL range <>, NATURAL range <>) of std_logic_vector(OWL_FIR1-1 downto 0);
	
	
	
	function  REAL_FIR_2_REAL_POLY_FILTER (in_mas : one_dim_array_of_real; len : NATURAL; DEC_COEFF :  NATURAL)
	return two_dim_array_of_real;
	
	function  REAL_FIR_POLY_2_REAL_POLY_DA (in_mas : two_dim_array_of_real; len_sub : NATURAL; DEC_COEFF :  NATURAL)
	return two_dim_array_of_real;
	
	function  REAL_POLY_DA_2_STD_POLY_DA (in_mas : two_dim_array_of_real; DEC_COEFF :  NATURAL; DA_LEN :  NATURAL; OWL : NATURAL; OFL : NATURAL)
	return two_dim_array_of_stdv;
	
	function func_log2 (a  : NATURAL) 
	return NATURAL;
	
	
	
	
	
	-- function  REAL_H_2_REAL_DA_TABLE (in_mas : real_mas; len : NATURAL)
	-- return real_mas;
	
	--так во первых нужен тип данный для передачи в полифазный 
	-- нужен тип данных для передачи в каждый из фильтров 
	-- по итогу перваый тип двумерный массив std_logic_vector
	-- второй тип одномерный массив std_logic_vector
	
	-- так же для этого всего потребуется массив real для начальных коэффициентов 
	--далее двумерный массив real для коэффициентов каждого субфильтра
	--а уж после по каждому субфильтру согластно разрядности выходной и его порядку формируем таблицу 
	
	

end pkg_da_fir_types_func;

package body pkg_da_fir_types_func is
	
	function  REAL_FIR_2_REAL_POLY_FILTER (in_mas : one_dim_array_of_real; len : NATURAL; DEC_COEFF :  NATURAL)
	return two_dim_array_of_real is
	
		
		constant real_len : real := real(INTEGER(len));
		constant real_DEC : real := real(INTEGER(DEC_COEFF));
		
		constant real_subFilterLen :  real := real_len/real_DEC;
		
		constant subFilterLen : NATURAL := NATURAL(integer(real_subFilterLen));
		variable ret : two_dim_array_of_real (DEC_COEFF-1 downto 0)(subFilterLen-1 downto 0) ;
	begin 
		for i in 0 to subFilterLen-1 loop
			for j in 0 to DEC_COEFF-1 loop
			
				ret(j)(i) := in_mas(i*DEC_COEFF + j);
			
			end loop;
		end loop;
		return ret;
	end function;
	
	
	
	function  REAL_FIR_POLY_2_REAL_POLY_DA (in_mas : two_dim_array_of_real; len_sub : NATURAL; DEC_COEFF :  NATURAL)
	return two_dim_array_of_real is
	
		constant table_len : NATURAL := 2**(len_sub-1);
		
		variable count :  unsigned(len_sub-1 downto 0);
		
		variable summ :  real;
		
		variable ret : two_dim_array_of_real (DEC_COEFF-1 downto 0)(table_len-1 downto 0) ;
	begin 
		for i in 0 to DEC_COEFF-1 loop
		
		count := (others => '0');
		
			for j in 0 to table_len-1 loop
			
				summ := real(0);
				
				for k in 0 to len_sub-1 loop
					if count(k) = '0' then 
						summ := summ - in_mas(i)(len_sub-1-k);
					else 
						summ := summ + in_mas(i)(len_sub-1-k);
					end if;
				end loop;
				count := count + 1;
				ret(i)(j) := summ/real(2);
			end loop;
		end loop;
		return ret;
	end function;
	
	
	function  REAL_POLY_DA_2_STD_POLY_DA (in_mas : two_dim_array_of_real; DEC_COEFF :  NATURAL; DA_LEN :  NATURAL; OWL : NATURAL; OFL : NATURAL)
	return two_dim_array_of_stdv is
	
		variable ret : two_dim_array_of_stdv(DEC_COEFF-1 downto 0)(DA_LEN-1 downto 0 )(OWL-1 downto 0);
	
	begin 
		for i in 0 to DEC_COEFF-1 loop
			for j in 0 to DA_LEN-1 loop
				ret(i)(j) := std_logic_vector(to_signed(INTEGER(ROUND(in_mas(i)(j)*real(2**OFL))), OWL));
			end loop;
		end loop;
		return ret;
	end function;

	function func_log2 (a  : NATURAL) 
	return NATURAL is
		variable l : REAL;
		variable r : REAL;
		variable t : REAL;
		variable res : NATURAL;
	begin 
		l := LOG2(REAL(a));
		r := CEIL(l);
		if (r = l) then 
			res := NATURAL(INTEGER(r));
		else
			res := NATURAL(INTEGER(r)) + 1;
		end if;
		
		return res;
	
	end function func_log2;
	
	

end pkg_da_fir_types_func;