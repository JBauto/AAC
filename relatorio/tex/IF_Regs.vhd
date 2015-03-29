----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:17:56 03/14/2015 
-- Design Name: 
-- Module Name:    IF_Regs - Behavioral 
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

entity IF_Regs is
	Port (Next_PC_in : in  STD_LOGIC_VECTOR (15 downto 0);
			Next_PC_out : out  STD_LOGIC_VECTOR (15 downto 0); 
			clk : in  STD_LOGIC;
			enable : in STD_LOGIC
			);
end IF_Regs;

architecture Behavioral of IF_Regs is
begin
	process (clk)
	begin
   if clk'event and clk='1' then
		if enable = '1' then
			Next_PC_out <= Next_PC_in;
		end if;
   end if;
end process;

end Behavioral;

