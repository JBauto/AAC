library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DataHazardUnit is
	Port (OPCODE : in  STD_LOGIC_VECTOR (9 downto 0);
			OPCODE_EXMEM : in  STD_LOGIC_VECTOR (9 downto 0);
			OPCODE_WB : in  STD_LOGIC_VECTOR (9 downto 0);
			DA_WB : in STD_LOGIC_VECTOR(2 downto 0);
			AA : in STD_LOGIC_VECTOR(2 downto 0);
			BA : in STD_LOGIC_VECTOR(2 downto 0);
			MUX_ALU_A : out STD_LOGIC;
			MUX_ALU_B : out STD_LOGIC;
			FORWARD_CONST : out STD_LOGIC;
			FORWARD_CONST_ALU : out STD_LOGIC;
			FORWARD_ALU_CONST_A : out STD_LOGIC;
			FORWARD_ALU_CONST_B : out STD_LOGIC;
			FORWARD_CONST_MEM : out STD_LOGIC;
			FORWARD_MEM_CONST_ADDRESS : out STD_LOGIC;
			FORWARD_MEM_CONST_DATA : out STD_LOGIC;
			FORWARD_MEM_ALU_ADDRESS : out STD_LOGIC;
			FORWARD_MEM_ALU_DATA : out STD_LOGIC;
			FORWARD_ALU_MEM_DATA_A : out STD_LOGIC;
			FORWARD_ALU_MEM_DATA_B : out STD_LOGIC
			);
end DataHazardUnit;

architecture Behavioral of DataHazardUnit is
	signal format, format_EXMEM, format_WB : STD_LOGIC_VECTOR (1 downto 0);
	signal AA1, BA1 : STD_LOGIC_VECTOR(2 downto 0);
	signal jump_opc, jump_opc_EXMEM, jump_opc_WB : STD_LOGIC_VECTOR (2 downto 0);
	signal OP, OP_EXMEM, OP_WB : STD_LOGIC_VECTOR (4 downto 0);
	signal DA_EXMEM1, DA_WB1, DA : STD_LOGIC_VECTOR(2 downto 0);
	signal instr_ID_val : STD_LOGIC;
	signal instr_EX_val : STD_LOGIC;
	signal validade_op_ID : STD_LOGIC; -- verifica se e uma operaçao valida
	signal validade_op_EX : STD_LOGIC; -- verifica se e uma operaçao valida
	--signal validade_const_ID : STD_LOGIC; -- verifica se e uma operaçao valida
	--signal validade_const_EX : STD_LOGIC; -- verifica se e uma operaçao valida
	signal igual_op : STD_LOGIC; -- indica se as instruçőes entre andares sao validas
	signal validade_dest_a : STD_LOGIC_VECTOR(2 downto 0);
	signal validade_dest_b : STD_LOGIC_VECTOR(2 downto 0);
	signal igual_dest_a : STD_LOGIC;
	signal igual_dest_b : STD_LOGIC;
	signal validade_format : STD_LOGIC;
	signal validade_format_exmem : STD_LOGIC;
	signal validade_format_wb : STD_LOGIC;
	--const-const
	signal form_const : STD_LOGIC;
	signal form_const_EX : STD_LOGIC;
	signal val_form_const : STD_LOGIC;
	signal val_const : STD_LOGIC_VECTOR(2 downto 0);
	signal const_reg : STD_LOGIC_VECTOR(2 downto 0);
	signal forw_const : STD_LOGIC;
	--const-alu
	signal form_const_alu : STD_LOGIC;
	signal form_const_alu_EX : STD_LOGIC;
	signal val_form_const_alu : STD_LOGIC;
	signal alu_reg : STD_LOGIC_VECTOR(2 downto 0);
	signal val_const_alu : STD_LOGIC_VECTOR(2 downto 0);
	signal forw_const_alu : STD_LOGIC;
	--alu-const
	signal form_alu_const : STD_LOGIC;
	signal form_alu_const_EX : STD_LOGIC;
	signal val_form_alu_const : STD_LOGIC;
	signal val_alu_const_a : STD_LOGIC_VECTOR(2 downto 0);
	signal forw_alu_const_a : STD_LOGIC;
	signal val_alu_const_b : STD_LOGIC_VECTOR(2 downto 0);
	signal forw_alu_const_b : STD_LOGIC;
	--const-memoria
	signal form_const_mem : STD_LOGIC;
	signal form_const_mem_EX : STD_LOGIC;
	signal val_form_const_mem : STD_LOGIC;
	signal mem_reg : STD_LOGIC_VECTOR(2 downto 0);
	signal val_const_mem : STD_LOGIC;
	--memoria-const
	signal form_mem_const : STD_LOGIC;
	signal form_mem_const_EX : STD_LOGIC;
	signal val_form_mem_const : STD_LOGIC;
	signal val_address : STD_LOGIC;
	signal val_data : STD_LOGIC;
	--memoria-au
	signal val_alu_address : STD_LOGIC;
	signal val_alu_data : STD_LOGIC;
	--alu-memoria
	signal val_alu_mem : STD_LOGIC;
	signal val_reg_a : STD_LOGIC;
	signal val_reg_b : STD_LOGIC;
	
