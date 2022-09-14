library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;


package pkg_log_func is
	
	constant BITNESS   : NATURAL := 16;
	constant TABLE_LEN : NATURAL := 3;
	type return_data is array (natural range <>) of std_logic_vector(BITNESS-1 downto 0);
	
	
	
	function  formation_log_table (log_table_len : natural)
	return return_data;
	
	function  formation_exp_table (exp_table_len : natural)
	return return_data;

	function all_or (a  : std_logic_vector) 
	return boolean;
	
	function all_and (a  : std_logic_vector)
	return boolean;

end pkg_log_func;

package body pkg_log_func is

	function formation_log_table (log_table_len : NATURAL,  BITNESS : NATURAL)
	return return_data is
	
	variable output	: 	return_data(0 to 2**log_table_len-1 );
	variable step 	:	real;
	variable x		:	real := real(1);
	variable y		:	real;
	begin 
		step := real(1) / real(2**log_table_len);
		
		for I in 0 to 2**log_table_len-1 loop
		
			y := LOG2(x);
			x := x + step;
			y := y * real(2**(BITNESS-1));
			
			output(I) :=std_logic_vector(to_signed(integer(ROUND(y)), BITNESS));
	
		end loop;
	
	return output;
	end function formation_log_table;


	function formation_exp_table (exp_table_len : natural) return return_data is
		variable output	: 	return_data(0 to 2**exp_table_len-1 );
		variable step 	:	real;
		variable x		:	real := real(0);
		variable y		:	real;
		variable temp0	:	real;
		variable temp1	:	integer;
		variable temp2	:	unsigned(BITNESS-1 downto 0);
		variable temp3	:	std_logic_vector(BITNESS-1 downto 0);
	begin 
		step := real(1) / real(2**exp_table_len);
		
		for I in 0 to 2**exp_table_len-1 loop
		
			y := 2**x;
			x := x + step;
			y := y * real(2**(BITNESS-1));
			
			temp0 := ROUND(y);
			
			temp1 := integer(temp0);
			
			temp2 := to_unsigned(temp1, 16);
			
			temp3 := std_logic_vector(temp2);
			
			output(I) := temp3;
			
		end loop;
	
	return output;
	
	end function formation_exp_table;
	
	
	
	function all_or (a  : std_logic_vector) return boolean is
		variable output	: 	boolean;
		variable temp : std_logic;
	begin 
		temp := '0';
		output := FALSE;
		for I in a'left downto 0 loop
		
			temp := a(I) or temp; 
			
		end loop;
	
		if temp = '0' then 
		
			output := TRUE;
		
		end if;
		
	return output;
	
	end function all_or;
	
	
	
	function all_and (a  : std_logic_vector) return boolean is
		variable output	: 	boolean;
		variable temp : std_logic;
	begin 
		temp := '1';
		output := FALSE;
		for I in a'left downto 0 loop
		
			temp := a(I) and temp; 
			
		end loop;
	
		if temp = '1' then 
		
			output := TRUE;
		
		end if;
		
	return output;
	
	end function all_and;

end pkg_log_func;