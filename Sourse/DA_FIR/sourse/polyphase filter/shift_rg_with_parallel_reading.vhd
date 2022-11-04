-------
-- shRec = '0' , reg shift
-- shRec = '1' , record input value to reg
-------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity shift_rg_with_parallel_reading is 
	generic(
		OWL			: NATURAL;
		shLeft		: BOOlEAN);
	port(
		clk			: in 	std_logic;
		nrst		: in	std_logic;
		input_bit	: in 	std_logic;
		out_word 	: out	std_logic_vector(OWL-1 downto 0);
		output		: out	std_logic);
end shift_rg_with_parallel_reading;

architecture rtl of shift_rg_with_parallel_reading is
	signal reg : std_logic_vector(OWL-1 downto 0);
	signal tmp_out : std_logic;
begin

	
g0 : if not shLeft generate	
	rightShift:	process(clk)
	begin
		if rising_edge(clk) then 
			if nrst = '0' then 
				reg <= (others => '0');
			else 
				reg <= input_bit & reg(reg'left downto 1);
			end if;
		end if;
	end process;
end generate;
	
	
g1: if shLeft generate	
	leftShift:	process(clk)
	begin
		if rising_edge(clk) then 
			if nrst = '0' then 
				reg <= (others => '0');
			else 
				reg <= reg(reg'left-1 downto 0) & input_bit;
			end if;
		end if;
	end process;
end generate;
	
	out_word <= reg;
	tmp_out <= reg(reg'left) when shLeft else reg(0);
	output <= tmp_out;
	
end rtl;