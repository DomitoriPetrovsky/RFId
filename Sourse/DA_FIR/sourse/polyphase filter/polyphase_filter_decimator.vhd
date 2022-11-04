library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY WORK;
use work.pkg_da_fir_types_func.all;
use work.pkg_da_fir_constants.all;


entity polyphase_filter_decimator is 
	generic(
		DATA				: two_dim_array_of_stdv;
		IWL					: NATURAL;
		OWL					: NATURAL;
		FIR_PROTOTYPE_ORDER	: NATURAL;
		SUB_FILTER_ORDER 	: NATURAL;
		DEC_COEF			: NATURAL);
	port(
		clk		: in 	std_logic;
		ce_wr 	: in 	std_logic;
		ce_work : in 	std_logic;
		nrst	: in	std_logic;
		input	: in	std_logic_vector(IWL-1 downto 0);
		output	: out	std_logic_vector(OWL-1 downto 0));
end polyphase_filter_decimator;

architecture rtl of polyphase_filter_decimator is


	component fir_da_NBAAT is 
		generic(
			DATA		: one_dim_array_of_stdv;
			IWL			: NATURAL;
			OWL 		: NATURAL;
			ExWL		: NATURAL;
			ORDER		: NATURAL);
		port(
			clk			: in 	std_logic;
			nrst		: in	std_logic;
			ce 			: in 	std_logic;
			input		: in 	std_logic_vector(IWL-1 downto 0);
			output		: out	std_logic_vector(IWL-1 downto 0));
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
	END component;

	-- component shift_rg_with_parallel_reading is 
	-- generic(
		-- OWL			: NATURAL;
		-- shLeft		: BOOlEAN);
	-- port(
		-- clk			: in 	std_logic;
		-- nrst		: in	std_logic;
		-- input_bit	: in 	std_logic;
		-- out_word 	: out	std_logic_vector(OWL-1 downto 0);
		-- output		: out	std_logic);
	-- end component;

	signal shift : std_logic_vector(DEC_COEF-2 downto 0);

	signal fir_outs : one_dim_array_of_stdv(DEC_COEF-1 downto 0)(OWL-1 downto 0);
	signal sum_outs : one_dim_array_of_stdv(DEC_COEF-1 downto 0)(OWL-1 downto 0);

	signal rg_out :  std_logic_vector(OWL-1 downto 0);
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if nrst = '0' then 
				shift <= (others => '0');
			elsif ce_wr = '1' then 
				shift <= shift(shift'left-1 downto 0) & ce_work;
			end if;
		end if;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			if (nrst = '0') then
				rg_out <= (others => '0');
			elsif ce_work = '1' then
				rg_out <= sum_outs(DEC_COEF-1);
			end if;
		end if;
	end process;
	
	output <= rg_out;

fir_struct: for i in DEC_COEF-1 downto 0 generate

first_fir: if (I = 0) generate
		
fir_first: fir_da_NBAAT  generic map(
							DATA => DATA(i),
							IWL	 => IWL,
							OWL  => OWL,
							ExWL => 0,
							ORDER => SUB_FILTER_ORDER)
						port map(
							clk 	=> clk,
							nrst 	=> nrst,
							ce 		=> ce_work,
							input	=> input,
							output	=> fir_outs(i));
		end generate;

other_fir: if (I > 0) generate
		
fir: fir_da_NBAAT  generic map(
							DATA => DATA(i),
							IWL	 => IWL,
							OWL  => OWL,								
							ExWL => 0,	
							ORDER => SUB_FILTER_ORDER)
						port map(
							clk 	=> clk,
							nrst 	=> nrst,
							ce 		=> shift(i-1),
							input	=> input,
							output	=> fir_outs(i));
		end generate;
end generate;

sum_struct: for i in DEC_COEF-1 downto 0 generate

first_sum : if (i = 0 ) generate

whire:	process(fir_outs(i))
		begin
			sum_outs(i) <= fir_outs(i);
		end process;

		end generate;
		
other_sum: if (i > 0) generate

sum: add_sgn_sat generic map (
							IWL => OWL,
							sub => FALSE)
				port map(	A => fir_outs(i),
							B => sum_outs(i-1),
							C => sum_outs(i));
		end generate;

end generate;



end rtl;