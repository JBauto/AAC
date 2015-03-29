----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:46:21 03/02/2015 
-- Design Name: 
-- Module Name:    arithmetic_unit - Behavioral 
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


entity arithmetic_unit is
	Port (A : in  STD_LOGIC_VECTOR (15 downto 0);
			B : in  STD_LOGIC_VECTOR (15 downto 0);
			C : out  STD_LOGIC_VECTOR (15 downto 0);
			OP : in  STD_LOGIC_VECTOR (2 downto 0);
			Flags : out  STD_LOGIC_VECTOR (3 downto 0));	--ZSCV
end arithmetic_unit;

architecture Behavioral of arithmetic_unit is
	signal C_extra : STD_LOGIC_VECTOR (16 downto 0);
	signal operB, operB2, Cin : STD_LOGIC_VECTOR (15 downto 0);
begin
	-- C_extra <= A+B when OP="000" else
			   -- A+B+1 when OP="001" else
			   -- A+1 when OP="011" else
			   -- A-B-1 when OP="100" else 
			   -- A-B when OP="101" else
			   -- A-1;
	
	operB <= B when OP(2 downto 1)="00" else
				-B when OP(2 downto 1)="10" else
				(others=>'0');
	Cin <= X"0001" when OP(2)='0' and OP(0)='1' else
			 X"FFFF" when OP(2)='1' and OP(0)='0' else
			 (others=>'0');
	operB2 <= operB+Cin;
	C_extra <= ('0'& A)+('0' & operB2);
	
	
	C <= C_extra(15 downto 0);
	
	--Zero
	Flags(3) <= not(C_extra(15) or C_extra(14) or C_extra(13) or C_extra(12) or C_extra(11) or C_extra(10) or C_extra(9) or C_extra(8) or C_extra(7) or C_extra(6) or C_extra(5) or C_extra(4) or C_extra(3) or C_extra(2) or C_extra(1) or C_extra(0));
	--Sign
	Flags(2) <= C_extra(15);
	--Carry
	Flags(1) <= C_extra(16);
	--oVerflow
	Flags(0) <= ((A(15) xnor operB2(15)) and (A(15) xor C_extra(15))) or ((operB(15) xnor Cin(15)) and (operB(15) xor operB2(15)));
	
end Behavioral;

