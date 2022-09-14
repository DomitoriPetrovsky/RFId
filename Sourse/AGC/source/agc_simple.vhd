library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


LIBRARY WORK;
use work.pkg_log_func.all;


entity agc_simple is 
	generic(
		BITNESS : NATURAL);
	port(
		clk		: in	std_logic;
		wr_coef	: in 	std_logic;
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		R	 	: in 	std_logic_vector(BITNESS-1 downto 0);
		alfa 	: in 	std_logic_vector(BITNESS-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1 downto 0));
end agc_simple;

architecture rtl of agc_simple is

	signal temp_out 	: signed(BITNESS-1 downto 0)				:= (others => '0');
	signal squaer 		: signed(BITNESS*2-1 downto 0) 				:= (others => '0');
	signal after_squaer : signed(BITNESS-1 downto 0) 				:= (others => '0');
	
	signal rg_R			: signed(BITNESS-1 downto 0) 				:= (others => '0');
	signal rg_alfa 		: signed(BITNESS-1 downto 0) 				:= (others => '0');
	
	signal after_r		: signed(BITNESS-1 downto 0) 				:= (others => '0');

	signal after_a		: signed(BITNESS*2-1 downto 0) 				:= (others => '0');
	signal short_after_a: signed(BITNESS-1 downto 0) 				:= (others => '0');

	signal prev_summ 	: signed(BITNESS-1+4 downto 0) 				:= (others => '0');

	signal summ 		: signed(BITNESS-1+4 downto 0) 				:= (others => '0');
	signal delay 		: signed(BITNESS-1+4 downto 0) 				:= (others => '0');
	
	signal temp_in 		: signed(BITNESS-1 downto 0) 				:= (others => '0');
	
	signal temp 		: signed(temp_in'length+delay'length-1 downto 0)	:= (others => '0');

begin
	
	-------------------
	--input register
	-------------------
	process(clk)
	begin 
		if(rising_edge(clk)) then 
			temp_in <= signed(input);
		end if;
	end process;
	
	
	-------------------
	--writing coef R and Alfa
	-------------------
	process(clk)
	begin 
		if(rising_edge(clk)) then 
			if(wr_coef = '1') then
				rg_R <= signed(R);
				rg_alfa <= signed(alfa);
			end if;
		end if;
	end process;
	
	
	temp <= (temp_in * delay);
	
	-------------------
	--rouding results
	-------------------
	dd: process(temp)
	constant WL : NATURAL := temp'left;
	variable v : signed(WL downto 0);
	variable sat_v : signed(WL-4 downto 0);
	begin
		sat_v := (others => '0');
		v := temp;
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
		else
			sat_v := v(WL-4 downto 0);
		end if;
		temp_out <= sat_v(sat_v'left downto sat_v'left-BITNESS+1);
	end process;
	
	-------------------
	--calculate squere of signal
	-------------------
	squaer <= (signed(temp_out) * signed(temp_out)) sll 1;
	
	-------------------
	--truncation after mutl
	-------------------
	after_squaer <= squaer(squaer'left downto squaer'left-BITNESS+1); 
	
	-------------------
	--отличиет от уровня 
	-------------------
	after_r <= signed(rg_R) - after_squaer; 
	
	-------------------
	--домнажение на переменную формурующую постоянную времении системы
	-------------------
	after_a <= (signed(rg_alfa) * after_r) sll 1; 
	
	
	-------------------
	--truncation after mutl
	-------------------
	short_after_a <= after_a(after_a'left downto after_a'left-BITNESS+1);
	
	-------------------
	--extension of the sign
	-------------------
	prev_summ <= resize(short_after_a, prev_summ'length ); -- приводим к варианту для суммирования 18 разрядов

	-------------------
	--adder with overflow control 
	-------------------
add: process(delay, prev_summ)
	constant WL : NATURAL := delay'length;
	variable add_v : signed(WL downto 0);
	variable add_sat_v : signed(WL-1 downto 0);
	begin
		add_sat_v := (others => '0');
		add_v := resize(delay, WL+1) + resize(prev_summ, WL+1);
		if add_v(WL) /= add_v(WL-1) then
			add_sat_v(WL-1) := add_v(WL);
			add_sat_v(WL-2 downto 0) := (OTHERS => add_v(WL-1));
		else
			add_sat_v := add_v(WL-1 downto 0);
		end if;
		summ <= add_sat_v;
	
	end process;
	
	-------------------
	--accumulator 
	-------------------
z: process(clk)
	begin
		if(rising_edge(clk)) then
			delay <= summ;
		end if;
	end process;
	
	
	-------------------
	--result ;)
	-------------------
	output <= std_logic_vector(temp_out);
	
end rtl;