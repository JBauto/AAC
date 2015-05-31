----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:32:50 03/09/2015 
-- Design Name: 
-- Module Name:    constantes - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity constantes is
    Port ( Const : in  STD_LOGIC_VECTOR (15 downto 0);
           C_in : in  STD_LOGIC_VECTOR (15 downto 0);
           C : out  STD_LOGIC_VECTOR (15 downto 0);
           OP_SEL : in  STD_LOGIC_VECTOR (1 downto 0));
end constantes;

architecture Behavioral of constantes is
	signal Cand : STD_LOGIC_VECTOR (15 downto 0);
begin
	Cand <= C_in and X"FF00" when OP_SEL(0)='0' else
			  C_in and X"00FF";
	C <= Const when OP_SEL(1)='0' else
		  X"00" & Const(7 downto 0) or Cand when OP_SEL(0)='0' else
		  Const(7 downto 0) & X"00" or Cand;

end Behavioral;

