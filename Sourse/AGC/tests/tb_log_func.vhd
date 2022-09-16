library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_log_func is 
end tb_log_func;

architecture rtl of tb_log_func is

constant table_len 	: natural := 7; 
constant bitness 	: natural := 8; 
signal test : return_data(0 to 2**table_len-1);


begin


	test <= formation_log_table(table_len, bitness);

	
end rtl;