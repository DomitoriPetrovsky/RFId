
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity control_unit_fir_da_iter is 
	generic(
		ICL		: NATURAL := 5);
	port(
		clk		: in 	std_logic;
		nrst	: in	std_logic;
		counter	: in 	std_logic_vector(ICL-1 downto 0);
		count_nrst : out std_logic;
		rg_nrst	: out	std_logic;
		done	: out 	std_logic;
		add_sub	: out 	std_logic;
		shR		: out 	std_logic);
end control_unit_fir_da_iter;

architecture rtl of control_unit_fir_da_iter is


begin
	
	
g0: process(clk)
	constant sub : std_logic_vector(ICL-1 downto 0) := std_logic_vector(to_unsigned(2**(ICL-1), ICL));
	constant zero : std_logic_vector(ICL-1 downto 0) := (others => '0');
	constant one : std_logic_vector(ICL-1 downto 0) := std_logic_vector(to_unsigned(1, ICL));
	
	variable count :  natural ;
	
	begin
		if rising_edge(clk) then 
			if nrst = '0' then 
				count := 0;
				rg_nrst <= '0';
				done 	<= '0';
				shR 	<= '0';
				add_sub <= '0';
			else 
				if count = 0 then 
					done 	<= '1';
					rg_nrst <= '0';
					shR 	<= '1';
					count := count + 1;
				elsif count = 1 then
					rg_nrst <= '1';
					shR 	<= '0';
					add_sub	<= '0';
					done 	<= '0';
					count := count + 1;
					
				elsif count = 2**(ICL-1) then		
					add_sub <= '1';
					count := 0; 
				else 
					done 	<= '0';
					rg_nrst <= '1';
					add_sub <= '0';
					shR 	<= '0';
					count := count + 1;
				end if;
			end if;
		end if;
	
	end process;
	
	
end rtl;