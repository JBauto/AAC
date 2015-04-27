library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity IF_Regs is
	Port (Current_PC_in : in  STD_LOGIC_VECTOR (15 downto 0); 
			Current_PC_out : out  STD_LOGIC_VECTOR (15 downto 0); 
			Next_PC_in : in  STD_LOGIC_VECTOR (15 downto 0);
			Next_PC_out : out  STD_LOGIC_VECTOR (15 downto 0); 
			OPCODE_in : in  STD_LOGIC_VECTOR (15 downto 0);
			OPCODE_out : out  STD_LOGIC_VECTOR (15 downto 0); 
			clk : in  STD_LOGIC;
			enable : in STD_LOGIC
			);
end IF_Regs;

architecture Behavioral of IF_Regs is
begin

--	Next_PC_out <= Next_PC_in when enable = '1' else
--						(others =>'0');
	process (clk)
	begin
   if clk'event and clk='1' then
		if enable = '1' then
			Current_PC_out <= Current_PC_in;
			Next_PC_out <= Next_PC_in;
			OPCODE_out <= OPCODE_in;
		end if;
   end if;
	end process;

end Behavioral;

