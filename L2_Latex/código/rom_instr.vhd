
--
-- Initializing Block RAM from external data file
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use STD.TEXTIO.all;
use STD.TEXTIO;
use IEEE.STD_LOGIC_TEXTIO.all;

entity rom_instrc is
	port(print : in std_logic;
		  clk : in std_logic;
	     we : in std_logic;
		  addr_instr : in std_logic_vector(15 downto 0);
		  addr_dados : in std_logic_vector(15 downto 0);
		  din : in std_logic_vector(15 downto 0);
		  dout_instr : out std_logic_vector(15 downto 0);
		  dout_dados : out std_logic_vector(15 downto 0));
	end rom_instrc;

architecture Behavioral of rom_instrc is
   type RamType is array(0 to 65535) of STD_LOGIC_VECTOR(15 downto 0);
   impure function InitRamFromFile (RamFileName : in string) return RamType is
		file INFILE : TEXT  is in "demo_lab1_2.txt";
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
	
--	impure function InitRamToFile (ram : in RamType) return integer is
--		file my_output : TEXT open WRITE_MODE is "ram_out.txt";
--      -- above declaration should be in architecture declarations for multiple
--      variable my_line : LINE;
--      variable my_output_line : LINE;
--		variable i : integer := 0;
--		
--		begin
--      if print='1' then
--		  --write(my_line, string'("writing file"));
--        --writeline(output, my_line);
--        --write(my_output_line, string'("output from file_io.vhdl"));
--        --writeline(my_output, my_output_line);
--        hwrite(my_output_line, ram(0));    -- or any other stuff
--        writeline(my_output, my_output_line);
--      end if;
--	return 0;
--   end function;
	
signal RAM : RamType := InitRamFromFile("rom4.txt");
--signal teste : integer := InitRamToFile(RAM);
signal dados : STD_LOGIC_VECTOR(15 downto 0);
signal instr: STD_LOGIC_VECTOR(15 downto 0);
begin
   process (clk)
   begin
      if clk'event and clk = '1' then
			if we ='1' then 
				RAM(conv_integer(dados)) <= din;
			end if;
      end if;
   end process;
	
	dados <= addr_dados(15 downto 0);
	instr <= addr_instr(15 downto 0);
	
	dout_instr <= RAM(conv_integer(instr)); -- REVER
	dout_dados <= RAM(conv_integer(dados)); -- REVER
	
--	write_file:
--    process (print,RAM) is    -- write file_io.out (when done goes to '1')
--      file my_output : TEXT open WRITE_MODE is "ram_out.txt";
--      -- above declaration should be in architecture declarations for multiple
--      variable my_line : LINE;
--      variable my_output_line : LINE;
--		variable i : integer := 0;
--    begin
--      if print='1' then
--		  --write(my_line, string'("writing file"));
--        --writeline(output, my_line);
--        --write(my_output_line, string'("output from file_io.vhdl"));
--        --writeline(my_output, my_output_line);
--        hwrite(my_output_line, RAM(0));    -- or any other stuff
--        writeline(my_output, my_output_line);
--      end if;
--    end process write_file;
	
end Behavioral;
