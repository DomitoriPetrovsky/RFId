library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_log_func.all;


entity exp2_logic is 
	generic(
		IWL 		: NATURAL;
		IFL			: NATURAL);
	port(
		input 		: in	std_logic_vector(IWL-1 downto 0);
		out_id		: out	std_logic_vector(IFL-1 downto 0);
		out_shift	: out	std_logic_vector(IWL-IFL-1 downto 0));
end exp2_logic;

architecture rtl of exp2_logic is

signal temp_id : std_logic_vector(IFL-1 downto 0);
--signal temp_id_n : std_logic_vector(IFL-1 downto 0);

signal temp_shift_p : std_logic_vector(IWL-IFL-1 downto 0);
signal temp_shift_n : std_logic_vector(IWL-IFL-1 downto 0);


begin
	
	temp_shift_p <= input(IWL-1 downto IFL);
	temp_id <= input(IFL-1 downto 0);

	temp_shift_n <= std_logic_vector(signed(input(IWL-1 downto IFL)) - 1 );
	--temp_id_n <= '0' & input(IFL-1 downto 0);
	
	
	--out_id <= temp_id_p when input(IWL-1) = '0' else temp_id_n;
	out_shift <= temp_shift_p when input(IWL-1) = '0' else temp_shift_n;
	out_id <= temp_id;
	
end rtl;