--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:31:17 03/15/2015
-- Design Name:   
-- Module Name:   C:/AAC/AAC_L1_v9/v7/cpu_teste.vhd
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cpu_teste IS
END cpu_teste;
 
ARCHITECTURE behavior OF cpu_teste IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cpu
    PORT(
         CLK : IN  std_logic;
         TEST1 : IN  std_logic;
         TEST : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal TEST1 : std_logic := '0';
	signal counter : std_logic_vector(63 downto 0) := (others=>'0');
 	--Outputs
   signal TEST : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          CLK => CLK,
          TEST1 => TEST1,
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

		TEST1 <= '1' after 10ns;
	

      wait;
   end process;
	
	process(clk)
	begin
		if TEST1 = '1' then
			if rising_edge(clk) then
				counter <= counter + 1;
			end if;
		end if;
	end process;

END;
