
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity fir_da_iter is 
	generic(
		IWL		: NATURAL := 8;
		ORDER	: NATURAL := 4);
	port(
		clk		: in 	std_logic;
		nrst	: in	std_logic;
		input	: in 	std_logic_vector(IWL-1 downto 0);
		done	: out 	std_logic;
		output	: out 	std_logic_vector(IWL-1 downto 0));
end fir_da_iter;

architecture rtl of fir_da_iter is

	component ring_shift_rg_mas is 
	generic(
		IWL			: NATURAL;
		numb_reg	: NATURAL;
		shLeft		: BOOlEAN);
	port(
		clk			: in 	std_logic;
		nrst			: in	std_logic;
		shR			: in	std_logic;
		input	 	: in	std_logic_vector(IWL-1 downto 0);
		cout		: out	std_logic_vector(numb_reg-1 downto 0);
		output		: out	std_logic_vector(IWL-1 downto 0));
	end component;

	component counter is 
	generic(
		IWL			: NATURAL);
	port(
		clk			: in 	std_logic;
		nrst			: in	std_logic;
		rst_level	: in 	std_logic_vector(IWL-1 downto 0);
		output		: out	std_logic_vector(IWL-1 downto 0));
	end component;	

	component add_sub_unit is 
	generic(
		IWL			: NATURAL);
	port(
		add_sub			: in 	std_logic;
		A	 		: in	std_logic_vector(IWL-1 downto 0);		
		B	 		: in	std_logic_vector(IWL-1 downto 0);
		C			: out	std_logic_vector(IWL-1 downto 0));
	end component;

	component ROM is 
	generic(
		DWL			: NATURAL;
		AWL			: NATURAL);
	port(
		adress 		: in	std_logic_vector(AWL-1 downto 0);
		data_out	: out	std_logic_vector(DWL-1 downto 0));
	end component;

	component control_unit_fir_da_iter is 
	generic(
		ICL		: NATURAL);
	port(
		clk		: in 	std_logic;
		nrst	: in	std_logic;
		counter	: in 	std_logic_vector(ICL downto 0);
		rg_nrst	: out	std_logic;
		done	: out 	std_logic;
		add_sub	: out 	std_logic;
		shR		: out 	std_logic);
	end component;

	constant count_wl		: NATURAL := 4;

	signal rg_sum 			: std_logic_vector(IWL downto 0);
	signal rg_out 			: std_logic_vector(IWl-1 downto 0);
	
	signal pre_sum			: std_logic_vector(IWL downto 0);
	signal sum				: std_logic_vector(IWL downto 0);
	signal sum_2 			: std_logic_vector(IWL downto 0);
	
	signal count 			:  std_logic_vector(count_wl-1 downto 0);
	
	signal table_value 		: std_logic_vector(IWL-1 downto 0);
	signal table_adr 		: std_logic_vector(ORDER-1 downto 0);
	signal regs_out 		: std_logic_vector(IWL-1 downto 0);
	
	signal rg_sum_nrst 		: std_logic;
	signal rg_out_st 		: std_logic;
	signal add_sub 			: std_logic;
	signal shift_recording 	: std_logic;
	

begin
	
u_regs: ring_shift_rg_mas 
		generic map(IWL => IWL, 
					numb_reg => ORDER,
					shLeft => FALSE) 
		port map(	clk => clk,
					nrst => nrst,
					shR => shift_recording,
					input => input,
					cout => table_adr,
					output => regs_out);
	
u_rom: ROM
		generic map(DWL => IWL, AWL => ORDER)
		port map(	adress => table_adr,
					data_out => table_value);
	
	pre_sum <= std_logic_vector(resize(signed(table_value), IWL+1));
	
	sum_2 <= rg_sum(rg_sum'left) & rg_sum(rg_sum'left downto 1);
	
u_add_sub: add_sub_unit
		generic map(IWL => IWL+1)
		port map(	add_sub => add_sub,
					A => sum_2,
					B => pre_sum,
					C => Sum);

rg1: process(clk) 
	begin
		if rising_edge(clk) then 
			if (rg_sum_nrst = '0') then
				rg_sum <= (others => '0');
			else
				rg_sum <=  std_logic_vector(sum);
			end if;
		end if;	
	end process;
	
u_count: counter 
		generic map(IWL => count_wl)
		port map(	clk => clk, 
					nrst => nrst, 
					rst_level => "1000",
					output => count);
u_control: control_unit_fir_da_iter
		generic map(ICL => count_wl)
		port map(	clk => clk, 
					nrst => nrst, 
					counter => count, 
					rg_nrst	=> rg_sum_nrst,
					done	=> rg_out_st,
					add_sub	=> add_sub,
					shR		=> shift_recording);
	
	
rg2: process(clk) 
	begin
		if rising_edge(clk) then 
			if (nrst = '0') then
				rg_out <= (others => '0');
			else
				if(rg_out_st = '1') then
					rg_out <=  rg_sum(rg_sum'left-1 downto 0);
				end if;
			end if;
		end if;	
	end process;	
	
	output <= rg_out;
	done <=  rg_out_st;
	
end rtl;