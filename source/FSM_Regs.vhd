----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:58:22 03/15/2015 
-- Design Name: 
-- Module Name:    FSM_Regs - Behavioral 
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

entity FSM_Regs is
	Port( START : in STD_LOGIC;
			ENABLE_IF : out STD_LOGIC;
			ENABLE_IF_RF : out STD_LOGIC;
			ENABLE_EX_MEM : out STD_LOGIC;
			ENABLE_PC : out STD_LOGIC;
			CLK : in STD_LOGIC
	);
end FSM_Regs;

architecture Behavioral of FSM_Regs is
	type fsm_states is (INIT, IF_level, IF_RF_level, EX_MEM_level, WB_level, IF2_level);
	signal curr_state, next_state : fsm_states;
	signal counter : integer := 0;
begin

	process (clk)
		begin
			if clk'event and clk = '1' then
				if START = '0' then 	
					curr_state <= INIT;
				else
					curr_state <= next_state;
				end if;
			end if;
	end process ;
	
	process(curr_state, START)
	begin 
		next_state <= curr_state;
		
		case curr_state is 
			when INIT =>
				ENABLE_IF <= '1';
				ENABLE_PC <= '0';
				ENABLE_IF_RF <= '1';
				ENABLE_EX_MEM <= '1';
				
				if START = '1' then
					next_state <= IF_level;
				end if;
			
			when IF_level =>
				ENABLE_IF <= '1';
				ENABLE_PC <= '1';
				ENABLE_IF_RF <= '1';
				ENABLE_EX_MEM <= '1';
				
				next_state <= IF_RF_level;
				
			when IF2_level =>
				ENABLE_IF <= '1';
				ENABLE_PC <= '1';
				ENABLE_IF_RF <= '1';
				ENABLE_EX_MEM <= '1';
				
				next_state <= IF_RF_level;
				
			when IF_RF_level => 
				ENABLE_IF <= '1';
				ENABLE_PC <= '1';
				ENABLE_IF_RF <= '1';
				ENABLE_EX_MEM <= '1';
				
				next_state <= EX_MEM_level;
				
			when EX_MEM_level =>
				
				ENABLE_IF <= '1';
				ENABLE_PC <= '1';
				ENABLE_IF_RF <= '1';
				ENABLE_EX_MEM <= '1';
				
				next_state <= WB_level;
				
			when WB_level =>
				ENABLE_IF <= '1';
				ENABLE_PC <= '1';
				ENABLE_IF_RF <= '1';
				ENABLE_EX_MEM <= '1';
				
				next_state <= IF2_level;
			
		end case;
	end process;
			

end Behavioral;

