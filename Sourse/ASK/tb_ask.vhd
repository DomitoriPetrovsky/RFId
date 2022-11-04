library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;



entity tb_ask is 
end tb_ask;

architecture rtl of tb_ask is

	component ask_demodulation is 
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
	end component;
	
	component sin_gen_NS is 
		generic(
			OWL	 	: NATURAL;
			F		: NATURAL;
			FS		: NATURAL;
			DL		: NATURAl;
			data_bit_len	: NATURAl;
			A1		: real;
			A0		: real);
		port(
			clk		: in	std_logic;
			DATA	: in	std_logic_vector(DL-1 downto 0);
			output	: out	std_logic_vector(OWL-1 downto 0));
	end component;


constant CWL : natural := 4; 
constant WL	: natural := 16;
constant F : NATURAL := 3390000;
constant Fs : NATURAL := 15000000;
constant DL : NATURAL := 10;
constant data_bit_len : NATURAL := 16;

constant A0 :  real := real(0);
constant A1 :  real := real(0.9);

signal data :  std_logic_vector(DL-1 downto 0) := "0101100111";

signal input : std_logic_vector(WL-1 downto 0) := (others => '0');
signal output : std_logic_vector(WL-1 downto 0) := (others => '0');
signal alpha : std_logic_vector(CWL-1 downto 0) :=  (others => '0');

signal clk : std_logic := '0';
signal nrst : std_logic;

begin
	

	
	process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;


	process
	begin 
		alpha <= "0011";
		nrst <= '0';
		wait for 10 ns;
		nrst <= '1';
		wait;	
	end process;


u1: sin_gen_NS 	generic map(WL, F, Fs, DL, data_bit_len, A1, A0)
							port map(clk, DATA, input);

u2:  ask_demodulation generic map(WL, CWL)
						port map(clk,nrst, '1', alpha, input, output);
	
end rtl;