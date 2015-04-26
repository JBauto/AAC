library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity targetbuff is
    generic ( btb_bits: integer :=7);	--if changed also change in ControlHazard.vhd
	 Port ( clk : in STD_LOGIC;
           LSB : in  STD_LOGIC_VECTOR (btb_bits-1 downto 0);
           TAG : out  STD_LOGIC_VECTOR (15-btb_bits downto 0);
           jump_addr : out  STD_LOGIC_VECTOR (15 downto 0);
           branch_pred : out  STD_LOGIC_VECTOR (1 downto 0);
			  we1 : in STD_LOGIC;
			  data1 : in STD_LOGIC_VECTOR(33-btb_bits downto 0);
			  we2 : in STD_LOGIC;
			  addr2 : in STD_LOGIC_VECTOR (btb_bits-1 downto 0);
			  data2 : in STD_LOGIC_VECTOR(33-btb_bits downto 0));
end targetbuff;

architecture Behavioral of targetbuff is
																						--15-btb_bits + 16 + 2
	type ram_type is array(0 to (2**btb_bits)-1) of STD_LOGIC_VECTOR(33-btb_bits downto 0);
	signal BTB : ram_type := (others => (others => '0'));
	signal data : STD_LOGIC_VECTOR(33-btb_bits downto 0);
	signal pred_bits : STD_LOGIC_VECTOR (1 downto 0);
begin
	---------------Read----------------
	data <= BTB(conv_integer(LSB));
	TAG <= data(33-btb_bits downto 18);
	jump_addr <= data(17 downto 2);
	pred_bits <= data(1 downto 0);
	--00	strong	!taken
	--01	weak		!taken
	--10	weak		taken
	--11	strong	taken
	branch_pred <= pred_bits;
	
	
	---------------Write----------------------
	process (clk, we1)
   begin
      if rising_edge(clk) then
			if we1='1' then
				BTB(conv_integer(LSB)) <= data1;
			end if;
			if we2 = '1' then
				BTB(conv_integer(addr2)) <= data2;
			end if;
      end if;
   end process;
	

end Behavioral;

