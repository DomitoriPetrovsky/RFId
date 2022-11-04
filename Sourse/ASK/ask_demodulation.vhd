
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity ask_demodulation is 
	generic(
		IWL			: NATURAL;
		CWL			: NATURAL);
	port(
		clk			: in 	std_logic;
		nrst		: in 	std_logic;
		ce			: in 	std_logic;
		alpha		: in 	std_logic_vector(CWL-1 downto 0);
		input	 	: in	std_logic_vector(IWL-1 downto 0);		
		output		: out	std_logic_vector(IWL-1 downto 0));
end ask_demodulation;

architecture rtl of ask_demodulation is

	signal tmp_in : signed(IWL-1 downto 0);
	signal square : signed(2*IWL-1 downto 0);
	
	signal z : std_logic_vector(IWL-1 downto 0);
	
	
	signal shift_1 :  signed(IWL-1 downto 0);
	signal shift_2 :  signed(IWL-1 downto 0);
	
	signal tmp_out	: signed(IWL-1 downto 0);
	signal delay	: signed(IWL-1 downto 0);
	
	
	signal sum	: signed(IWL-1 downto 0);
	
begin
	
	tmp_in <= signed(input);
	
	square <= (tmp_in * tmp_in) sll 1;
	
	
------------------------------------------------------
--shift 1
------------------------------------------------------

	shift_1 <= signed(square(2*IWL-1 downto IWL)) srl to_integer(unsigned(alpha));

------------------------------------------------------
--shift 2
------------------------------------------------------
	shift_2 <=  delay srl to_integer(unsigned(alpha));


u2: process(clk)
	begin 
		if rising_edge(clk) then 
			if nrst = '0' then 
				delay <= (others => '0');
			elsif ce = '1' then 
				delay <= tmp_out;
			end if;
		end if;
	
	end process;
	
	sum <= delay - shift_2;
	tmp_out <= sum + shift_1;
	
	output <= std_logic_vector(tmp_out);
	
	
end rtl;