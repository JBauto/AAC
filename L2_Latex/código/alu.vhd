----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:38:43 03/02/2015 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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

entity alu is
	Port (OP_SEL : in  STD_LOGIC_VECTOR (4 downto 0);
			A : in  STD_LOGIC_VECTOR (15 downto 0);
			B : in  STD_LOGIC_VECTOR (15 downto 0);
			S : out  STD_LOGIC_VECTOR (15 downto 0);
			Flags : out  STD_LOGIC_VECTOR (3 downto 0));
end alu;

architecture Behavioral of alu is
	component arithmetic_unit
		port(
		A : in  STD_LOGIC_VECTOR (15 downto 0);
		B : in  STD_LOGIC_VECTOR (15 downto 0);
		C : out  STD_LOGIC_VECTOR (15 downto 0);
		OP : in  STD_LOGIC_VECTOR (2 downto 0);
		Flags : out  STD_LOGIC_VECTOR (3 downto 0));
	end component arithmetic_unit;
	component logic_unit
		port ( 
		A : in  STD_LOGIC_VECTOR (15 downto 0);
		B : in  STD_LOGIC_VECTOR (15 downto 0);
		C : out  STD_LOGIC_VECTOR (15 downto 0);
		OP : in  STD_LOGIC_VECTOR (3 downto 0);
		Flags : out  STD_LOGIC_VECTOR (3 downto 0));
	end component logic_unit;
	component arith_logic_shift is
		port ( 
		A : in  STD_LOGIC_VECTOR (15 downto 0);
		C : out  STD_LOGIC_VECTOR (15 downto 0);
		OP : in  STD_LOGIC;
		Flags : out  STD_LOGIC_VECTOR (3 downto 0));
	end component arith_logic_shift;

	signal S_arith, S_logic, S_shift : STD_LOGIC_VECTOR (15 downto 0);
	signal Flags_arith, Flags_shift, Flags_logic : STD_LOGIC_VECTOR (3 downto 0);
begin
--Arithmetic Unit							00XXX
arith: arithmetic_unit port map(
	A=>A,
	B=>B,
	C=>S_arith,
	OP=>OP_SEL(2 downto 0),
	Flags=>Flags_arith);
--Arithmetic and Logic Shift Unit	01XXX
shift: arith_logic_shift port map(
	A=>A,
	C=>S_shift,
	OP=>OP_SEL(0),
	Flags=>Flags_shift);
--Logic Unit								10XXX or 11XXX
logic: logic_unit port map(
	A=>A,
	B=>B,
	C=>S_logic,
	OP=>OP_SEL(3 downto 0),
	Flags=>Flags_logic);

	S <= S_arith when OP_SEL(4 downto 3)="00" else
		  S_shift when OP_SEL(4 downto 3)="01" else
		  S_logic;
	
	Flags <= Flags_arith when OP_SEL(4 downto 3)="00" else
				Flags_shift when OP_SEL(4 downto 3)="01" else
				Flags_logic;
end Behavioral;