begin

	format <= OPCODE(9 downto 8);
	format_EXMEM <= OPCODE_EXMEM(9 downto 8);
	format_WB <= OPCODE_WB(9 downto 8);
	DA_EXMEM1 <= OPCODE_EXMEM(7 downto 5);
	DA_WB1 <= DA_WB; 
	DA <= OPCODE(7 downto 5);
	OP <= OPCODE(4 downto 0);
	OP_EXMEM <= OPCODE_EXMEM(4 downto 0);
	OP_WB <= OPCODE_WB(4 downto 0);
	
	
	-- FORWARDING ALU-ALU / ALU-CONST
	
	validade_format <= format(1) and not(format(0));
	validade_format_EXMEM <= format_EXMEM(1) and not(format_EXMEM(0));
	validade_format_WB <= format_WB(1) and not(format_WB(0));
	
	
	validade_op_ID <= ((not(OP(3)) and not(OP(1))) or 
							(not(OP(3)) and not(OP(0))) or 
							 not(OP(2)) OR OP(4)) and
							 validade_format;
							 
	validade_op_EX <= ((not(OP_EXMEM(3)) and not(OP_EXMEM(1))) or 
							(not(OP_EXMEM(3)) and not(OP_EXMEM(0))) or 
							 not(OP_EXMEM(2)) OR OP_EXMEM(4)) and
							 validade_format_EXMEM;
							 
	igual_op <= validade_op_ID and validade_op_EX; -- alu alu
	val_form_alu_const <= validade_op_ID and form_const_EX; -- alu const
	
	igual_dest_a <= '1' when AA = DA_EXMEM1 else
						 '0';
	igual_dest_b <= '1' when BA = DA_EXMEM1 else
						 '0';

	MUX_ALU_A <= igual_op and igual_dest_a;
	MUX_ALU_B <= igual_op and igual_dest_b;
	
	forw_alu_const_b <= val_form_alu_const and igual_dest_b;
	FORWARD_ALU_CONST_B <= forw_alu_const_b;
	
	forw_alu_const_a <= val_form_alu_const and igual_dest_a;
	FORWARD_ALU_CONST_A <= forw_alu_const_a;
	
	--FORWARDING CONSTANTE-CONSTANTE
	
	form_const <= OPCODE(8);
	form_const_EX <= OPCODE_EXMEM(8);
	
	val_form_const <= form_const and form_const_EX;
	const_reg <= DA_EXMEM1;
	
	forw_const <= '1' when AA = const_reg and val_form_const = '1' else
					  '0';

	FORWARD_CONST <= forw_const;
	
	--FORWARDING CONSTANTE-ALU
	
	form_const_alu <= validade_op_EX and form_const;
	
	forw_const_alu <= '1' when DA_EXMEM1 = const_reg and form_const_alu = '1' else
				         '0';
	
	FORWARD_CONST_ALU <= forw_const_alu;
	
	--FORWARDING CONSTANTE-MEMORIA
	
	form_const_mem <= form_const;
	form_const_mem_EX <= '1' when OP_EXMEM = "01010" else
								'0';
								
	val_form_const_mem <= form_const_mem and form_const_mem_EX;
	
	mem_reg <= DA_EXMEM1;
	
	FORWARD_CONST_MEM <= '1' when mem_reg=AA and val_form_const_mem = '1' else
						      '0';
	
	--FORWARD MEMORIA-CONSTANTE ADDRESS/DATA
	
	val_form_mem_const <= '1' when OP(3 downto 0) = "0101"  and format_EXMEM(0) = '1' else
								 '0';
								 
	val_address <= '1' when DA_EXMEM1 = AA else
						'0';
						
	val_data <= '1' when DA_EXMEM1 = BA and OP = "01011" else
					'0';
	
	FORWARD_MEM_CONST_ADDRESS <= val_form_mem_const and val_address;
	FORWARD_MEM_CONST_DATA <= val_form_mem_const and val_data;
	
	--FORWARD MEMORIA-ALU ADDRESS/DATA
	
	val_alu_address <= '1' when OP(3 downto 0) = "0101" else
							 '0';
	
	FORWARD_MEM_ALU_ADDRESS <= validade_op_EX and val_alu_address and val_address;
	FORWARD_MEM_ALU_DATA <= validade_op_EX and val_data;
	
	--FORWARD ALU-MEMORIA DATA
	
	val_alu_mem <= '1' when OP_EXMEM = "01011" and validade_op_EX = '1' else
						'0';
						
	val_reg_a <= igual_dest_a and val_alu_mem;
	val_reg_b <= igual_dest_b and val_alu_mem;
	
	FORWARD_ALU_MEM_DATA_A <= val_reg_a;
	FORWARD_ALU_MEM_DATA_B <= val_reg_b;
	
	
end Behavioral;

