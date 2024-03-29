
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use work.full_memory.all;

entity cpu is
   Port( CLK, TEST1 : in STD_LOGIC;
			MEMORY : out STD_LOGIC_VECTOR(15 downto 0);
			INST_NB : out std_LOGIC_VECTOR(15 downto 0);
			PRINT : out STD_LOGIC;
			TEST: out STD_LOGIC_VECTOR(15 downto 0));
end cpu;

architecture Behavioral of cpu is
  component alu
		port(OP_SEL : in  STD_LOGIC_VECTOR (4 downto 0);
			A : in  STD_LOGIC_VECTOR (15 downto 0);
			B : in  STD_LOGIC_VECTOR (15 downto 0);
			S : out  STD_LOGIC_VECTOR (15 downto 0);
			Flags : out  STD_LOGIC_VECTOR (3 downto 0));
	end component alu;
	
	component decoder
		port (INSTRUCTION : in  STD_LOGIC_VECTOR (15 downto 0);
			   IMM  : out  STD_LOGIC_VECTOR (15 downto 0); -- 10-0 quando 01XXX; 7-0 quando 11XXX
			   OPCODE : out  STD_LOGIC_VECTOR (4 downto 0);
			   UNIT_SEL : out STD_LOGIC_VECTOR(1 downto 0);
			   DA : out STD_LOGIC_VECTOR(2 downto 0);
			   AA : out STD_LOGIC_VECTOR(2 downto 0);
			   BA : out STD_LOGIC_VECTOR(2 downto 0);
			   WE : out STD_LOGIC;
			   SEL_OUT : out STD_LOGIC_VECTOR(1 downto 0);
			   MEM_WRITE : out STD_LOGIC;
				jump_opcode : out STD_LOGIC_VECTOR(13 downto 0);
				flags_en : out STD_LOGIC_VECTOR(3 downto 0);
				enable_jump : out STD_LOGIC
		  );
	end component decoder;
	
	component registerfile
		port(AA : in  STD_LOGIC_VECTOR (2 downto 0);
			  A : out  STD_LOGIC_VECTOR (15 downto 0);
			  BA : in  STD_LOGIC_VECTOR (2 downto 0);
		  	  B : out  STD_LOGIC_VECTOR (15 downto 0);
			  DA : in  STD_LOGIC_VECTOR (2 downto 0);
			  WE : in  STD_LOGIC;
			  DATA : in  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in STD_LOGIC);
	end component registerfile;

	component constantes
		port(Const : in  STD_LOGIC_VECTOR (15 downto 0);
           C_in : in  STD_LOGIC_VECTOR (15 downto 0);
           C : out  STD_LOGIC_VECTOR (15 downto 0);
           OP_SEL : in  STD_LOGIC_VECTOR (1 downto 0));
	end component constantes;
	
	component writeback_mux
		port(ALU : in  STD_LOGIC_VECTOR (15 downto 0);
			  MEM : in  STD_LOGIC_VECTOR (15 downto 0);
			  PC : in  STD_LOGIC_VECTOR (15 downto 0);
			  Consts : in STD_LOGIC_VECTOR (15 downto 0);
			  Sel_WB : in  STD_LOGIC_VECTOR (1 downto 0);
			  C : out  STD_LOGIC_VECTOR (15 downto 0));
	end component writeback_mux;
	
	component sync_ram
		port (clock   : in  std_logic;
				we      : in  std_logic;
				address : in  std_logic_vector;
				datain  : in  std_logic_vector;
				dataout : out std_logic_vector);
	end component sync_ram;
	
	component rom_instrc
		port(clk : in std_logic;
			  we : in std_logic;
		     addr_instr : in std_logic_vector(15 downto 0);
		     addr_dados : in std_logic_vector(15 downto 0);
		     din : in std_logic_vector(15 downto 0);
			  print : out std_logic;
		     dout_instr : out std_logic_vector(15 downto 0);
		     dout_dados : out std_logic_vector(15 downto 0));
	end component;
	
	component Flags
		port(clk : in  STD_LOGIC;
			  Flags : in  STD_LOGIC_VECTOR (3 downto 0);
			  enable_flags : in  STD_LOGIC_VECTOR (3 downto 0);
			  enable_jump : in  STD_LOGIC;
			  jump_info : in  STD_LOGIC_VECTOR (13 downto 0);
			  PCm1 : in STD_LOGIC_VECTOR (15 downto 0);
			  RB : in STD_LOGIC_VECTOR (15 downto 0);
			  output_address : out  STD_LOGIC_VECTOR (15 downto 0));
		end component Flags;
	
	component ProgramCounter is
		port(next_PC : in  STD_LOGIC_VECTOR (15 downto 0);
			  enable_pc : in  STD_LOGIC;
			  PC : out  STD_LOGIC_VECTOR (15 downto 0);
			  PCm1 : out  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in  STD_LOGIC);
	end component ProgramCounter;
	
	component IF_Regs is
		Port (Next_PC_in : in  STD_LOGIC_VECTOR (15 downto 0);
				Next_PC_out : out  STD_LOGIC_VECTOR (15 downto 0); 
				clk : in  STD_LOGIC;
				enable : in STD_LOGIC);
	end component IF_Regs;
	
	component ID_RF_Regs is 
		Port (Current_PC_in : in  STD_LOGIC_VECTOR (15 downto 0); 
				Current_PC_out : out  STD_LOGIC_VECTOR (15 downto 0); 
				Next_PC_in : in  STD_LOGIC_VECTOR (15 downto 0);
				Next_PC_out : out  STD_LOGIC_VECTOR (15 downto 0); 
				IMM_in : in  STD_LOGIC_VECTOR (15 downto 0);
				IMM_out : out  STD_LOGIC_VECTOR (15 downto 0);
				OPCODE_in : in  STD_LOGIC_VECTOR (4 downto 0);
				OPCODE_out : out  STD_LOGIC_VECTOR (4 downto 0); 
				UNIT_SEL_in : in  STD_LOGIC_VECTOR (1 downto 0);
				UNIT_SEL_out : out  STD_LOGIC_VECTOR (1 downto 0); 
				DA_in : in  STD_LOGIC_VECTOR (2 downto 0);
				DA_out : out  STD_LOGIC_VECTOR (2 downto 0); 
				A_in : in  STD_LOGIC_VECTOR (15 downto 0);
				A_out : out  STD_LOGIC_VECTOR (15 downto 0);
			   B_in : in  STD_LOGIC_VECTOR (15 downto 0);
				B_out : out  STD_LOGIC_VECTOR (15 downto 0);
				WE_in : in  STD_LOGIC;
				WE_out : out  STD_LOGIC;
				SEL_OUT_in : in  STD_LOGIC_VECTOR (1 downto 0);
				SEL_OUT_out : out  STD_LOGIC_VECTOR (1 downto 0);
				MEM_WRITE_in : in  STD_LOGIC;
				MEM_WRITE_out : out  STD_LOGIC;
				jump_opcode_in : in  STD_LOGIC_VECTOR (13 downto 0);
				jump_opcode_out : out  STD_LOGIC_VECTOR (13 downto 0); 
				flags_en_in : in  STD_LOGIC_VECTOR (3 downto 0);
				flags_en_out : out  STD_LOGIC_VECTOR (3 downto 0); 
				enable_jump_in : in  STD_LOGIC;
				enable_jump_out : out  STD_LOGIC;
				clk : in  STD_LOGIC;
				enable : in STD_LOGIC);
	end component ID_RF_Regs;
		
	component EX_MEM_Regs is 
		Port (Next_PC_in : in  STD_LOGIC_VECTOR (15 downto 0); 
			Next_PC_out : out  STD_LOGIC_VECTOR (15 downto 0); 
			C_in : in  STD_LOGIC_VECTOR (15 downto 0);
			C_out : out  STD_LOGIC_VECTOR (15 downto 0); 
			WE_in : in  STD_LOGIC;
			WE_out : out  STD_LOGIC;
			S_in : in  STD_LOGIC_VECTOR (15 downto 0);
			S_out : out  STD_LOGIC_VECTOR (15 downto 0);
			DA_in : in  STD_LOGIC_VECTOR (2 downto 0);
			DA_out : out  STD_LOGIC_VECTOR (2 downto 0);
			MUX_WB_in : in STD_LOGIC_VECTOR(1 downto 0);
			MUX_WB_out : out STD_LOGIC_VECTOR(1 downto 0);			
			clk : in  STD_LOGIC;
			enable : in STD_LOGIC
			);
	end component EX_MEM_regs;
	
	component FSM_Regs is
		Port( START : in STD_LOGIC;
			ENABLE_IF : out STD_LOGIC;
			ENABLE_IF_RF : out STD_LOGIC;
			ENABLE_EX_MEM : out STD_LOGIC;
			ENABLE_PC : out STD_LOGIC;
			PRINT : in STD_LOGIC;
			CLK : in STD_LOGIC
	);
	end component FSM_Regs;
		
	signal opcde : STD_LOGIC_VECTOR(4 downto 0);
	signal opcde_2 : STD_LOGIC_VECTOR(4 downto 0);
	signal instr : STD_LOGIC_VECTOR (15 downto 0);
	signal instr_2 : STD_LOGIC_VECTOR (15 downto 0);
	signal imediato : STD_LOGIC_VECTOR(15 downto 0);
	signal imediato_2 : STD_LOGIC_VECTOR(15 downto 0);
	signal sel_unid : STD_LOGIC_VECTOR(1 downto 0);
	signal sel_unid_2 : STD_LOGIC_VECTOR(1 downto 0);
	signal da1,aa1,ba1 : STD_LOGIC_VECTOR(2 downto 0);
	signal da1_2 : STD_LOGIC_VECTOR(2 downto 0);
	signal da1_3 : STD_LOGIC_VECTOR(2 downto 0);
	signal wenable : STD_LOGIC;
	signal wenable_2 : STD_LOGIC;
	signal wenable_3 : STD_LOGIC;
	signal a_v,b_v : STD_LOGIC_VECTOR(15 downto 0);
	signal a_v_2,b_v_2 : STD_LOGIC_VECTOR(15 downto 0);
	signal writedata : STD_LOGIC_VECTOR(15 downto 0);
	signal Flags_alu : STD_LOGIC_VECTOR(3 downto 0);
	signal consts : STD_LOGIC_VECTOR(15 downto 0);
	signal consts_2 : STD_LOGIC_VECTOR(15 downto 0);
	signal Alu_S : STD_LOGIC_VECTOR(15 downto 0);
	signal Alu_S_2 : STD_LOGIC_VECTOR(15 downto 0);
	signal MUXWB : STD_LOGIC_VECTOR(1 downto 0);
	signal MUXWB_2 : STD_LOGIC_VECTOR(1 downto 0);
	signal MUXWB_3 : STD_LOGIC_VECTOR(1 downto 0);
	signal mem_dados : STD_LOGIC_VECTOR(15 downto 0);
	signal mem_dados_2 : STD_LOGIC_VECTOR(15 downto 0);
	signal MEM_EN : STD_LOGIC;
	signal MEM_EN_2 : STD_LOGIC;
	signal jump_opc : STD_LOGIC_VECTOR(13 downto 0);
	signal jump_opc_2 : STD_LOGIC_VECTOR(13 downto 0);
	signal PCm1 : STD_LOGIC_VECTOR(15 downto 0);
	signal PCm1_2 : STD_LOGIC_VECTOR(15 downto 0);
	signal PCm1_3 : STD_LOGIC_VECTOR(15 downto 0);
	signal PCm1_4 : STD_LOGIC_VECTOR(15 downto 0);	
	signal addr : STD_LOGIC_VECTOR(15 downto 0);
	signal fl_en : STD_LOGIC_VECTOR(3 downto 0);
	signal fl_en_2 : STD_LOGIC_VECTOR(3 downto 0);
	signal jpen : STD_LOGIC;
	signal jpen_2 : STD_LOGIC;
	signal IFaddr : STD_LOGIC_VECTOR(15 downto 0);
	signal IFaddr_2 : STD_LOGIC_VECTOR(15 downto 0);
	signal IFaddr_3 : STD_LOGIC_VECTOR(15 downto 0);
	signal en_lvl1 : STD_LOGIC;
	signal en_lvl2 : STD_LOGIC;
	signal en_lvl3 : STD_LOGIC;
	signal en_pc : STD_LOGIC;
	signal ram_print : STD_LOGIC;
	
	begin

	Decoder_Inst: decoder port map(
		INSTRUCTION => instr,
		OPCODE => opcde,
		IMM => imediato,
		UNIT_SEL => sel_unid,
		DA => da1,
		AA => aa1,
		BA => ba1,
		WE => wenable,
		SEL_OUT => MUXWB,
		MEM_WRITE => MEM_EN,
		jump_opcode => jump_opc,
		flags_en => fl_en,
		enable_jump => jpen
	);

	Constante : constantes port map(
		Const => imediato_2,
		C_in => a_v,
		C => consts,
		OP_SEL => sel_unid_2
	);

	RegFile : registerfile port map(
		AA => aa1,
		A => a_v,
		BA => ba1,
		B => b_v,
		DA => da1_3,
		WE => wenable_3,
		DATA => writedata,
		clk => CLK
	);

	ALU_OP : alu port map(
		OP_SEL => opcde_2,
		A => a_v_2,
		B => b_v_2,
		S => Alu_S,
		Flags => Flags_alu
	);

	WB_Mux : writeback_mux port map(
		ALU => Alu_S_2,
		MEM => mem_dados,
		Consts => consts_2,
		PC => PCm1_4,		
		Sel_WB => MUXWB_3,	
		C => writedata
	);
	RAM : rom_instrc port map(
		clk => CLK,
	   we =>MEM_EN_2,
	   addr_instr => IFaddr,
	   addr_dados => a_v_2,
	   din => b_v_2,
	   dout_instr => instr,
	   dout_dados => mem_dados,
		print => ram_print
	);
	
	Flags_Jumps : Flags port map(
		clk => CLK,
		Flags => Flags_alu,
		enable_flags => fl_en_2,
		enable_jump => jpen_2,
		jump_info => jump_opc_2,
		PCm1 => PCm1_3,
		RB => b_v,
		output_address => addr
	);
	
	PC : ProgramCounter port map(
		next_PC => addr,
		enable_pc => en_pc,
		PC => IFaddr,
		PCm1 => PCm1,
		clk => CLK
	);
	
	IF_Registers : IF_Regs port map(
		Next_PC_in => PCm1,
		Next_PC_out => PCm1_2,
		clk => CLK,
		enable => en_lvl1
	);
	
	ID_RF_Registers : ID_RF_Regs port map(
		Current_PC_in => IFaddr_2, 
		Current_PC_out => IFaddr_3,
		Next_PC_in => PCm1_2,
		Next_PC_out => PCm1_3,
		IMM_in => imediato,
		IMM_out => imediato_2,
		OPCODE_in =>opcde,
		OPCODE_out =>opcde_2, 
		UNIT_SEL_in => sel_unid,
		UNIT_SEL_out => sel_unid_2, 
		DA_in => da1,
		DA_out => da1_2, 
   	A_in => a_v,
		A_out => a_v_2,
		B_in => b_v,
		B_out => b_v_2,
		WE_in => wenable,
		WE_out => wenable_2,
		SEL_OUT_in => MUXWB,
		SEL_OUT_out => MUXWB_2,
		MEM_WRITE_in => MEM_EN,
		MEM_WRITE_out => MEM_EN_2,
		jump_opcode_in => jump_opc,
		jump_opcode_out => jump_opc_2, 
		flags_en_in => fl_en,
		flags_en_out => fl_en_2,
		enable_jump_in => jpen,
		enable_jump_out => jpen_2,
		clk => CLK,
		enable => en_lvl2	
	);
	
	EX_MEM_Registers : EX_MEM_Regs port map(
		WE_in => wenable_2, 
		WE_out => wenable_3,
		Next_PC_in => PCm1_3,	
		Next_PC_out => PCm1_4,	
		C_in => consts,
		C_out => consts_2,
		S_in => Alu_S,
		S_out => Alu_S_2,
		DA_in => da1_2,
		DA_out => da1_3,
		MUX_WB_in => MUXWB_2,
		MUX_WB_out => MUXWB_3,
		clk => CLK,
		enable => en_lvl3
	);
	
	FSM : FSM_Regs port map(
		START => TEST1,
		PRINT => ram_print,
		ENABLE_IF => en_lvl1,
		ENABLE_IF_RF => en_lvl2,
		ENABLE_EX_MEM => en_lvl3,
		ENABLE_PC => en_pc,
		CLK => CLK
	);
	
	TEST <= writedata;
	MEMORY <= instr;
	INST_NB <= IFaddr;
	PRINT <= ram_print;
end Behavioral;

