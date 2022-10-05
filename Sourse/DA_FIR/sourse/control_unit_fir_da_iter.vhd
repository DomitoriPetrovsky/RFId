
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity control_unit_fir_da_iter is 
	generic(
		ICL		: NATURAL := 5);
	port(
		clk			: in 	std_logic;
		nrst		: in	std_logic;
		counter		: in 	std_logic_vector(ICL-1 downto 0);
		count_nrst 	: out 	std_logic;
		buf_en		: out 	std_logic;
		buf_shRec	: out 	std_logic;
		add_sub		: out 	std_logic;
		rg_nrst		: out 	std_logic;
		rg_en		: out 	std_logic;
		res			: out 	std_logic);
end control_unit_fir_da_iter;

architecture rtl of control_unit_fir_da_iter is


constant FSM_BITNES : NATURAL := 3;

constant FSM_STATE_RST 		: std_logic_vector(FSM_BITNES-1 downto 0) := "000";
constant FSM_STATE_LOAD		: std_logic_vector(FSM_BITNES-1 downto 0) := "001";
constant FSM_STATE_START	: std_logic_vector(FSM_BITNES-1 downto 0) := "010";
constant FSM_STATE_SHIFT	: std_logic_vector(FSM_BITNES-1 downto 0) := "011";
constant FSM_STATE_DEC		: std_logic_vector(FSM_BITNES-1 downto 0) := "100";
constant FSM_STATE_RES		: std_logic_vector(FSM_BITNES-1 downto 0) := "101";

signal state : std_logic_vector (FSM_BITNES-1 downto 0);
signal next_state : std_logic_vector (FSM_BITNES-1 downto 0);


signal tmp_count_nrst 	:	std_logic;
signal tmp_buf_en		:	std_logic;
signal tmp_buf_shRec	:	std_logic;
signal tmp_add_sub		:	std_logic;
signal tmp_rg_nrst		:	std_logic;
signal tmp_rg_en		:	std_logic;
signal tmp_res			:	std_logic;

signal tmp_counter		:	std_logic;--std_logic_vector(ICL-1 downto 0);
		

begin

	count_nrst 	<= tmp_count_nrst;
	buf_en		<= tmp_buf_en;
	buf_shRec	<= tmp_buf_shRec;
	add_sub		<= tmp_add_sub;
	rg_nrst		<= tmp_rg_nrst;
	rg_en		<= tmp_rg_en;
	res			<= tmp_res;

	tmp_counter <= (counter(3) xor '0') or (counter(2) xor '1') or (counter(1) xor '1') or (counter(0) xor '1');


	tmp_count_nrst 	<= 	'1' when state = FSM_STATE_START else 
						'1' when state = FSM_STATE_SHIFT else '0';
						--'1' when state = FSM_STATE_DEC else '0';
						
	tmp_buf_en		<= 	'1' when state = FSM_STATE_LOAD else 
						'1' when state = FSM_STATE_SHIFT else
						'1' when state = FSM_STATE_DEC else '0';
						--'1' when state = FSM_STATE_RES else	'0';
						
	tmp_buf_shRec	<= 	'1' when state = FSM_STATE_LOAD else '0';
	
	tmp_add_sub		<= 	'1' when state = FSM_STATE_DEC else '0';
	
	tmp_rg_nrst		<= 	'0' when state = FSM_STATE_LOAD else '1';
	
	tmp_rg_en		<= 	'1' when state = FSM_STATE_START else 
						'1' when state = FSM_STATE_SHIFT else
						'1' when state = FSM_STATE_DEC else '0';
						
	tmp_res			<= 	'1' when state = FSM_STATE_RES else '0';
	
	
	
	
g0: process(state, tmp_counter)
	begin
	
		case state is
		
			when FSM_STATE_LOAD => 
				next_state <= FSM_STATE_START;
			
			when FSM_STATE_START => 
				next_state <= FSM_STATE_SHIFT;
				
			when FSM_STATE_SHIFT => 
				if tmp_counter = '0' then 
					next_state <= FSM_STATE_DEC;
				end if;
				
			when FSM_STATE_DEC =>
				next_state <= FSM_STATE_RES;
				
			when FSM_STATE_RES => 
				next_state <= FSM_STATE_LOAD;
				
			when others => 
				next_state <= FSM_STATE_LOAD;
		
		end case;
	end process;
	
	
	process(clk)
	begin
		if rising_edge(clk) then 
			if nrst = '0' then 
				state <= (others => '0');
			else
				state <= next_state;
			end if;
		end if;
	end process;	
	
	
end rtl;