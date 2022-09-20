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
		--reset	: in	std_logic;
		--en		: in	std_logic;
		clk		: in	std_logic;
		wr_coef	: in 	std_logic;
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		R	 	: in 	std_logic_vector(BITNESS-1 downto 0);
		alfa 	: in 	std_logic_vector(BITNESS-1 downto 0);
		iir_coef: in 	std_logic_vector(IIR_WCL-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1 downto 0));
end agc_log;

architecture rtl of agc_log is

	component   exp2 is 
	generic(
		BITNESS 		: NATURAL;
		DIWL			: NATURAL;
		DIFL			: NATURAL;
		GIWL			: NATURAL;
		GIFL			: NATURAL;
		OWL				: NATURAL;
		OFL				: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		input_gain 	: in	std_logic_vector(GIWL-1 downto 0);
		input_data	: in 	std_logic_vector(DIWL-1 downto 0);
		output		: out	std_logic_vector(OWL-1 downto 0));
	end component;
	
	component iir_filter_exp_averaging is 
	generic(
		BITNESS 	: NATURAL;
		CWL			: NATURAL);
	port(
		clk			: in	std_logic;
		coef		: in	std_logic_vector(CWL-1 downto 0);
		input 		: in	std_logic_vector(BITNESS-1 downto 0);
		output		: out	std_logic_vector(BITNESS-1 downto 0));
	end component;

	component log2 is 
	generic(
		BITNESS 		: NATURAL := 16;
		IWL				: NATURAL := 16;
		IFL				: NATURAL := 15;
		OWL				: NATURAL := 20;
		OFL				: NATURAL := 15;
		TABLE_LENGTH	: NATURAL := 7);
	port(
		input 	: in	std_logic_vector(IWL-1 downto 0);
		output	: out	std_logic_vector(OWL-1 downto 0));
	end component;

	component add_sgn_sat IS
	GENERIC(
		IWL : natural;
		sub : boolean
		);
	PORT(
		A : IN STD_LOGIC_VECTOR(IWL-1 downto 0);
		B : IN STD_LOGIC_VECTOR(IWL-1 downto 0);
		C : OUT STD_LOGIC_VECTOR(IWL-1 downto 0)
		);
	end component;

	constant LogWL: NATURAL:= log_len(BITNESS);


	signal temp_out 	: std_logic_vector(BITNESS-1 downto 0)				:= (others => '0');
	signal squaer 		: signed(BITNESS*2-1 downto 0) 				:= (others => '0');
	signal after_squaer : signed(BITNESS-1 downto 0) 				:= (others => '0');
	
	signal iir_filter	: std_logic_vector(BITNESS-1 downto 0)				:= (others => '0');
	
	signal after_log	: std_logic_vector(LogWL-1 downto 0)				:= (others => '0');
	
	signal rg_R			: std_logic_vector(LogWL-1 downto 0) 				:= (others => '0');
	signal rg_alfa 		: signed(BITNESS-1 downto 0) 				:= (others => '0');
	
	signal after_r		: std_logic_vector(LogWL-1 downto 0) 				:= (others => '0');

	signal after_a		: signed(after_r'length+rg_alfa'length-1 downto 0) 				:= (others => '0');
	signal short_after_a: std_logic_vector(LogWL-1 downto 0) 				:= (others => '0');

	--signal prev_summ 	: signed(LogWL-1 downto 0) 				:= (others => '0');

	signal summ 		: std_logic_vector(LogWL-1 downto 0) 				:= (others => '0');
	signal delay 		: std_logic_vector(LogWL-1 downto 0) 				:= (others => '0');
	
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
				rg_R <= std_logic_vector(resize(signed(R), rg_R'length) sll 4);
				rg_alfa <= resize(signed(alfa), rg_alfa'length);
			end if;
		end if;
	end process;
	
	-------------------
	--anti-log
	-------------------
exp: exp2	generic map(BITNESS => BITNESS,
						DIWL => BITNESS,
						DIFL => BITNESS-1,
						GIWL => LogWL,
						GIFL => BITNESS-1,
						OWL  => BITNESS,
						OFL  => BITNESS-1,
						TABLE_LENGTH => TABLE_LENGTH)
			port map(	input_gain => delay, 
						input_data => temp_in, 
						output => temp_out);
	
	
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
iir: iir_filter_exp_averaging 	generic map(BITNESS => BITNESS,
											CWL => IIR_WCL)
								port map(	clk => clk,
											coef => iir_coef, 
											input => std_logic_vector(after_squaer), 
											output => iir_filter);
	
	
	-------------------
	--table log2
	-------------------
log: log2 	generic map(BITNESS => BITNESS,
						IWL => BITNESS,
						IFL => BITNESS-1,
						OWL => LogWL,
						OFL => BITNESS-1,
						TABLE_LENGTH => TABLE_LENGTH)
			port map(	input => iir_filter, 
						output => after_log);
	
	-------------------
	--отличиет от уровня 
	-------------------
subR: add_sgn_sat 	generic map(IWL => LogWL, 
								sub => TRUE)
					port map(A => rg_R,
							 B => after_log,
							 C => after_r);
	--after_r <= signed(rg_R) - signed(after_log); 
	
	-------------------
	--домнажение на переменную формурующую постоянную времении системы
	-------------------
	after_a <= (signed(rg_alfa) * signed(after_r)) sll 1; 
	
	
	-------------------
	--truncation after mutl
	-------------------
	short_after_a <= std_logic_vector(after_a(after_a'left downto after_a'left-(LogWL-1)));
	
	-------------------
	--extension of the sign
	-------------------
	--prev_summ <= resize(short_after_a, prev_summ'length ); -- приводим к варианту для суммирования 18 разрядов

	-------------------
	--adder with overflow control 
	-------------------
addA: add_sgn_sat 	generic map(IWL => LogWL, 
								sub => FALSE)
					port map(A => delay,
							 B => short_after_a,
							 C => summ);

	
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