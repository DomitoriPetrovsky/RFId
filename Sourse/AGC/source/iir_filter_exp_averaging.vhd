library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;


entity iir_filter_exp_averaging is 
	generic(
		BITNESS 	: NATURAL;
		CWL			: NATURAL);
	port(
		clk			: in	std_logic;
		coef		: in	std_logic_vector(CWL-1 downto 0);
		input 		: in	std_logic_vector(BITNESS-1 downto 0);
		output		: out	std_logic_vector(BITNESS-1 downto 0));
end iir_filter_exp_averaging;

architecture rtl of iir_filter_exp_averaging is
	
	signal shift_1 :  signed(BITNESS-1 downto 0) := (others => '0');
	signal shift_2 :  signed(BITNESS-1 downto 0) := (others => '0');
	
	signal tmp_out	: std_logic_vector(BITNESS-1 downto 0) := (others => '0');
	signal delay	: signed(BITNESS-1 downto 0) := (others => '0');
	
	
	signal sum_1	: signed(BITNESS-1 downto 0) := (others => '0');
	signal sum_2	: signed(BITNESS-1 downto 0) := (others => '0');
	
begin
------------------------------------------------------
--shift 1
------------------------------------------------------

	shift_1 <= signed(input) srl to_integer(unsigned(coef));

------------------------------------------------------
--shift 2
------------------------------------------------------
	shift_2 <=  delay srl to_integer(unsigned(coef));


u2: process(clk)
	begin 
		if rising_edge(clk) then 
		
			delay <= sum_1;
		
		end if;
	
	end process;
	
	sum_2 <= delay - shift_2;
	sum_1 <= sum_2 + shift_1;
	
	output <= std_logic_vector(sum_1);
	
	
end rtl;