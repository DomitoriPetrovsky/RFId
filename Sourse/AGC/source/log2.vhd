library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_log_func.all;


entity log2 is 
	generic(
		BITNESS 		: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		input 	: in	std_logic_vector(BITNESS-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1+5 downto 0));
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
	
	component logic is 
		generic(
			BITNESS 		: NATURAL);
		port(
			input 	: in	std_logic_vector(BITNESS-1 downto 0);
			out_x	: out	std_logic_vector(BITNESS-1 downto 0);
			out_n	: out	std_logic_vector(4 downto 0));
	end component;


signal n 			:  	std_logic_vector(5-1 downto 0) 				:= (others => '0');
signal x 			:	std_logic_vector(BITNESS-1 downto 0) 		:= (others => '0');
signal hight 		: 	unsigned((BITNESS/2)-1 downto 0) 			:= (others => '0');
signal I 			: 	std_logic_vector((BITNESS/2)-1 downto 0) 			:= (others => '0');
signal r 			: 	unsigned((BITNESS/2)-1 downto 0) 			:= (others => '0');	

signal table_log 	:	std_logic_vector(BITNESS-1 downto 0) 		:= (others => '0');
signal table_logp 	:	std_logic_vector(BITNESS-1 downto 0) 		:= (others => '0');

signal temp			:	signed(BITNESS-1 downto 0) 					:= (others => '0');
signal temp_mult	:	signed(BITNESS*2-1 downto 0) 				:= (others => '0');
signal temp_after_mult	:	signed(BITNESS-1 downto 0) 				:= (others => '0');
signal temp3		:	signed(BITNESS-1 downto 0) 					:= (others => '0');
signal temp4		:	signed(BITNESS-1+5 downto 0) 					:= (others => '0');
signal temp44		:	std_logic_vector(BITNESS-1+5 downto 0) 					:= (others => '0');
signal temp51		:	signed(BITNESS-1+1 downto 0) 					:= (others => '0');
signal temp52		:	signed(BITNESS-1+2 downto 0) 					:= (others => '0');
signal temp53		:	signed(BITNESS-1+3 downto 0) 					:= (others => '0');
signal temp54		:	signed(BITNESS-1+4 downto 0) 					:= (others => '0');
signal temp5		:	signed(BITNESS-1+5 downto 0) 					:= (others => '0');

signal temp_out  	:	signed(BITNESS-1+5 downto 0) 		:= (others => '0');
begin
	
u1: logic 	generic map(BITNESS)
			port map(input, x, n);

	hight 	<= unsigned(x(BITNESS-1 downto BITNESS/2));
	r 		<= unsigned(x((BITNESS/2) -1 downto 0));
	I 		<= std_logic_vector(hight - (2**TABLE_LENGTH) );

u2: log_table 	generic map(BITNESS, TABLE_LENGTH)
				port map(I( I'high-1 downto 0), table_log, table_logp);
	
	temp <= signed(table_log) - signed(table_logp);
	
	temp_mult <= temp * signed('0' & r & "0000000"); 
	
	temp_after_mult <= temp_mult(BITNESS*2-2 downto BITNESS-1);
	temp3 <= signed(table_log) + temp_after_mult;
	
	--temp_out <= signed((n & (temp_out'length - n'length => '0'))) + ((temp_out'high - temp3'high => temp3(temp3'high)) & temp3);
	--temp44 <= n & std_logic_vector((temp_out'length - n'length) => '0');
	temp44 <= n & "0000000000000000";
	temp4 <= signed(temp44);
	--temp5 <= ((temp_out'high - temp3'high) => temp3(temp3'high)) & temp3;
	--temp5 <= ((8 => temp3(BITNESS-1)) & temp3);
	--temp51 <= temp3(BITNESS-1) & temp3;
	--temp52 <= temp3(BITNESS-1) & temp51;
	--temp53 <= temp3(BITNESS-1) & temp52;
	--temp54 <= temp3(BITNESS-1) & temp53;
	--temp5 <= temp3(BITNESS-1) & temp54;
	temp5 <= temp3(BITNESS-1) & temp3(BITNESS-1) & temp3(BITNESS-1) & temp3(BITNESS-1) & temp3(BITNESS-1) & temp3;
	temp_out <= temp4 + temp5;
	
	output <= std_logic_vector(temp_out);
	
	
end rtl;