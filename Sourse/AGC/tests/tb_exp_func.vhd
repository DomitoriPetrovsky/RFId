library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_exp_func is 
end tb_exp_func;

architecture rtl of tb_exp_func is

constant table_len : natural := 7; 

signal test : return_data(0 to 2**table_len-1);


begin


	test <= formation_exp_table(table_len);

	
end rtl;