
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity IF_Regs is
	Port (Next_PC_in : in  STD_LOGIC_VECTOR (15 downto 0);
			Next_PC_out : out  STD_LOGIC_VECTOR (15 downto 0); 
			clk : in  STD_LOGIC;
			enable : in STD_LOGIC
			);
end IF_Regs;

architecture Behavioral of IF_Regs is
begin
	process (clk)
	begin
   if clk'event and clk='1' then
		if enable = '1' then
			Next_PC_out <= Next_PC_in;
		end if;
   end if;
end process;

end Behavioral;

