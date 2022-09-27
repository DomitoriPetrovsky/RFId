library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

LIBRARY WORK;
use work.pkg_log_func.all;


entity exp2 is 
	generic(
		BITNESS 		: NATURAL;
		DIWL			: NATURAL;
		DIFL			: NATURAL;
		GIWL			: NATURAL;
		GIFL			: NATURAL;
		OWL				: NATURAL;
		OFL				: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		input_gain 	: in	std_logic_vector(GIWL-1 downto 0);
		input_data	: in 	std_logic_vector(DIWL-1 downto 0);
		output		: out	std_logic_vector(OWL-1 downto 0));
end exp2;

architecture rtl of exp2 is

	component exp_table is 
	generic(
		BITNESS 		: NATURAL;
		TABLE_LENGTH	: NATURAL);
	port(
		adress 	: in	std_logic_vector(TABLE_LENGTH-1 downto 0);
		output	: out	std_logic_vector(BITNESS-1 downto 0));
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
	end component;
	
	constant ones 		: integer := 1;
	constant shift_len	: NATURAL := GIWL-GIFL;
	
	signal temp_in 		: std_logic_vector	(DIWL-1 downto 0);
	signal temp_out 	: signed 	(DIWL*2-1+3 downto 0);
	
	signal temp_gain 	: std_logic_vector	(GIWL-1 downto 0);
	
	signal tab_adress 	: std_logic_vector	(TABLE_LENGTH-1 downto 0);
	signal tab_value 	: std_logic_vector	(DIWL-1 downto 0);
	
	signal mult 		: signed			(DIWL*2-1 downto 0);
	
	signal mult_ext  	: signed			(mult'left + 3 downto 0);
	
	-- signal pre_shift 	: std_logic_vector	(shift_len-1 downto 0);
	-- signal one  		: std_logic_vector	(shift_len-1 downto 0);
	
	-- signal neg_shift 	: std_logic_vector	(shift_len-1 downto 0);
	
	signal shift_value	: std_logic_vector	(shift_len-1 downto 0);	
	signal shift_int	: integer;
	
begin

	temp_gain <= input_gain;
	temp_in <= input_data;
	
	tab_adress <= temp_gain(GIFL-1 downto GIFL-TABLE_LENGTH);
	
	shift_value <= temp_gain(GIWL-1 downto GIFL);
	
	-- one <= std_logic_vector(to_signed(ones, one'length));
		
-- sub: add_sgn_sat 	generic map(IWL => shift_len, sub => true)
					-- port map(A => pre_shift, 
							 -- B => one,
							 -- C => neg_shift);
							 
	-- shift_value <= pre_shift when pre_shift(pre_shift'left) = '0' else neg_shift;
	
table: exp_table	generic map(BITNESS, TABLE_LENGTH)
					port map(tab_adress, tab_value);
			
	mult <= signed(temp_in) * (signed(tab_value) srl 1) sll 1;
	
	shift_int <= to_integer(signed(shift_value));
	
	mult_ext <= resize(mult, mult_ext'length);
	
	temp_out <= shift_left(mult_ext, shift_int + 1) 
				when shift_value(shift_value'left) = '0' else
				shift_right(mult_ext, -shift_int - 1);
	--temp_out <= std_logic_vector(mult sll to_integer(signed(shift_value)));
	
	process(temp_out)
	
	variable temp : std_logic_vector(3 downto 0);
	variable temp1 : std_logic_vector(3 downto 0);
	
	variable sign :  std_logic_vector(3 downto 0);
	constant zeros: std_logic_vector(sign'left downto 0) := (others => '0');
	variable zn : std_logic;
	begin 
		zn := not std_logic(mult(mult'left));
		sign := std_logic_vector(temp_out(temp_out'left downto temp_out'left - sign'left));
		temp1 := (others => mult(mult'left));
		temp := std_logic_vector(sign) xor temp1;
		
		if (temp = zeros) then 
			output <= 	std_logic_vector(temp_out(temp_out'left-3 downto temp_out'left-OWL+1-3));
		else 
			output(output'left) <= mult(mult'left);
			output(output'left-1 downto 0) <= (others => zn);
		end if;
		
	end process;
			
	--output <= 	std_logic_vector(temp_out(temp_out'left downto temp_out'left-OWL+1));
	

end rtl;