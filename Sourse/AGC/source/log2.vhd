-- log with dop accuracy

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_log_func.all;


entity log2 is 
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
end log2;

architecture rtl of log2 is

	component log_table is 
		generic(
			BITNESS 		: NATURAL;
			TABLE_LENGTH	: NATURAL);
		port(
			adress 		: in	std_logic_vector(TABLE_LENGTH-1 downto 0);
			output_i	: out	std_logic_vector(BITNESS-1 downto 0);
			output_ip	: out	std_logic_vector(BITNESS-1 downto 0));
	end component;
	
	component  logic is 
	generic(
		BITNESS 	: NATURAL;
		n_size 		: NATURAL);
	port(
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		out_x	: out	std_logic_vector(BITNESS-1 downto 0);
		out_n	: out	std_logic_vector(n_size-1 downto 0));
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
	
constant n_size		: 	NATURAL := OWL-OFL;

signal n 			:  	std_logic_vector(n_size-1 downto 0) 		:= (others => '0');
signal x 			:	std_logic_vector(IWL-1 downto 0) 		:= (others => '0');
signal hight 		: 	unsigned((IWL/2)-1 downto 0) 			:= (others => '0');
signal I 			: 	std_logic_vector((IWL/2)-1 downto 0) 	:= (others => '0');
signal r 			: 	unsigned((IWL/2)-1 downto 0) 			:= (others => '0');	

signal table_log 	:	std_logic_vector(IWL-1 downto 0) 		:= (others => '0');
signal table_logp 	:	std_logic_vector(IWL-1 downto 0) 		:= (others => '0');

signal dif_table	:	std_logic_vector(IWL-1 downto 0) 					:= (others => '0');

signal accuracy		:	signed(dif_table'length+r'length-1 downto 0) 		:= (others => '0');

signal rouding_acc	:	signed(IWL-1 downto 0) 					:= (others => '0');

signal log_mant		: 	signed(IWL-1 downto 0);

signal temp_out  	:	std_logic_vector(OWL-1 downto 0) 			:= (others => '0');

begin
	
u1: logic 	generic map(BITNESS, n_size)
			port map(input, x, n);

	hight 	<= unsigned(x(x'left downto x'length/2));
	r 		<= unsigned(x((x'length/2)-1 downto 0));
	I 		<= std_logic_vector(hight - (2**TABLE_LENGTH) );

u2: log_table 	generic map(BITNESS, TABLE_LENGTH)
				port map(I( I'high-1 downto 0), table_log, table_logp);
	
	
add1: add_sgn_sat 	generic map(IWL => IWL, sub => true )	
					port map(A => table_log,
							B => table_logp, 
							C => dif_table);
					
	--dif_table <= signed(table_log) - signed(table_logp);
	
	accuracy <= signed(unsigned(dif_table) * r) sll 1;
	rouding_acc <= accuracy(accuracy'left downto accuracy'left-rouding_acc'left);
	
	
	log_mant <= signed(table_log) + rouding_acc;
	
	temp_out <= std_logic_vector(n) & std_logic_vector(log_mant(log_mant'left-1 downto 0));
	
	output <= temp_out;
	
	
end rtl;