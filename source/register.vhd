----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:59:01 03/02/2015 
-- Design Name: 
-- Module Name:    register - Behavioral 
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

entity registerfile is
	Port (AA : in  STD_LOGIC_VECTOR (2 downto 0);
			A : out  STD_LOGIC_VECTOR (15 downto 0);
			BA : in  STD_LOGIC_VECTOR (2 downto 0);
			B : out  STD_LOGIC_VECTOR (15 downto 0);
			DA : in  STD_LOGIC_VECTOR (2 downto 0);
			WE : in  STD_LOGIC;
			DATA : in  STD_LOGIC_VECTOR (15 downto 0);
			clk : in STD_LOGIC);
end registerfile;

architecture Behavioral of registerfile is
		signal R0, R1, R2, R3, R4, R5, R6, R7 : std_logic_vector(15 downto 0) := (others=>'0');
begin
		A<=R0 when AA="000" else
			R1 when AA="001" else
			R2 when AA="010" else
			R3 when AA="011" else
			R4 when AA="100" else
			R5 when AA="101" else
			R6 when AA="110" else
			R7;
		
		B<=R0 when BA="000" else
			R1 when BA="001" else
			R2 when BA="010" else
			R3 when BA="011" else
			R4 when BA="100" else
			R5 when BA="101" else
			R6 when BA="110" else
			R7;
		
		R0 <= DATA when DA="000" and WE='1' and falling_edge(clk);
		R1 <= DATA when DA="001" and WE='1' and falling_edge(clk);
		R2 <= DATA when DA="010" and WE='1' and falling_edge(clk);
		R3 <= DATA when DA="011" and WE='1' and falling_edge(clk);
		R4 <= DATA when DA="100" and WE='1' and falling_edge(clk);
		R5 <= DATA when DA="101" and WE='1' and falling_edge(clk);
		R6 <= DATA when DA="110" and WE='1' and falling_edge(clk);
		R7 <= DATA when DA="111" and WE='1' and falling_edge(clk);

end Behavioral;

