library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity writeback_mux is
	Port (ALU : in  STD_LOGIC_VECTOR (15 downto 0);
			MEM : in  STD_LOGIC_VECTOR (15 downto 0);
			Consts : in  STD_LOGIC_VECTOR (15 downto 0);
			PC : in  STD_LOGIC_VECTOR (15 downto 0);
			Sel_WB : in  STD_LOGIC_VECTOR (1 downto 0);
			C : out  STD_LOGIC_VECTOR (15 downto 0)
			);
end writeback_mux;

architecture Behavioral of writeback_mux is
	
begin
	
	C <= ALU when Sel_WB="00" else
		  MEM when Sel_WB="01" else
		  Consts when Sel_WB="10" else
		  PC;
	
end Behavioral;

