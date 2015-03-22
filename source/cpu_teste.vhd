--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:40:28 03/22/2015
-- Design Name:   
-- Module Name:   C:/AAC/AAC_L1/cpu_Teste.vhd
-- Project Name:  v7
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cpu
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use STD.TEXTIO.all;
use STD.TEXTIO;
use IEEE.STD_LOGIC_TEXTIO.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cpu_Teste IS
END cpu_Teste;
 
ARCHITECTURE behavior OF cpu_Teste IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cpu
    PORT(
         CLK : IN  std_logic;
         TEST1 : IN  std_logic;
			PRINT : OUT std_logic;
         MEMORY : OUT  std_logic_vector(15 downto 0);
         INST_NB : OUT  std_logic_vector(15 downto 0);
         TEST : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal TEST1 : std_logic := '0';

 	--Outputs
   signal MEMORY : std_logic_vector(15 downto 0);
   signal INST_NB : std_logic_vector(15 downto 0);
   signal TEST : std_logic_vector(15 downto 0);
   signal PRINT : std_logic;
	-- Clock period definitions
   constant CLK_period : time := 10 ns;
   signal teste2 : std_logic := '0';
	signal memoria : std_logic_vector(15 downto 0);
	signal counter : integer := 0;
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          CLK => CLK,
          TEST1 => TEST1,
          MEMORY => MEMORY,
          INST_NB => INST_NB,
          TEST => TEST,
			 PRINT => PRINT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
	--counter <= INST_NB;
	teste2 <= TEST1;
	memoria <= MEMORY;
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;
		
		TEST1 <= '1' after 10ns;
		
      wait;
   end process;
	
--	process(counter,memoria)
--	file output: TEXT open write_mode is "ram_out.txt";
--	variable my_line : LINE;
--	begin 
--		if print = '0' then 
--			write(my_line, counter);
--			write(my_line, string'(" : "));
--			write(my_line, memoria);
--			writeline(output, my_line);
--		end if;
--	end process;
--	
--	process(clk)
--	begin
--		if clk'event and clk = '1' and print = '0' then
--				counter <= counter + 1;
--		end if;
--	end process;
END;
