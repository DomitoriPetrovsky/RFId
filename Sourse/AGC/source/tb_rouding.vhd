library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;

library STD;
use std.textio.all;


entity tb_rouding is 
end tb_rouding;

architecture rtl of tb_rouding is

 
constant bitness	: natural := 4;

signal temp 	: std_logic_vector(bitness*2-1 downto 0) := (others => '0');
signal temp_out : std_logic_vector(bitness-1 downto 0) := (others => '0');
signal temp_out2 : std_logic_vector(bitness-1 downto 0) := (others => '0');

signal s : std_logic_vector(bitness-1 downto 0) := (others => '0');
--signal s2 : std_logic_vector(bitness-1 downto 0) := (others => '0');
signal pl : unsigned(bitness-1 downto 0) := (others => '0');
signal mn : unsigned(bitness-1 downto 0) := (others => '1');


signal p, n : std_logic;
begin
	
	
	process
	begin
		temp <= "00001010";
		wait for 10 ns;
		temp <= "11110011";
		wait for 10 ns;
		temp <= "00011000";
		wait for 10 ns;
		temp <= "11011111";
		wait for 10 ns;
		temp <= "00010000";
		wait for 10 ns;
		temp <= "11111111";
		wait for 10 ns;
		temp <= "11001111";
		wait for 10 ns;
		temp <= "00111111";
		wait ;
		
	end process;
	
	temp_out2 <= std_logic_vector(resize(signed(temp), BITNESS));
	s <= temp(temp'high downto temp'high-(BITNESS-1));
	p <= s(0) or s(1) or s(2) or s(3);
	n <= s(0) and s(1) and s(2) and s(3);
	
	ou:	process(temp)
	
	begin
	
		
		
		--p <= all_or(s);
		--n <= all_and(s);
		
		
		 if((s(0) or s(1) or s(2) or s(3)) = '0'  or  (s(0) and s(1) and s(2) and s(3) ) = '1')then
		
			temp_out <= temp(temp'high) & temp(temp'high-BITNESS downto temp'high-2*BITNESS+2); -- было не +2 а -1, получилось 19 хммм
		
		 else
			if temp(temp'high) = '1' then
				temp_out <= (others => '0'); 
				temp_out(temp_out'high) <= temp(temp'high);
			else
				temp_out <= (others => '1'); 
				temp_out(temp_out'high) <= temp(temp'high);
			end if;
		 end if;
	
	end process;

	
end rtl;