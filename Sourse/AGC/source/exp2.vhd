library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_log_func.all;


entity exp2 is 
	generic(
		BITNESS 		: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		input_gain 	: in	std_logic_vector(BITNESS-1+5 downto 0);
		input_data	: in 	std_logic_vector(BITNESS-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1 downto 0))
end exp2;

architecture rtl of exp2 is

	component exp2_logic is 
	generic(
		IWL 		: NATURAL;
		IFL			: NATURAL);
	port(
		input 		: in	std_logic_vector(IWL-1 downto 0);
		out_id		: out	std_logic_vector(IFL-1 downto 0);
		out_shift	: out	std_logic_vector(IWL-IFL-1 downto 0));
	end component;

	component exp_table is 
	generic(
		BITNESS 		: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		adress 	: in	std_logic_vector(TABLE_LENGTH-1 downto 0);
		output_i	: out	std_logic_vector(BITNESS-1 downto 0);
		output_ip	: out	std_logic_vector(BITNESS-1 downto 0));
	end component;
	
	signal temp_in : std_logic_vector (BITNESS-1 downto 0);
	
	signal temp_gain : std_logic_vector (BITNESS-1+5 downto 0);
	
	signal temp_id :  std_logic_vector(BITNESS-1 downto 0);
	signal temp_adress :  std_logic_vector(TABLE_LENGTH-1 downto 0);
	signal temp_shift :  std_logic_vector(5-1 downto 0);
	
	signal tm_out_tab_1 : std_logic_vector(BITNESS-1 downto 0);
	signal tm_out_tab_2 : std_logic_vector(BITNESS-1 downto 0);
	
	signal mult : 	std_logic_vector(BITNESS*2-1 downto 0);
	signal pr_shifter :  std_logic_vector(BITNESS-1+TABLE_LENGTH downto 0);
	signal shifter :  std_logic_vector(BITNESS-1+TABLE_LENGTH downto 0);
	
	signal temp_out : std_logic_vector(BITNESS-1 downto 0);
begin
	temp_gein <= input_gain;
	
	temp_in <= input;
	
u1: exp2_logic 	generic map(BITNESS+5, BITNESS)
				port map(temp_in, temp_id, temp_shift);
	
	temp_adress <= temp_id(BITNESS-1 downto BITNESS-TABLE_LENGTH);
	
	
u2: exp_table	generic map(BITNESS, TABLE_LENGTH)
				port map(temp_adress, tm_out_tab_1, tm_out_tab_2);
			
	mult <= std_logic_vector(signed(temp_in) * signed(tm_out_tab_1));
	pr_shifter <= mult(mult'left-1  downto mult'left-BITNESS-1+TABLE_LENGTH);
	
	shifter <= pr_shifter sll to_integer(signed(temp_shift));
	
	dd: process(shifter)
	constant WL : NATURAL := shifter'left;
	variable v : signed(WL downto 0);
	variable sat_v : signed(WL-5 downto 0);
	begin
		sat_v := (others => '0');
		v := shifter;
		if (v(WL) /= v(WL-1))then 
			sat_v(WL-4) := v(WL);
			sat_v(WL-1-4 downto 0) := (OTHERS => v(WL-1));
		elsif (v(WL) /= v(WL-2)) then 
			sat_v(WL-4) := v(WL);
			sat_v(WL-1-4 downto 0) := (OTHERS => v(WL-2));
		elsif (v(WL) /= v(WL-3)) then 
			sat_v(WL-4) := v(WL);
			sat_v(WL-1-4 downto 0) := (OTHERS => v(WL-3));
		elsif (v(WL) /= v(WL-4)) then 
			sat_v(WL-4) := v(WL);
			sat_v(WL-1-4 downto 0) := (OTHERS => v(WL-4));
		elsif (v(WL) /= v(WL-5)) then 
			sat_v(WL-5) := v(WL);
			sat_v(WL-1-5 downto 0) := (OTHERS => v(WL-5));
		else
			sat_v := v(WL-4 downto 0);
		end if;
		temp_out <= std_logic_vector(sat_v(sat_v'left downto sat_v'left-BITNESS+1));
	end process;
	
	
	
			
	output <= 	temp_out;
	
	
	
	
end rtl;