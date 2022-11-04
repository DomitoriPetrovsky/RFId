library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


LIBRARY WORK;
use work.pkg_log_func.all;


entity dc_component is 
	generic(
		IWL : NATURAL);
	port(
		clk		: in	std_logic;
		wr_coef	: in 	std_logic;
		ce		: in 	std_logic;
		nrst	: in 	std_logic;
		A 		: in 	std_logic_vector(IWL-1 downto 0);
		input 	: in	std_logic_vector(IWL-1 downto 0);
		output	: out	std_logic_vector(IWL-1 downto 0));
end dc_component;

architecture rtl of dc_component is


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

	
	signal temp_in 		: std_logic_vector(IWL-1 downto 0) 	:= (others => '0');
	
	signal temp_out 	: std_logic_vector(IWL-1 downto 0)	:= (others => '0');
	signal mult 		: signed(IWL*2-1 downto 0) 	:= (others => '0');
	signal trunc		: std_logic_vector(IWL-1 downto 0) 	:= (others => '0');
	signal add			: std_logic_vector(IWL-1 downto 0) 	:= (others => '0');
	
	signal rg_a			: std_logic_vector(IWL-1 downto 0)		:= (others => '0');
	
	signal rg_ConstComp	: std_logic_vector(IWL-1 downto 0) 	:= (others => '0');
	signal ConstComp	: std_logic_vector(IWL-1 downto 0) 	:= (others => '0');
	
	
begin
	
	-------------------
	--input register
	-------------------
	process(clk)
	begin 
		if(rising_edge(clk)) then 
			if nrst = '0' then 
				temp_in <= (others => '0');
			elsif ce = '1' then 
				temp_in <= input;
			end if;
		end if;
	end process;
	
	
	-------------------
	--writing Alfa
	-------------------
	process(clk)
	begin 
		if(rising_edge(clk)) then 
			if(wr_coef = '1') then
				rg_a <= A;
			end if;
		end if;
	end process;
	
sub1: add_sgn_sat 	generic map(IWL => IWL, sub => true )	
					port map(A => temp_in,
							B => rg_ConstComp, 
							C => temp_out);

	mult <= signed(signed(rg_a) * signed(temp_out)) sll 1;
	trunc <= std_logic_vector(mult(mult'length-1 downto mult'length-IWL));
	
add1: add_sgn_sat 	generic map(IWL => IWL, sub => false )	
					port map(A => trunc,
							B => rg_ConstComp, 
							C => ConstComp);
	
	process(clk)
	begin 
		if(rising_edge(clk)) then
			if nrst = '0' then 
				rg_ConstComp <= (others => '0');
			elsif ce = '1' then
				rg_ConstComp <= ConstComp;
			end if;
		end if;
	end process;
	
	output <= temp_out;
	
	
end rtl;