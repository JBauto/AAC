----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:34:24 03/14/2015 
-- Design Name: 
-- Module Name:    ID_RF_Regs - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_RF_Regs is
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
			MEM_WRITE_in : in STD_LOGIC;
			MEM_WRITE_out : out  STD_LOGIC;
			jump_opcode_in : in  STD_LOGIC_VECTOR (13 downto 0);
			jump_opcode_out : out  STD_LOGIC_VECTOR (13 downto 0); 
			flags_en_in : in  STD_LOGIC_VECTOR (3 downto 0);
			flags_en_out : out  STD_LOGIC_VECTOR (3 downto 0);
			format_in : in STD_LOGIC_VECTOR(1 downto 0);
			format_out : out STD_LOGIC_VECTOR(1 downto 0);
			forw_const_const_in : in  STD_LOGIC;
			forw_const_const_out : out  STD_LOGIC;
			forw_alu_alu_a_in : in  STD_LOGIC;
			forw_alu_alu_a_out : out  STD_LOGIC;
			forw_alu_alu_b_in : in  STD_LOGIC;
			forw_alu_alu_b_out : out  STD_LOGIC;
			forw_const_alu_in : in  STD_LOGIC;
			forw_const_alu_out : out  STD_LOGIC;
			forw_alu_const_a_in : in  STD_LOGIC;
			forw_alu_const_a_out : out  STD_LOGIC;
			forw_alu_const_b_in : in  STD_LOGIC;
			forw_alu_const_b_out : out  STD_LOGIC;
			enable_jump_in : in  STD_LOGIC;
			enable_jump_out : out  STD_LOGIC;
			clk : in  STD_LOGIC;
			enable : in STD_LOGIC);
end ID_RF_Regs;

architecture Behavioral of ID_RF_Regs is
begin

	Next_PC_out <= Next_PC_in when enable = '1' else
						(others =>'0');

	process (clk)
	begin
   if clk'event and clk='1' then
		if enable = '1' then
			Current_PC_out <= Current_PC_in;
			--Next_PC_out <= Next_PC_in;
			OPCODE_out <= OPCODE_in;
			IMM_out <= IMM_in;
			UNIT_SEL_out <= UNIT_SEL_in;
			A_out <= A_in;
			B_out <= B_in;
			WE_out <= WE_in;
			SEL_OUT_out <= SEL_OUT_in;
			MEM_WRITE_out <= MEM_WRITE_in;
			jump_opcode_out <= jump_opcode_in;
			flags_en_out <= flags_en_in;
			enable_jump_out <= enable_jump_in;
			DA_out <= DA_in;
			AA_out <= AA_in;
			BA_out <= BA_in;
			format_out <= format_in;
			forw_alu_alu_a_out <= forw_alu_alu_a_in;
			forw_alu_alu_b_out <= forw_alu_alu_b_in;
			forw_const_const_out <= forw_const_const_in;
			forw_const_alu_out <= forw_const_alu_in;
			forw_alu_const_a_out <= forw_alu_const_a_in;
			forw_alu_const_b_out <= forw_alu_const_b_in;
 		end if;
   end if;
end process;
end Behavioral;

