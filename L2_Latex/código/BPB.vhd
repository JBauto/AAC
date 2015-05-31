library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity predbuff is
    Port ( current_bits : in  STD_LOGIC_VECTOR (1 downto 0);
           taken : in  STD_LOGIC;
           new_bits : out  STD_LOGIC_VECTOR (1 downto 0));
end predbuff;

architecture Behavioral of predbuff is
	signal ABC : STD_LOGIC_VECTOR (2 downto 0);
begin
	--  AB		  C		DE
	--current	taken		new
	--  00		  0		00
	--  00		  1		01
	--  01		  0		00
	--  01		  1		10
	--  10		  0		01
	--  10		  1		11
	--  11		  0		10
	--  11		  1		11
	
	ABC <= current_bits & taken;
	
	new_bits <= "00" when ABC="000" else
					"01" when ABC="001" else
					"00" when ABC="010" else
					"10" when ABC="011" else
					"01" when ABC="100" else
					"11" when ABC="101" else
					"10" when ABC="110" else
					"11";

end Behavioral;

