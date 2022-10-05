----------------------
-- 1* - ORDER-1-i need to correct formin adress in sum table to DA
-- first(0) word in buf line is high bit 
--
-- P.s yes, i can do in generate (ORDER-1 to 0) and used indecs corektly
--	but i anderstend it so late
----------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity buf_line_da_fir is 
	generic(
		IWL		: NATURAL := 16;
		ORDER	: NATURAL := 4;
		shLeft	: BOOlEAN := FALSE);
	port(
		clk		: in 	std_logic;
		en 		: in 	std_logic;
		nrst	: in	std_logic;
		shRec	: in 	std_logic;
		input	: in	std_logic_vector(IWL-1 downto 0);
		output	: out	std_logic_vector(ORDER-1 downto 0));
end buf_line_da_fir;

architecture rtl of buf_line_da_fir is

	component shift_rg_with_parallel_record is 
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
	end component;

	component shift_rg is 
		generic(
			IWL		: NATURAL := 16;
			shLeft	: BOOlEAN := FALSE);
		port(
			clk		: in 	std_logic;
			en 		: in 	std_logic;
			nrst	: in	std_logic;
			input	: in	std_logic;
			output	: out	std_logic);
	end component;

	signal shEn : std_logic;
	signal temp_out : std_logic_vector(ORDER-1 downto 0);

begin

	shEn <= en and (not (shRec));
	
	output <= temp_out;

	
gen_buf_line: for I in 0 to ORDER-1 generate

	
first:	if I = 0  generate 
sh_rg_with_rec: shift_rg_with_parallel_record
		generic map(IWL => IWL,
					shLeft => shLeft)
		port map(clk => clk, 
				nrst => nrst, 
				shRec => shRec, 
				en => en, 
				input_bit => '0',
				input_word => input, 			--------
				output => temp_out(ORDER-1-I)); -- 1* --
	end generate;								--------

other: if I > 0 generate 
sh_rg: shift_rg 
		generic map(IWL => IWL, 
					shLeft => shLeft)
		port map(clk => clk,
				en => shEn, 
				nrst => nrst, 
				input => temp_out(ORDER-1-I+1), 
				output => temp_out(ORDER-1-I));
	end generate;	

end generate;

end rtl;