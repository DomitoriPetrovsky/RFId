
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;


entity fir_da_NBAAT is 
	generic(
		DATA		: one_dim_array_of_stdv;
		IWL			: NATURAL;
		OWL			: NATURAL;
		ExWL		: NATURAL;
		ORDER		: NATURAL);
	port(
		clk			: in 	std_logic;
		nrst		: in	std_logic;
		ce 			: in 	std_logic;
		input		: in 	std_logic_vector(IWL-1 downto 0);
		output		: out	std_logic_vector(OWL-1 downto 0));
end fir_da_NBAAT;

architecture rtl of fir_da_NBAAT is
	
	
	component NBAAT_da_filter_element is 
	generic(
		DATA		: one_dim_array_of_stdv;
		IWL			: NATURAL;
		AWL			: NATURAL;
		sh			: BOOLEAN);
	port(
		input		: in 	std_logic_vector(IWL-1 downto 0);
		address		: in 	std_logic_vector(AWL-1 downto 0);
		in_ts		: IN 	std_logic;
		output		: out	std_logic_vector(IWL-1 downto 0));
	end component;
	
	constant WL : NATURAL := OWL + ExWL;
	
	type mas is array (0 to ORDER-1) of std_logic_vector(IWL-1 downto 0);
	
	type to_address is array (0 to IWL-1) of std_logic_vector(ORDER-1 downto 0);
	
	type wire is array (0 to IWL-1) of std_logic_vector(WL-1 downto 0);
	
	signal tmp_in : std_logic_vector(IWL-1 downto 0);
	signal tmp_out : std_logic_vector(WL-1 downto 0);
	
	signal rg_delay_line 	: mas;
	signal conection 		: wire;
	signal addresses 		: to_address;
	
	
	
begin
	
	tmp_in <= input;
	output <= tmp_out(OWL-1 downto 0);
	
	
	
DL:	process(clk)
	begin
		if rising_edge(clk) then 
			if (nrst = '0') then
				for i in 0 to ORDER-1 loop 
					rg_delay_line(i) <= (others => '0');
				end loop;
			elsif ce = '1' then
				rg_delay_line(1 to ORDER-1) <= rg_delay_line( 0 to ORDER-2);
				rg_delay_line(0) <= tmp_in;
			end if;
		end if;
	end process;
	
	
	
form_address:  process(rg_delay_line)
	begin
regs:	for i in 0 to ORDER-1 loop
bits:		for j in 0 to IWL-1 loop
				
				addresses(j)(i) <= rg_delay_line(i)(j);
	
			end loop;
		end loop;
	end process;
	
	
	-- Neeed be constatn value what = ROM(0)
	--conection(0) <= "11110000"; 
	conection(0) <= DATA(0); 
	
gen_da_element: for I in 0 to IWL-1 generate	
oth:				if ( I >= 0) and (I < IWL-1) generate				
da_element: 		NBAAT_da_filter_element generic map(DATA => DATA,
														IWL => WL,
														AWL => ORDER,
														sh =>  TRUE)
											port map(input  => conection(I),
													address => addresses(I),
													in_ts 	=> '0',
													output 	=> conection(I+1));
					end generate;									
last:					if ( I = IWL-1) generate				
da_element_last: 	NBAAT_da_filter_element generic map(DATA => DATA,
														IWL => WL,
														AWL => ORDER,
														sh =>  FALSE)
											port map(input  => conection(I),
													address => addresses(I),
													in_ts 	=> '1', 
													output 	=> tmp_out);						
					end generate;				
				end generate;

	
end rtl;