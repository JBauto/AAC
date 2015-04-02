library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DataHazardUnit is
	Port (OPCODE : in  STD_LOGIC_VECTOR (9 downto 0);
			OPCODE_EXMEM : in  STD_LOGIC_VECTOR (9 downto 0);
			OPCODE_WB : in  STD_LOGIC_VECTOR (9 downto 0);
			DA_EXMEM : in STD_LOGIC_VECTOR(2 downto 0);
			DA_WB : in STD_LOGIC_VECTOR(2 downto 0);
			AA : in STD_LOGIC_VECTOR(2 downto 0);
			BA : in STD_LOGIC_VECTOR(2 downto 0);
			Conflit : out STD_LOGIC;
			Conflit_A : out STD_LOGIC;
			Conflit_B : out STD_LOGIC
			);
end DataHazardUnit;

architecture Behavioral of DataHazardUnit is
	signal format, format_EXMEM, format_WB : STD_LOGIC_VECTOR (1 downto 0);
	signal jump_opc, jump_opc_EXMEM, jump_opc_WB : STD_LOGIC_VECTOR (2 downto 0);
	signal OP, OP_EXMEM, OP_WB : STD_LOGIC_VECTOR (4 downto 0);
begin

	format <= OPCODE(9 downto 8);
	format_EXMEM <= OPCODE_EXMEM(9 downto 8);
	format_WB <= OPCODE_WB(9 downto 8);
	
	
	Conflit_A <=

end Behavioral;

