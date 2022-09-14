library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


LIBRARY WORK;
use work.pkg_log_func.all;


entity agc_log is 
	generic(
		BITNESS : NATURAL;
		IIR_WCL : NATURAL;
		TABLE_LENGTH : NATURAL);
	port(
		clk		: in	std_logic;
		wr_coef	: in 	std_logic;
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		R	 	: in 	std_logic_vector(BITNESS-1 downto 0);
		alfa 	: in 	std_logic_vector(BITNESS-1 downto 0);
		iir_coef: in 	std_logic_vector(IIR_WCL-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1 downto 0));
end agc_log;

architecture rtl of agc_log is

	entity exp2 is 
	generic(
		BITNESS 		: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		input_gain 	: in	std_logic_vector(BITNESS-1+5 downto 0);
		input_data	: in 	std_logic_vector(BITNESS-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1 downto 0))
	end exp2;
	
	entity iir_filter_exp_averaging is 
	generic(
		BITNESS 	: NATURAL;
		CWL			: NATURAL);
	port(
		clk			: in	std_logic;
		coef		: in	std_logic_vector(CWL-1 downto 0);
		input 		: in	std_logic_vector(BITNESS-1 downto 0);
		output		: out	std_logic_vector(BITNESS-1 downto 0));
	end iir_filter_exp_averaging;

	entity log2 is 
	generic(
		BITNESS 		: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1+5 downto 0));
	end log2;


	signal temp_out 	: std_logic_vector(BITNESS-1 downto 0)				:= (others => '0');
	signal squaer 		: signed(BITNESS*2-1 downto 0) 				:= (others => '0');
	signal after_squaer : signed(BITNESS-1 downto 0) 				:= (others => '0');
	
	signal iir_filter	: signed(BITNESS-1 downto 0)				:= (others => '0');
	
	signal after_log	: signed(BITNESS-1+5 downto 0)				:= (others => '0');
	
	signal rg_R			: signed(BITNESS-1+5 downto 0) 				:= (others => '0');
	signal rg_alfa 		: signed(BITNESS-1+5 downto 0) 				:= (others => '0');
	
	signal after_r		: signed(BITNESS-1+5 downto 0) 				:= (others => '0');

	signal after_a		: signed(after_r'length+rg_alfa'length-1 downto 0) 				:= (others => '0');
	signal short_after_a: signed(BITNESS-1+5 downto 0) 				:= (others => '0');

	signal prev_summ 	: signed(BITNESS-1+5 downto 0) 				:= (others => '0');

	signal summ 		: signed(BITNESS-1+5 downto 0) 				:= (others => '0');
	signal delay 		: signed(BITNESS-1+5 downto 0) 				:= (others => '0');
	
	signal temp_in 		: std_logic_vector(BITNESS-1 downto 0) 				:= (others => '0');
	
	signal temp 		: signed(temp_in'length+delay'length-1 downto 0)	:= (others => '0');

begin
	
	-------------------
	--input register
	-------------------
	process(clk)
	begin 
		if(rising_edge(clk)) then 
			temp_in <= input;
		end if;
	end process;
	
	
	-------------------
	--writing coef R and Alfa
	-------------------
	process(clk)
	begin 
		if(rising_edge(clk)) then 
			if(wr_coef = '1') then
				rg_R <= resize(signed(R), rg_R'length);
				rg_alfa <= resize(signed(alfa), rg_alfa'length);
			end if;
		end if;
	end process;
	
	-------------------
	--anti-log
	-------------------
exp: exp2	generic map(BITNESS, TABLE_LENGTH)
			port map(delay, temp_in, temp_out);
	
	
	-------------------
	--calculate squere of signal
	-------------------
	squaer <= (signed(temp_out) * signed(temp_out)) sll 1;
	
	-------------------
	--truncation after mutl
	-------------------
	after_squaer <= squaer(squaer'left downto squaer'left-BITNESS+1); 
	
	-------------------
	--iir filter
	-------------------
iir: iir_filter_exp_averaging 	generic map(BITNESS, IIR_WCL)
								port map(clk,iir_coef, after_squaer, iir_filter);
	
	
	-------------------
	--table log2
	-------------------
log: log2 	generic map(BITNESS, TABLE_LENGTH)
			port map(iir_filter, after_log);
	
	-------------------
	--отличиет от уровня 
	-------------------
	after_r <= signed(rg_R) - signed(after_log); 
	
	-------------------
	--домнажение на переменную формурующую постоянную времении системы
	-------------------
	after_a <= (signed(rg_alfa) * after_r) sll 1; 
	
	
	-------------------
	--truncation after mutl
	-------------------
	short_after_a <= after_a(after_a'left downto after_a'left-(BITNESS-1+5));
	
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