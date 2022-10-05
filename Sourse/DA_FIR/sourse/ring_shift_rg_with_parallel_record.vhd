-------------------------------------------
-- revers rst!!!
-- reset all unit whet rst = '0'
-- work when rst = '1'
-------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ring_shift_rg_with_parallel_record is 
	generic(
		IWL			: NATURAL := 16;
		shLeft		: BOOlEAN := FALSE);
	port(
		clk			: in 	std_logic;
		nrst		: in	std_logic;
		shR			: in	std_logic;
		input	 	: in	std_logic_vector(IWL-1 downto 0);
		cout		: out	std_logic;
		output		: out	std_logic_vector(IWL-1 downto 0));
end ring_shift_rg_with_parallel_record;

architecture rtl of ring_shift_rg_with_parallel_record is
	signal reg : std_logic_vector(IWL-1 downto 0);
	signal tem_cout : std_logic;
begin

	
g0 : if not shLeft generate	
	rightShift:	process(clk)
	begin
		if rising_edge(clk) then 
			if nrst = '0' then 
				reg <= (others => '0');
			else 
				if shR = '1' then
					reg <= input;
				else
					reg <= reg(reg'left-1 downto 0) & reg(reg'left);
				end if;
			end if;
		end if;
	end process;
	--temp_cout <= reg(reg'left);
end generate;
	
	
	
g1: if shLeft generate	
	leftShift:	process(clk)
	begin
		if rising_edge(clk) then 
			if nrst = '0' then 
				reg <= (others => '0');
			else 
				if shR = '1' then
					reg <= input;
				else
					reg <= reg(0) & reg(reg'left downto 1);
				end if;
			end if;
		end if;
	end process;
	--temp_cout <= reg(0);
end generate;
	
	cout <= reg(0) when shLeft else reg(reg'left);
	output <= reg;
	
end rtl;