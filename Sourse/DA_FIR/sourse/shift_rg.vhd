library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity shift_rg is 
	generic(
		IWL		: NATURAL := 16;
		shLeft	: BOOlEAN := FALSE);
	port(
		clk		: in 	std_logic;
		en 		: in 	std_logic;
		nrst	: in	std_logic;
		input	: in	std_logic;
		output	: out	std_logic);
end shift_rg;

architecture rtl of shift_rg is
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
				if en = '1' then
					--tmp_out <= reg(0);
					reg <= input & reg(reg'left downto 1);
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
				if en = '1' then
					--tmp_out <= reg(N-1);
					reg <= reg(reg'left-1 downto 0) & input;
				end if;
			end if;
		end if;
	end process;
end generate;
	
	tmp_out <= reg(reg'left) when shLeft else reg(0);
	output <= tmp_out;
	
end rtl;