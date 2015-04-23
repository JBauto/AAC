----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:43:45 03/15/2015 
-- Design Name: 
-- Module Name:    EX_MEM_Regs - Behavioral 
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

entity EX_MEM_Regs is
	Port (Next_PC_in : in  STD_LOGIC_VECTOR (15 downto 0);	--alterado
			Next_PC_out : out  STD_LOGIC_VECTOR (15 downto 0);	--alterado
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
			INSTR_dataHazard_in : in STD_LOGIC_VECTOR(9 downto 0);
			INSTR_dataHazard_out : out STD_LOGIC_VECTOR(9 downto 0);
			enable : in STD_LOGIC
			);
end EX_MEM_Regs;

architecture Behavioral of EX_MEM_Regs is
signal C_out_2 :  STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal WE_out_2 : STD_LOGIC := '0';
signal S_out_2 :  STD_LOGIC_VECTOR(15 downto 0):= (others => '0');
signal DA_out_2 :  STD_LOGIC_VECTOR(2 downto 0):= (others => '0');
signal MUX_WB_out_2 :  STD_LOGIC_VECTOR(1 downto 0):= (others => '0');
signal INSTR_dataHazard_out_2 :  STD_LOGIC_VECTOR(9 downto 0):= (others => '0');


begin

	Next_PC_out <= Next_PC_in when enable = '1' else
						(others =>'0');

process (clk,enable)
	begin
   if rising_edge(clk) then
		if enable = '1' then
			--Next_PC_out <= Next_PC_in;
			C_out_2 <= C_in;
			WE_out_2 <= WE_in;
			S_out_2 <= S_in;
			DA_out_2 <= DA_in;
			MUX_WB_out_2 <= MUX_WB_in;
			INSTR_dataHazard_out_2 <= INSTR_dataHazard_in;
		end if;
   end if;
end process;

		C_out <= C_out_2;
		WE_out <= WE_out_2;
		S_out <= S_out_2;
		DA_out <= DA_out_2;
		MUX_WB_out <= MUX_WB_out_2;
		INSTR_dataHazard_out <= INSTR_dataHazard_out_2;

end Behavioral;

