library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity logic_unit is
	Port (A : in  STD_LOGIC_VECTOR (15 downto 0);
			B : in  STD_LOGIC_VECTOR (15 downto 0);
			C : out  STD_LOGIC_VECTOR (15 downto 0);
			OP : in  STD_LOGIC_VECTOR (3 downto 0);
			Flags : out  STD_LOGIC_VECTOR (3 downto 0));	--ZSCV
end logic_unit;

architecture Behavioral of logic_unit is
	signal C_intern : STD_LOGIC_VECTOR (15 downto 0);
begin
	C_intern <= (others => '0') when OP="0000" else
					A and B when OP="0001" else
					not(A) and B when OP="0010" else
					B when OP="0011" else
					A and not(B) when OP="0100" else
					A when OP="0101" else
					A xor B when OP="0110" else
					A or B when OP="0111" else
					not(A) and not(B) when OP="1000" else
					not(A xor B) when OP="1001" else
					not(A) when OP="1010" else
					not(A) or B when OP="1011" else
					not(B) when OP="1100" else
					A or not(B) when OP="1101" else
					not(A) or not(B) when OP="1110" else
					(others => '1');
	
	C <= C_intern;
	
	--Zero
	Flags(3) <= not(C_intern(15) or C_intern(14) or C_intern(13) or C_intern(12) or C_intern(11) or C_intern(10) or C_intern(9) or C_intern(8) or C_intern(7) or C_intern(6) or C_intern(5) or C_intern(4) or C_intern(3) or C_intern(2) or C_intern(1) or C_intern(0));
	--Sign
	Flags(2) <= C_intern(15);
	--Carry
	Flags(1) <= '0';
	--oVerflow
	Flags(0) <= '0';
	
end Behavioral;

