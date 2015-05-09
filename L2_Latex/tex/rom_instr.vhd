
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use STD.TEXTIO.all;
use STD.TEXTIO;
use IEEE.STD_LOGIC_TEXTIO.all;


entity rom_instrc is
	port(clk : in std_logic;

	     we : in std_logic;
		  addr_instr : in std_logic_vector(15 downto 0);
		  addr_dados : in std_logic_vector(15 downto 0);
		  din : in std_logic_vector(15 downto 0);
		  dout_instr : out std_logic_vector(15 downto 0);
		  dout_dados : out std_logic_vector(15 downto 0);
		  print : out std_logic);
	end rom_instrc;

architecture Behavioral of rom_instrc is
  type RamType is array(0 to 65535) of STD_LOGIC_VECTOR(15 downto 0);
   impure function InitRamFromFile (RamFileName : in string) return RamType is
		file INFILE : TEXT  is in "demo_lab1_3.txt";
		variable DATA_TEMP : STD_LOGIC_VECTOR(15 downto 0);	
		variable IN_LINE: LINE;
		variable RAM : RamType;
		variable index :integer;

		begin			 
			  index := 0;
			  while NOT(endfile(INFILE)) loop
					readline(INFILE,IN_LINE);	
					hread(IN_LINE, DATA_TEMP);
					RAM(index) := DATA_TEMP;
					index := index + 1;
			  end loop;
			  for index in index to 65535 loop
					RAM(index) := X"0000";
			  end loop;
	return RAM;
   end function;
	
	
signal RAM : RamType := InitRamFromFile("demo_lab1_3.txt");
signal dados : STD_LOGIC_VECTOR(15 downto 0);
signal instr: STD_LOGIC_VECTOR(15 downto 0);
begin
   process (clk)
   begin
      if clk'event and clk = '1' then
			if we ='1' then 
				RAM(conv_integer(dados)) <= din;
			end if;
         dout_instr <= RAM(conv_integer(instr)); 
			dout_dados <= RAM(conv_integer(dados)); 
      end if;
   end process;
	
	dados <= '0' & addr_dados(14 downto 0);
	instr <= '0' & addr_instr(14 downto 0);
	print <= '1' when RAM(conv_integer(instr)) = X"2FFF" else
				'0';

end Behavioral;
