library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ProgramCounter is
    Port ( next_PC : in  STD_LOGIC_VECTOR (15 downto 0);
           enable_pc : in  STD_LOGIC;
			  PC : out  STD_LOGIC_VECTOR (15 downto 0);
           PCm1 : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC);
end ProgramCounter;

architecture Behavioral of ProgramCounter is
	signal currentPC : STD_LOGIC_VECTOR (15 downto 0) := (others =>'0');
begin
	process(clk,enable_pc)
	begin
		if enable_pc='1' and rising_edge(clk) then
			currentPC <= next_PC;
		end if;
	end process;
	
	PC <= currentPC;
	PCm1 <= currentPC+1;

end Behavioral;

