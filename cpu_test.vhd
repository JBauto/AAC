--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:49:46 03/13/2015
-- Design Name:   
-- Module Name:   C:/Users/public.SCDEEC/Downloads/AAC_L1_v5/AAC_L1/cpu_test.vhd
-- Project Name:  AAC_L1
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cpu_test IS
END cpu_test;
 
ARCHITECTURE behavior OF cpu_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cpu
    PORT(
         INSTRUCTION : IN  std_logic_vector(15 downto 0);
         CLK : IN  std_logic;
         TEST : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal INSTRUCTION : std_logic_vector(15 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal TEST : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 5 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          INSTRUCTION => INSTRUCTION,
          CLK => CLK,
          TEST => TEST
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 
						--  10 WC OP  RA RB
		INSTRUCTION <= "1011110101110000" after 10ns,
							"1011110011000101" after 20ns,
							"1011000001110101" after 30ns,
							"0000000000000000" after 40ns;

		wait;
   end process;

END;
