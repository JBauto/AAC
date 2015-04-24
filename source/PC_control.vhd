library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Flags is
    Port ( clk : in  STD_LOGIC;
           Flags : in  STD_LOGIC_VECTOR (3 downto 0);
			  enable_flags : in  STD_LOGIC_VECTOR (3 downto 0);
           enable_jump : in  STD_LOGIC;
           jump_info : in  STD_LOGIC_VECTOR (13 downto 0);
			  PCm1 : in STD_LOGIC_VECTOR (15 downto 0);
			  RB : in STD_LOGIC_VECTOR (15 downto 0);
           output_address : out  STD_LOGIC_VECTOR (15 downto 0);
			  predbits : in STD_LOGIC_VECTOR (1 downto 0);
			  jump_override : out  STD_LOGIC;
			  taken : out  STD_LOGIC);
end Flags;

architecture Behavioral of Flags is
	signal Z,S,C,V : STD_LOGIC := '0';
	signal Cond_Status : STD_LOGIC := '0';
	signal OP : STD_LOGIC_VECTOR(1 downto 0):= (others=>'0');
	signal COND : STD_LOGIC_VECTOR(3 downto 0):= (others=>'0');
	signal Destino : STD_LOGIC_VECTOR(15 downto 0):= (others=>'0'); 
	signal address : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal offset : STD_LOGIC_VECTOR(15 downto 0):= (others=>'0');
	signal tken : STD_LOGIC := '0';
begin
	
	-- Flag Registers
	Z <= Flags(3) when enable_flags(3)='1' and rising_edge(clk);
	S <= Flags(2) when enable_flags(2)='1' and rising_edge(clk);
	C <= Flags(1) when enable_flags(1)='1' and rising_edge(clk);
	V <= Flags(0) when enable_flags(0)='1' and rising_edge(clk);
	
	OP <= jump_info(13 downto 12);
	COND <= jump_info(11 downto 8);
	
	Cond_Status <= '1' when COND="0000" else
						V when COND="0011" else
						S when COND="0100" else
						Z when COND="0101" else
						C when COND="0110" else
						S or Z when COND="0111" else
						'0';
	
	offset <= jump_info(11) & jump_info(11) & jump_info(11) & jump_info(11) & jump_info(11 downto 0) when OP="10" else
				 jump_info(7) & jump_info(7) & jump_info(7) & jump_info(7) & jump_info(7) & jump_info(7) & jump_info(7) & jump_info(7) & jump_info(7 downto 0);
	
	Destino <= RB when OP="11" else
				  PCm1 + offset;
	
	address <= Destino when enable_jump='1' and (Cond_Status xnor OP(0))='1' else
				  Destino when enable_jump='1' and OP(1)='1' else
				  PCm1;
	
	tken <= '1' when OP(1)='1' else
			  '1' when enable_jump='1' and (Cond_Status xnor OP(0))='1' else
			  '0';
	
	taken <= tken;
	
	jump_override <= '0' when OP(1)='1' else
						  '1' when tken/=predbits(1) else
						  '0';
	
	output_address <= address;
	
end Behavioral;

