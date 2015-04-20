library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity decoder is
    Port (	INSTRUCTION : in  STD_LOGIC_VECTOR (15 downto 0);
			   IMM  : out  STD_LOGIC_VECTOR (15 downto 0); -- 10-0 quando 01XXX; 7-0 quando 11XXX
			   OPCODE : out  STD_LOGIC_VECTOR (4 downto 0);
			   UNIT_SEL : out STD_LOGIC_VECTOR(1 downto 0);
			   DA : out STD_LOGIC_VECTOR(2 downto 0);
			   AA : out STD_LOGIC_VECTOR(2 downto 0);
			   BA : out STD_LOGIC_VECTOR(2 downto 0);
			   WE : out STD_LOGIC;
			   SEL_OUT : out STD_LOGIC_VECTOR(1 downto 0);
			   MEM_WRITE : out STD_LOGIC;
				PRINT : out STD_LOGIC;
				jump_opcode : out STD_LOGIC_VECTOR(13 downto 0);
				flags_en : out STD_LOGIC_VECTOR(3 downto 0);
				--PC_enable : out STD_LOGIC;
				enable_jump : out STD_LOGIC
		      );
end decoder;

architecture Behavioral of decoder is
	signal instruct : STD_LOGIC_VECTOR(15 downto 0);
	signal format : STD_LOGIC_VECTOR(1 downto 0);
	signal imm_temp : STD_LOGIC_VECTOR(15 downto 0);
begin
	instruct <= INSTRUCTION;
	format <= instruct(15) & instruct(14);
	jump_opcode <= instruct(13 downto 0);
	
	--select unit inside alu
	UNIT_SEL <= instruct(10 downto 9) when format = "10" else
					instruct(15) & instruct(10) when format = "11" or format = "01" else
					(others =>'0');
	
	DA <= (others => '1') when instruct(15 downto 11)="00110" else
			instruct(13 downto 11);
	
	AA <= instruct(13 downto 11) when format = "01" or format = "11" else
			instruct(5 downto 3);
	
	BA <= instruct(2 downto 0);
	
	OPCODE <= instruct(10 downto 6) when format = "10" or format = "00" else
				 (others =>'0');
	
	imm_temp(10 downto 0) <= instruct(10 downto 0) when format = "01" else
									 instruct(7) & instruct(7) & instruct(7) & instruct(7 downto 0) when format = "11" else 
									 (others =>'0');

	imm_temp(15 downto 11) <= (others => imm_temp(10));
	IMM <= imm_temp;
	
	--write enable for register file
	WE <= '1' when instruct(15 downto 11)="00110" else	-- Jump and Link
			'1' when instruct(15 downto 14)="10" and instruct(10 downto 6)="01010" else	-- load c, a
			'1' when instruct(15 downto 14)="01" or instruct(15 downto 14)="11" else	-- Constantes
			'1' when instruct(15 downto 14)="10" and instruct(10 downto 7)/="0101" else	-- ALU
			'0';
	
	--write back mux select
	SEL_OUT <= "00" when instruct(15 downto 14)="10" and 	instruct(10 downto 7) /= "0101" else	--ALU
				  "01" when instruct(15 downto 14)="10" else														--MEM
				  "10" when instruct(14)='1' else																	--Const
				  "11";																										--PC
	
	--flags_enable
	--Z
	flags_en(3) <='0' when instruct(15 downto 14)/="10" else
					  '0' when instruct(10 downto 7)="0101" else
					  '0' when instruct(10 downto 6)="10000" else
					  '0' when instruct(10 downto 6)="10011" else
					  '0' when instruct(10 downto 6)="11111" else
					  '1';
	--S
	flags_en(2) <='0' when instruct(15 downto 14)/="10" else
					  '0' when instruct(10 downto 7)="0101" else
					  '0' when instruct(10 downto 6)="10000" else
					  '0' when instruct(10 downto 6)="10011" else
					  '0' when instruct(10 downto 6)="11111" else
					  '1';
	--C
	flags_en(1) <='0' when instruct(15 downto 14)/="10" else
					  '0' when instruct(10 downto 7)="0101" else
					  '0' when instruct(10)='1' else
					  '1';
	--V
	flags_en(0) <='1' when instruct(15 downto 14)="10" and instruct(10 downto 9)="00" else
					  '0';
	
	enable_jump <= '1' when instruct(15 downto 14)="00" else
						'0';
						
--	PC_enable <= '0' when enable_jump='1' else
--					 '1';
						
	MEM_WRITE <= '1' when format = "10" and instruct(10 downto 6) = "01011" else
			       '0';
	
	PRINT <= '1' when instruct = X"2FFF" else
				'0';
	
end Behavioral;