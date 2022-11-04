
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;


entity NBAAT_da_filter_element is 
	generic(
		DATA		: one_dim_array_of_stdv;
		IWL			: NATURAL;
		AWL			: NATURAL;
		sh			: BOOLEAN := TRUE);
	port(
		input		: in 	std_logic_vector(IWL-1 downto 0);
		address		: in 	std_logic_vector(AWL-1 downto 0);
		in_ts		: in 	std_logic;
		output		: out	std_logic_vector(IWL-1 downto 0));
end NBAAT_da_filter_element;

architecture rtl of NBAAT_da_filter_element is

	component ROM is 
	generic(
		DATA		: one_dim_array_of_stdv;
		DWL			: NATURAL := 16;
		AWL			: NATURAL := 4);
	port(
		adress 		: in	std_logic_vector(AWL-1 downto 0);
		data_out	: out	std_logic_vector(DWL-1 downto 0));
	end component;
	
	component add_sub_unit is 
	generic(
		IWL			: NATURAL := 16);
	port(
		add_sub		: in 	std_logic;
		A	 		: in	std_logic_vector(IWL-1 downto 0);		
		B	 		: in	std_logic_vector(IWL-1 downto 0);
		C			: out	std_logic_vector(IWL-1 downto 0));
	end component;
	
	signal tmp_in :  std_logic_vector(IWL-1  downto 0);
	
	signal table_address : std_logic_vector(AWL-2 downto 0);
	
	signal table_value :  std_logic_vector(IWL-1 downto 0);
	
	signal tmp_ts : std_logic;
	
	signal ts : std_logic;
	
	signal summ : std_logic_vector(IWL-1 downto 0);
	
	signal tmp_out : std_logic_vector(IWL-1 downto 0);

begin
	
	tmp_in <= input;
	output <= tmp_out;
	
form_address: process(address)
	begin
		for I in 1 to AWL-1 loop
			table_address(I-1) <= address(0) xor address(AWL-I);
		end loop;
		tmp_ts <= address(0);
	end process;
	
table: ROM 	generic map(DATA => DATA,
						DWL => IWL, 
						AWL => AWL-1)
			port map(adress => table_address,
					data_out => table_value);
	
	ts <= tmp_ts xor in_ts;
	
add: add_sub_unit 	generic map(IWL => IWL)
					port  map(add_sub => ts,
							A => tmp_in,
							B => table_value,
							C => summ);
	
shift:  if sh generate
			tmp_out <= summ(IWL-1) & summ(IWL-1 downto 1);
		end generate;
	
nonShift: if not sh generate
			tmp_out <= summ;
		end generate;

end rtl;