-------
-- shRec = '0' , reg shift
-- shRec = '1' , record input value to reg
-------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity shift_rg_with_parallel_record is 
	generic(
		IWL			: NATURAL := 16;
		shLeft		: BOOlEAN := FALSE);
	port(
		clk			: in 	std_logic;
		nrst		: in	std_logic;
		shRec		: in	std_logic;
		en 			: in 	std_logic;
		input_bit	: in 	std_logic;
		input_word 	: in	std_logic_vector(IWL-1 downto 0);
		output		: out	std_logic);
end shift_rg_with_parallel_record;

architecture rtl of shift_rg_with_parallel_record is
	signal reg : std_logic_vector(IWL-1 downto 0);
	signal tmp_out : std_logic;
begin

	
g0 : if not shLeft generate	
	rightShift:	process(clk)
	begin
		if rising_edge(clk) then 
			if nrst = '0' then 
				reg <= (others => '0');
				--tmp_out <= '0';
			else 
				if en  = '1' then 
					if shRec = '1' then
						reg <= input_word;
					else
						--tmp_out <= reg(0);
						reg <= input_bit & reg(reg'left downto 1);
					end if;
				end if;
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
				--tmp_out <= '0';
			else 
				if en  = '1' then 
					if shRec = '1' then
						reg <= input_word;
					else
						--tmp_out <= reg(N-1);
						reg <= reg(reg'left-1 downto 0) & input_bit;
					end if;
				end if;
			end if;
		end if;
	end process;
end generate;
	
	tmp_out <= reg(reg'left) when shLeft else reg(0);
	output <= tmp_out;
	
end rtl;