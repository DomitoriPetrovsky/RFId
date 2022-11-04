
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;

entity polyphase_clock_enable2_manager is 
	generic(
		DEC_COEF_1	: NATURAL;
		DEC_COEF_2	: NATURAL);
	port(
		clk			: in 	std_logic;
		ce_1		: out	std_logic;
		ce_2		: out	std_logic);
end polyphase_clock_enable2_manager;

architecture rtl of polyphase_clock_enable2_manager is

	constant len_1 : NATURAL := func_log2(DEC_COEF_1);
	constant rst_value_1 : unsigned := to_unsigned(integer(DEC_COEF_1-1),len_1);
	
	signal nrst_1 : std_logic;
	signal st_1 : std_logic;
	
	signal tmp_sum_1 :  unsigned(len_1-1  downto 0);
	signal sum_1 :  unsigned(len_1-1  downto 0) := (others => '0');
	signal temp_clk_enable_1 : std_logic := '0';
	
	
	
	constant dec_2 : NATURAL:= DEC_COEF_1*DEC_COEF_2; 
	constant len_2 : NATURAL := func_log2(dec_2);
	constant rst_value_2 : unsigned := to_unsigned(integer(dec_2-1),len_2);
	
	signal nrst_2 : std_logic;
	signal st_2 : std_logic;
	
	signal tmp_sum_2 :  unsigned(len_2-1  downto 0);
	signal sum_2 :  unsigned(len_2-1  downto 0) := (others => '0');
	signal temp_clk_enable_2 : std_logic := '0';
	
	
	
begin
	
	tmp_sum_1 <= sum_1  + 1;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if nrst_1 = '0' then 
				sum_1 <= (others => '0');
			else
				sum_1 <= tmp_sum_1;
			end if;
		end if;
	end process;

	nrst_1 <= '0' when sum_1 = rst_value_1 else '1';
	st_1 <= '1' when sum_1 = to_unsigned(INTEGER(NATURAL(0)),len_1) else '0';
	
	process(clk)
	begin
		if rising_edge(clk) then
			if st_1 = '1' then 
				temp_clk_enable_1 <= '1';
			else
				temp_clk_enable_1 <= '0';
			end if;
		end if;
	end process;
	
	ce_1 <= temp_clk_enable_1;

-----------------------------------------------------
	tmp_sum_2 <= sum_2  + 1;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if nrst_2 = '0' then 
				sum_2 <= (others => '0');
			else
				sum_2 <= tmp_sum_2;
			end if;
		end if;
	end process;

	nrst_2 <= '0' when sum_2 = rst_value_2 else '1';
	st_2 <= '1' when sum_2 = to_unsigned(INTEGER(NATURAL(0)),len_2) else '0';
	
	process(clk)
	begin
		if rising_edge(clk) then
			if st_2 = '1' then 
				temp_clk_enable_2 <= '1';
			else
				temp_clk_enable_2 <= '0';
			end if;
		end if;
	end process;
	
	ce_2 <= temp_clk_enable_2;




end rtl;