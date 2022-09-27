
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity counter is 
	generic(
		IWL			: NATURAL := 16);
	port(
		clk			: in 	std_logic;
		nrst		: in	std_logic;
		rst_level	: in 	std_logic_vector(IWL-1 downto 0);
		output		: out	std_logic_vector(IWL-1 downto 0));
end counter;

architecture rtl of counter is

	signal 	count 		: unsigned(IWL-1  downto 0);
	signal 	temp_out	: std_logic_vector(IWL-1 downto 0);
begin
	
	count <= unsigned(temp_out) + 1;
		
g0: process(clk)
	begin 
		if rising_edge(clk) then
			if nrst = '0' then 
				temp_out <= (others => '0');
			else
				if temp_out = rst_level then 
					temp_out <= (others => '0');
				else 
					temp_out <= std_logic_vector(count);
				end if;
			end if;
		end if;
	end process;

	output <= temp_out;
	
end rtl;