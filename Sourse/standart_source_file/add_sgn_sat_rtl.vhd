
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

ENTITY add_sgn_sat IS
  GENERIC(
    IWL : natural;
	sub : boolean
    );
  PORT(
    A : IN STD_LOGIC_VECTOR(IWL-1 downto 0);
    B : IN STD_LOGIC_VECTOR(IWL-1 downto 0);
    C : OUT STD_LOGIC_VECTOR(IWL-1 downto 0)
  );
END ENTITY add_sgn_sat;

--
ARCHITECTURE rtl OF add_sgn_sat IS
BEGIN
 
g0 : if not sub generate
  add_proc : PROCESS(A, B)
  VARIABLE iadd_v : signed(IWL DOWNTO 0);
  VARIABLE iadd_sat_v: signed(IWL-1 DOWNTO 0);
  BEGIN
    iadd_sat_v := (OTHERS => '0');
    iadd_v := resize(signed(A), IWL+1) + resize(signed(B), IWL+1);
    IF iadd_v(IWL) /= iadd_v(IWL-1) THEN --Saturate
      iadd_sat_v(IWL-1) := iadd_v(IWL);
      iadd_sat_v(IWL-2 DOWNTO 0) := (OTHERS => iadd_v(IWL-1));
    ELSE
      iadd_sat_v := iadd_v(IWL-1 DOWNTO 0);
    END IF;
    C <= std_logic_vector(iadd_sat_v);
  END PROCESS;
end generate;

g1 : if sub generate
  sub_proc : PROCESS(A, B)
  VARIABLE iadd_v : signed(IWL DOWNTO 0);
  VARIABLE iadd_sat_v: signed(IWL-1 DOWNTO 0);
  BEGIN
    iadd_sat_v := (OTHERS => '0');
    iadd_v := resize(signed(A), IWL+1) - resize(signed(B), IWL+1);
    IF iadd_v(IWL) /= iadd_v(IWL-1) THEN --Saturate
      iadd_sat_v(IWL-1) := iadd_v(IWL);
      iadd_sat_v(IWL-2 DOWNTO 0) := (OTHERS => iadd_v(IWL-1));
    ELSE
      iadd_sat_v := iadd_v(IWL-1 DOWNTO 0);
    END IF;
    C <= std_logic_vector(iadd_sat_v);
  END PROCESS;
end generate;
  
END ARCHITECTURE rtl;

