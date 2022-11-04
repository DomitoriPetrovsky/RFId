library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;


package pkg_test is
	
	constant BITNESS   : NATURAL := 16;
	constant TABLE_LEN : NATURAL := 3;
	
	type test_data is array (NATURAL range <>, NATURAL range <> ) of std_logic;
	
	type test_data_2 is array (NATURAL range <>) of std_logic_vector(NATURAL range <>);


end pkg_test;

package body pkg_test is

	

end pkg_test;