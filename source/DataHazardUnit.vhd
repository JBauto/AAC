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
	signal AA1, BA1 : STD_LOGIC_VECTOR(2 downto 0);
	signal jump_opc, jump_opc_EXMEM, jump_opc_WB : STD_LOGIC_VECTOR (2 downto 0);
	signal OP, OP_EXMEM, OP_WB : STD_LOGIC_VECTOR (4 downto 0);
	signal DA_EXMEM, DA_WB,DA : STD_LOGIC_VECTOR(2 downto 0);
	signal instr_ID_val : STD_LOGIC;
	signal instr_EX_val : STD_LOGIC;
	signal validade_op_ID : STD_LOGIC; -- verifica se é uma operaçao valida
	signal validade_op_EX : STD_LOGIC; -- verifica se é uma operaçao valida
	signal igual_op : STD_LOGIC; -- indica se as instruções entre andares sao validas
		
begin

	format <= OPCODE(9 downto 8);
	format_EXMEM <= OPCODE_EXMEM(9 downto 8);
	format_WB <= OPCODE_WB(9 downto 8);
	DA_EXMEM <= OPCODE_EXMEM(7 downto 5);
	DA_WB <= OPCODE_WB(7 downto 5);
	DA <= OPCODE(7 downto 5);
	OP <= OPCODE(4 downto 0);
	OP_EXMEM <= OPCODE_EXMEM(4 downto 0);
	OP_WB <= OPCODE_WB(4 downto 0);
	
	validade_op_ID <= (not(OP(3)) and not(OP(1))) or (not(OP(3)) and not(OP(0))) or not(OP(2)) OR OP(4);
	validade_op_EX <= (not(OP_EXMEM(3)) and not(OP_EXMEM(1))) or (not(OP_EXMEM(3)) and not(OP_EXMEM(0))) or not(OP_EXMEM(2)) OR OP_EXMEM(4);

	igual_op <= validade_op_ID and validade_op_EX;

end Behavioral;

