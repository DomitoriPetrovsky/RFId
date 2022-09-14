library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_log_func.all;


entity truncation is 
	generic(
		IWL 		: NATURAL;
		IFL			: NATURAL;
		OWL 		: NATURAL;
		OFL			: NATURAL);
	port(
		input 	: in	std_logic_vector(IWL-1 downto 0);
		output	: out	std_logic_vector(OWL-1 downto 0));
end truncation;

architecture rtl of truncation is

	
	constant x1 : natural := IWL - IFL;
	constant x2 : natural := OWL - OFL;
	
	--signal temp_input : std_logic_vector(IWL-1 downto 0) := (others => '0');
	signal temp_out : std_logic_vector(OWL-1 downto 0) := (others => '0');

	signal poz : std_logic_vector(x1-x2-1 downto 0) := (others => '0');
	signal neg : std_logic_vector(x1-x2-1 downto 0) := (others => '1');
	signal temp : std_logic_vector(x1-x2-1 downto 0) := (others => '0');
	signal fpoz : std_logic;
	signal fneg : std_logic;
	signal fs : std_logic;
	signal fn : std_logic;
begin

	
	temp <= input(IWL-2 downto IWL-1-x1+x2);
	
u1:	process(input)

	--variable poz : std_logic_vector(x1-x2-1 downto 0) := (others => '0');
	--variable neg : std_logic_vector(x1-x2-1 downto 0) := (others => '1');
	variable temp_input : std_logic_vector(IWL-1 downto 0) := (others => '0');
	begin
		temp_input := input;
		fpoz <= '0';
		fneg <= '0';
		fs <= '0';
		fn <= '0';
		
		
		if temp_input(IWL-1) = '0' then
			fpoz <= '1';
			if temp = "000000" then 
				fs <= '1';
				temp_out <= '0' & temp_input(IWL-x1+x2-2 downto IFL-OFL);
				
			else 
				fn <= '1';
				temp_out(temp_out'high) <= '0';
				temp_out(OWL-2 downto 0) <= (others => '1');
			
			end if;
		
		
		else 
			fneg <= '1';
			if temp_input(IWL-2 downto IWL-1-x1+x2) = neg then 
				fs <= '1';
				--temp_out <= '1' & temp_input(IWL-1-x2 downto IWL-1-x1-OFL);
				temp_out <= '1' & temp_input(IWL-x1+x2-2 downto IFL-OFL);
				
			else 
				fn <= '1';
				temp_out(temp_out'high) <= '1';
				temp_out(OWL-2 downto 0) <= (others => '0');
			
			end if;
		
		
		
		end if;
		
		output <= temp_out;
		
		
	end process;

	
end rtl;