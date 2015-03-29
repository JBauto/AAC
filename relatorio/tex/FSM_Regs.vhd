
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.all;
use STD.TEXTIO;
use IEEE.STD_LOGIC_TEXTIO.all;


entity FSM_Regs is
	Port( START : in STD_LOGIC;
			PRINT : in STD_LOGIC;
			ENABLE_IF : out STD_LOGIC;
			ENABLE_IF_RF : out STD_LOGIC;
			ENABLE_EX_MEM : out STD_LOGIC;
			ENABLE_PC : out STD_LOGIC;
			CLK : in STD_LOGIC
	);
end FSM_Regs;

architecture Behavioral of FSM_Regs is
	type fsm_states is (INIT, IF_level, IF_RF_level, EX_MEM_level, WB_level, IF2_level, WR_FILE);
	signal curr_state, next_state : fsm_states;
	signal counter : integer := 0;
	signal start2 : std_logic := '1';
	signal stop_print : std_logic := '0';
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
	
	process(curr_state, START,start2,print, stop_print)
	file output: TEXT open write_mode is "ram_out.txt";
	variable my_line : LINE;
	begin 
		next_state <= curr_state;
		
		case curr_state is 
			when INIT =>
				ENABLE_IF <= '0';
				ENABLE_PC <= '0';
				ENABLE_IF_RF <= '0';
				ENABLE_EX_MEM <= '0';
				
				if START = '1' and start2 = '1' then
					next_state <= IF_level;
				end if;
				
				if print = '1' and stop_print = '0' then
					next_state <= WR_FILE;
				end if;
				
			when IF_level =>
				ENABLE_IF <= '0';
				ENABLE_PC <= '0';
				ENABLE_IF_RF <= '0';
				ENABLE_EX_MEM <= '0';
				
				if print = '1' and stop_print = '0' then
					next_state <= WR_FILE;
				else
					next_state <= IF_RF_level;
				end if;
				
			when IF2_level =>
				ENABLE_IF <= '0';
				ENABLE_PC <= '1';
				ENABLE_IF_RF <= '0';
				ENABLE_EX_MEM <= '0';
				
				if print = '1' and stop_print = '0' then
					next_state <= WR_FILE;
				else
					next_state <= IF_RF_level;
				end if;
				
			when IF_RF_level => 
				ENABLE_IF <= '1';
				ENABLE_PC <= '0';
				ENABLE_IF_RF <= '0';
				ENABLE_EX_MEM <= '0';
				
				if print = '1' and stop_print = '0' then
					next_state <= WR_FILE;
				else				
					next_state <= EX_MEM_level;
				end if;
				
			when EX_MEM_level =>
				
				ENABLE_IF <= '0';
				ENABLE_PC <= '0';
				ENABLE_IF_RF <= '1';
				ENABLE_EX_MEM <= '0';
				
				if print = '1' and stop_print = '0' then
					next_state <= WR_FILE;
				else				
					next_state <= WB_level;
				end if;
				
			when WB_level =>
				ENABLE_IF <= '0';
				ENABLE_PC <= '0';
				ENABLE_IF_RF <= '0';
				ENABLE_EX_MEM <= '1';
				
				if print = '1' and stop_print = '0' then
					next_state <= WR_FILE;
				else				
					next_state <= IF2_level;
				end if;
				
			when WR_FILE =>
				ENABLE_IF <= '0';
				ENABLE_PC <= '0';
				ENABLE_IF_RF <= '0';
				ENABLE_EX_MEM <= '0';

				start2 <= '0';
				stop_print <= '1';
				next_state <= INIT;
				
		end case;
	end process;
			

end Behavioral;

