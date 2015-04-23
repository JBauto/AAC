----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:11:48 03/11/2015 
-- Design Name: 
-- Module Name:    cpu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cpu is
   Port( CLK, TEST1 : in STD_LOGIC;
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
				PRINT : out STD_LOGIC;
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
			  print : in std_logic;
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
	
	component ProgramCounter 
		port(next_PC : in  STD_LOGIC_VECTOR (15 downto 0);
			  enable_pc : in  STD_LOGIC;
			  PC : out  STD_LOGIC_VECTOR (15 downto 0);
			  PCm1 : out  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in  STD_LOGIC);
	end component ProgramCounter;
	
	component IF_Regs 
		Port (--Current_PC_in : in  STD_LOGIC_VECTOR (15 downto 0); 
				--Current_PC_out : out  STD_LOGIC_VECTOR (15 downto 0); 
				Next_PC_in : in  STD_LOGIC_VECTOR (15 downto 0);
				Next_PC_out : out  STD_LOGIC_VECTOR (15 downto 0); 
				--OPCODE_in : in  STD_LOGIC_VECTOR (15 downto 0);
				--OPCODE_out : out  STD_LOGIC_VECTOR (15 downto 0); 
				clk : in  STD_LOGIC;
				enable : in STD_LOGIC);
	end component IF_Regs;
	
	component ID_RF_Regs 
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
				AA_in : in  STD_LOGIC_VECTOR (2 downto 0);
				AA_out : out  STD_LOGIC_VECTOR (2 downto 0);
				BA_in : in  STD_LOGIC_VECTOR (2 downto 0);
				BA_out : out  STD_LOGIC_VECTOR (2 downto 0);
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
				format_in : in STD_LOGIC_VECTOR(1 downto 0);
			   format_out : out STD_LOGIC_VECTOR(1 downto 0);
--				forw_const_const_in : in  STD_LOGIC;
--				forw_const_const_out : out  STD_LOGIC;
--				forw_alu_alu_a_in : in  STD_LOGIC;
--				forw_alu_alu_a_out : out  STD_LOGIC;
--				forw_alu_alu_b_in : in  STD_LOGIC;
--				forw_alu_alu_b_out : out  STD_LOGIC;
--				forw_const_alu_in : in  STD_LOGIC;
--				forw_const_alu_out : out  STD_LOGIC;
--				forw_alu_const_a_in : in  STD_LOGIC;
--				forw_alu_const_a_out : out  STD_LOGIC;
--				forw_alu_const_b_in : in  STD_LOGIC;
--				forw_alu_const_b_out : out  STD_LOGIC;
--				forw_const_mem_in : in  STD_LOGIC;
--				forw_const_mem_out : out  STD_LOGIC;
--				forw_mem_const_a_in : in  STD_LOGIC;
--				forw_mem_const_a_out : out  STD_LOGIC;
--				forw_mem_const_d_in : in  STD_LOGIC;
--				forw_mem_const_d_out : out  STD_LOGIC;
--				forw_mem_alu_d_in : in  STD_LOGIC;
--				forw_mem_alu_d_out : out  STD_LOGIC;
--				forw_mem_alu_a_in : in  STD_LOGIC;
--				forw_mem_alu_a_out : out  STD_LOGIC;
--				forw_alu_mem_a_in : in STD_LOGIC;
--				forw_alu_mem_a_out : out STD_LOGIC;
--				forw_alu_mem_b_in : in STD_LOGIC;
--				forw_alu_mem_b_out : out STD_LOGIC;
				enable_jump_in : in  STD_LOGIC;
				enable_jump_out : out  STD_LOGIC;
				clk : in  STD_LOGIC;
				enable : in STD_LOGIC);
	end component ID_RF_Regs;
		
	component EX_MEM_Regs  
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
			MEM_in : in STD_LOGIC_VECTOR (15 downto 0);
			MEM_out : out STD_LOGIC_VECTOR (15 downto 0);	
			MUX_WB_in : in STD_LOGIC_VECTOR(1 downto 0);
			MUX_WB_out : out STD_LOGIC_VECTOR(1 downto 0);
			INSTR_dataHazard_in : in STD_LOGIC_VECTOR(9 downto 0);
			INSTR_dataHazard_out : out STD_LOGIC_VECTOR(9 downto 0);		
			clk : in  STD_LOGIC;
			enable : in STD_LOGIC
		);
	end component EX_MEM_regs;
	
	component FSM_Regs 
		Port( START : in STD_LOGIC;
			ENABLE_IF : out STD_LOGIC;
			ENABLE_IF_RF : out STD_LOGIC;
			ENABLE_EX_MEM : out STD_LOGIC;
			ENABLE_PC : out STD_LOGIC;
			CLK : in STD_LOGIC
	);
	end component FSM_Regs;
	
	component DataHazardUnit 
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
	end component DataHazardUnit;
		
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
	signal PCm1_4 : STD_LOGIC_VECTOR(15 downto 0);	--alterado
	signal addr : STD_LOGIC_VECTOR(15 downto 0);
	signal fl_en : STD_LOGIC_VECTOR(3 downto 0);
	signal fl_en_2 : STD_LOGIC_VECTOR(3 downto 0);
	signal jpen : STD_LOGIC;
	signal jpen_2 : STD_LOGIC;
	signal IFaddr : STD_LOGIC_VECTOR(15 downto 0);
	signal IFaddr_2 : STD_LOGIC_VECTOR(15 downto 0);
	signal IFaddr_3 : STD_LOGIC_VECTOR(15 downto 0);
	--alterado
	signal en_lvl1 : STD_LOGIC;
	signal en_lvl2 : STD_LOGIC;
	signal en_lvl3 : STD_LOGIC;
	signal en_pc : STD_LOGIC;
	signal ram_print : STD_LOGIC;
	--forward alu-alu
	signal MUX_ALU_A : STD_LOGIC;
	signal MUX_ALU_B : STD_LOGIC;
	signal entrada_alu_a : STD_LOGIC_VECTOR(15 downto 0);
	signal entrada_alu_b : STD_LOGIC_VECTOR(15 downto 0);
	signal format_out_2 : STD_LOGIC_VECTOR(1 downto 0);
	signal instr_exmem : STD_LOGIC_VECTOR(9 downto 0);
	signal aa_dh : STD_LOGIC_VECTOR(2 downto 0);
	signal ba_dh : STD_LOGIC_VECTOR(2 downto 0);
	signal tmp : STD_LOGIC_VECTOR(9 downto 0);
	signal tmp_2 : STD_LOGIC_VECTOR(9 downto 0);

	--forward constantes
	signal mux_sel_const : STD_LOGIC;
	signal mux_sel_const_2 : STD_LOGIC;
	signal mux_alu_a_2 : STD_LOGIC;
	signal mux_alu_b_2 : STD_LOGIC;
	signal mux_const : STD_LOGIC_VECTOR(15 downto 0);
	--forward constantes - alu
	signal mux_sel_const_alu : STD_LOGIC;
	signal mux_sel_const_alu_2 : STD_LOGIC;
	signal mux_const_alu : STD_LOGIC;
	--forward alu - constantes
	signal mux_sel_alu_const_a : STD_LOGIC;
	signal mux_sel_alu_const_b : STD_LOGIC;	
	signal mux_sel_alu_const_a_2 : STD_LOGIC;
	signal mux_sel_alu_const_b_2 : STD_LOGIC;
	--forward constantes-mem
	signal mux_sel_const_mem : STD_LOGIC;
	signal mux_sel_const_mem_2 : STD_LOGIC;
	--forward mem-constantes
	signal mux_sel_mem_const_a : STD_LOGIC;
	signal mux_sel_mem_const_a_2 : STD_LOGIC;
	signal mux_sel_mem_const_d : STD_LOGIC;
	signal mux_sel_mem_const_d_2 : STD_LOGIC;
	signal mux_mem_const_d : STD_LOGIC_VECTOR(15 downto 0);
	signal mux_mem_const_a : STD_LOGIC_VECTOR(15 downto 0);
	--forward mem-alu
	signal mux_sel_mem_alu_a : STD_LOGIC;
	signal mux_sel_mem_alu_a_2 : STD_LOGIC;
	signal mux_sel_mem_alu_d : STD_LOGIC;
	signal mux_sel_mem_alu_d_2 : STD_LOGIC;
	--forward alu-mem
	signal mux_sel_alu_mem_a : STD_LOGIC;
	signal mux_sel_alu_mem_a_2 : STD_LOGIC;
	signal mux_sel_alu_mem_b : STD_LOGIC;
	signal mux_sel_alu_mem_b_2 : STD_LOGIC;
	
	signal tmp_3 : STD_LOGIC_VECTOR(9 downto 0); 
	
	
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
		enable_jump => jpen,
		print => ram_print
	);

	Constante : constantes port map(
		Const => imediato_2,
		C_in => mux_const,
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
		MEM => mem_dados_2,
		Consts => consts_2,
		PC => PCm1_4,		-- alterado
		Sel_WB => MUXWB_3,	-- change	-->	MUXWB
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
		--Current_PC_in => IFaddr,
		--Current_PC_out => IFaddr_2, 
		Next_PC_in => PCm1,
		Next_PC_out => PCm1_2,
		--OPCODE_in => instr,
		--OPCODE_out => instr_2,
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
		AA_in => aa1,
		AA_out => aa_dh,
		BA_out => ba_dh,
		BA_in => ba1,
   	A_in => entrada_alu_a,
		A_out => a_v_2,
		B_in => entrada_alu_b,
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
		format_in => instr(15 downto 14),
		format_out => format_out_2,
--		forw_alu_alu_a_in => MUX_ALU_A,
--		forw_alu_alu_b_in => MUX_ALU_B,
--		forw_alu_alu_b_out => mux_alu_b_2,
--		forw_alu_alu_a_out => mux_alu_a_2,
--		forw_const_const_in => mux_sel_const,
--		forw_const_const_out => mux_sel_const_2,
--		forw_const_alu_in => mux_sel_const_alu,
--		forw_const_alu_out => mux_sel_const_alu_2,
--		forw_alu_const_a_in => mux_sel_alu_const_a,
--		forw_alu_const_b_in => mux_sel_alu_const_b,
--		forw_alu_const_a_out => mux_sel_alu_const_a_2,
--		forw_alu_const_b_out => mux_sel_alu_const_b_2,
--		forw_const_mem_in => mux_sel_const_mem,
--		forw_const_mem_out => mux_sel_const_mem_2,
--		forw_mem_const_a_in => mux_sel_mem_const_a,
--		forw_mem_const_a_out => mux_sel_mem_const_a_2,
--		forw_mem_const_d_in => mux_sel_mem_const_d,
--		forw_mem_const_d_out => mux_sel_mem_const_d_2,
--		forw_mem_alu_a_in =>	mux_sel_mem_alu_a,
--		forw_mem_alu_a_out => mux_sel_mem_alu_a_2,
--		forw_mem_alu_d_in => mux_sel_mem_alu_d,
--		forw_mem_alu_d_out => mux_sel_mem_alu_d_2,
--		forw_alu_mem_a_in => mux_sel_alu_mem_a,
--		forw_alu_mem_a_out => mux_sel_alu_mem_a_2,
--		forw_alu_mem_b_in => mux_sel_alu_mem_b,
--		forw_alu_mem_b_out => mux_sel_alu_mem_b_2,
		clk => CLK,
		enable => en_lvl2	
	);
	
	EX_MEM_Registers : EX_MEM_Regs port map(
		WE_in => wenable_2, 
		WE_out => wenable_3,
		Next_PC_in => PCm1_3,	--alterado
		Next_PC_out => PCm1_4,	--alterado
		C_in => consts,
		C_out => consts_2,
		S_in => Alu_S,
		S_out => Alu_S_2,
		DA_in => da1_2,
		DA_out => da1_3,
		MUX_WB_in => MUXWB_2,
		MUX_WB_out => MUXWB_3,
		MEM_in => mem_dados,
		MEM_out => mem_dados_2,
		INSTR_dataHazard_in => tmp,
		INSTR_dataHazard_out => tmp_3,
		clk => CLK,
		enable => en_lvl3
	);
	
	FSM : FSM_Regs port map(
		START => TEST1,
		ENABLE_IF => en_lvl1,
		ENABLE_IF_RF => en_lvl2,
		ENABLE_EX_MEM => en_lvl3,
		ENABLE_PC => en_pc,
		CLK => CLK
	);
	
	DataHazard : DataHazardUnit port map(
		OPCODE => tmp_2,
		OPCODE_EXMEM => tmp,
		OPCODE_WB => (others =>'0'),
		DA_WB => (others=>'0'),
		AA => aa1, 
		BA => ba1,
		MUX_ALU_A => MUX_ALU_A,
		MUX_ALU_B => MUX_ALU_B,
		FORWARD_CONST => mux_sel_const,
		FORWARD_CONST_ALU => mux_sel_const_alu,
		FORWARD_ALU_CONST_A => mux_sel_alu_const_a,
		FORWARD_ALU_CONST_B => mux_sel_alu_const_b,
		FORWARD_CONST_MEM => mux_sel_const_mem,
		FORWARD_MEM_CONST_ADDRESS => mux_sel_mem_const_a,
		FORWARD_MEM_CONST_DATA => mux_sel_mem_const_d,
		FORWARD_MEM_ALU_ADDRESS => mux_sel_mem_alu_a,
		FORWARD_MEM_ALU_DATA => mux_sel_mem_alu_d,
		FORWARD_ALU_MEM_DATA_A => mux_sel_alu_mem_a,
		FORWARD_ALU_MEM_DATA_B => mux_sel_alu_mem_b
	);
	
	TEST <= writedata;
	
	entrada_alu_a <= Alu_S when mux_alu_a = '1' or mux_sel_mem_alu_a = '1' or mux_sel_const_alu = '1' else
						  consts when mux_sel_alu_const_a = '1' or mux_sel_mem_const_a = '1' or mux_sel_const ='1' else
						  mem_dados when mux_sel_alu_mem_a = '1' or mux_sel_const_mem = '1' else
						  a_v;
						  
	entrada_alu_b <= Alu_S when mux_alu_b = '1' or mux_sel_mem_alu_d = '1' else
						  consts when mux_sel_alu_const_b = '1' or mux_sel_mem_const_d='1' else
						  mem_dados when mux_sel_alu_mem_b = '1' else
						  b_v;
						  
	tmp <= format_out_2 & da1_2 & opcde_2;
	tmp_2 <= instr(15 downto 14) & da1 & opcde;
	
--	mux_const <= consts when mux_sel_const_2 ='1' else
--					 Alu_S when mux_sel_const_alu_2 ='1' else
--					 mem_dados when mux_sel_const_mem_2 = '1' else
--					 a_v;
	
--	mux_mem_const_a <= consts when mux_sel_mem_const_a_2 = '1' else
--							 Alu_S when mux_sel_mem_alu_a_2 = '1' else
--							 a_v;
--	
--	mux_mem_const_d <= consts when mux_sel_mem_const_d_2='1' else
--							 Alu_S when mux_sel_mem_alu_d_2 = '1' else
--							 IFaddr;
	
end Behavioral;

