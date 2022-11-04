
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;

entity polyphase_clock_enable_manager is 
	generic(
		DEC_COEF	: NATURAL);
	port(
		clk			: in 	std_logic;
		ce			: out	std_logic);
end polyphase_clock_enable_manager;

architecture rtl of polyphase_clock_enable_manager is

	constant len : NATURAL := func_log2(DEC_COEF);
	constant rst_value : unsigned := to_unsigned(integer(DEC_COEF-1),len);
	
	signal nrst : std_logic;
	signal st : std_logic;
	
	signal tmp_sum :  unsigned(len-1  downto 0);
	signal sum :  unsigned(len-1  downto 0) := (others => '0');
	signal temp_clk_enable : std_logic := '0';
begin
	
	tmp_sum <= sum  + 1;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if nrst = '0' then 
				sum <= (others => '0');
			else
				sum <= tmp_sum;
			end if;
		end if;
	end process;

	nrst <= '0' when sum = rst_value else '1';
	st <= '1' when sum = to_unsigned(INTEGER(NATURAL(0)),len) else '0';
	
	process(clk)
	begin
		if rising_edge(clk) then
			if st = '1' then 
				temp_clk_enable <= '1';
			else
				temp_clk_enable <= '0';
			end if;
		end if;
	end process;
	
	ce <= temp_clk_enable;

end rtl;