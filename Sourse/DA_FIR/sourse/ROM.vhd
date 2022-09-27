

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_log_func.all;


entity ROM is 
	generic(
		DWL			: NATURAL := 16;
		AWL			: NATURAL := 4);
	port(
		adress 		: in	std_logic_vector(AWL-1 downto 0);
		data_out	: out	std_logic_vector(DWL-1 downto 0));
end ROM;

architecture rtl of ROM is

	type da_rom is array (0 to 2**AWL-1) of std_logic_vector(DWL-1 downto 0);
	
	constant content : da_rom :=(
				0 => "00000000",
				1 => "00010000",
				2 => "00001000",
				3 => "00011000",
				4 => "00000100",
				5 => "00010100",
				6 => "00001100",
				7 => "00011100",
				8 => "00000010",
				9 => "00010010",
				10 => "00001010",
				11 => "00011010",
				12 => "00000110",
				13 => "00010110",
				14 => "00001110",
				15 => "00011110");
	
begin
			data_out <=  content(NATURAL(to_integer(unsigned(adress))));
end rtl;