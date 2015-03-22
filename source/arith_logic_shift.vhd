library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity arith_logic_shift is
	Port (A : in  STD_LOGIC_VECTOR (15 downto 0);
			C : out  STD_LOGIC_VECTOR (15 downto 0);
			OP : in  STD_LOGIC;
			Flags : out  STD_LOGIC_VECTOR (3 downto 0));	--ZSCV
end arith_logic_shift;

architecture Behavioral of arith_logic_shift is
	signal C_intern : STD_LOGIC_VECTOR (15 downto 0);
begin
	C_intern <= A(14 downto 0) & '0' when OP='0' else
					A(15) & A(15 downto 1);
	
	C <= C_intern;
	
	--Zero
	Flags(3) <= not(C_intern(15) or C_intern(14) or C_intern(13) or C_intern(12) or C_intern(11) or C_intern(10) or C_intern(9) or C_intern(8) or C_intern(7) or C_intern(6) or C_intern(5) or C_intern(4) or C_intern(3) or C_intern(2) or C_intern(1) or C_intern(0));
	--Sign
	Flags(2) <= C_intern(15);
	--Carry
	Flags(1) <= A(15) and not(OP);
	--oVerflow
	Flags(0) <= '0';
	
end Behavioral;

