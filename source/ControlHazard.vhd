library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ControlHazard is
    generic ( btb_bits: integer :=7);	--if changed also change in BTB.vhd
	 Port ( clk : in STD_LOGIC;
           PC : in  STD_LOGIC_VECTOR (15 downto 0);
           PCm1 : in  STD_LOGIC_VECTOR (15 downto 0);
           Opcode : in  STD_LOGIC_VECTOR (15 downto 0);
			  RB : in  STD_LOGIC_VECTOR (15 downto 0);
			  jump_en : out STD_LOGIC;
           jump_dest : out  STD_LOGIC_VECTOR (15 downto 0);
			  ----to/from flags----
			  flag_addr : in STD_LOGIC_VECTOR (15 downto 0);
			  flag_taken : in STD_LOGIC;
			  flag_write : in STD_LOGIC;
			  flag_predbits : in STD_LOGIC_VECTOR(1 downto 0);
			  flag_true_jumpaddr : in  STD_LOGIC_VECTOR (15 downto 0);
			  bits : out STD_LOGIC_VECTOR(1 downto 0));
end ControlHazard;

architecture Behavioral of ControlHazard is
	component targetbuff is
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
	end component targetbuff;
	
	component predbuff is
	Port ( current_bits : in  STD_LOGIC_VECTOR (1 downto 0);
			 taken : in  STD_LOGIC;
			 new_bits : out  STD_LOGIC_VECTOR (1 downto 0));
	end component predbuff;

	signal destino, BTB_jump_address : STD_LOGIC_VECTOR (15 downto 0);
	signal formato, OP, current_bits, update_bits : STD_LOGIC_VECTOR (1 downto 0);
	signal prediction, we_notfound : STD_LOGIC;
	signal MSB, TAG : STD_LOGIC_VECTOR (15-btb_bits downto 0);
	signal LSB : STD_LOGIC_VECTOR (btb_bits-1 downto 0);
	signal newjumpInfo, flagcorrection : STD_LOGIC_VECTOR(33-btb_bits downto 0);
begin

	BTB: targetbuff port map(
		clk => clk,
		LSB => LSB,
		TAG => TAG,
		jump_addr => BTB_jump_address,
		branch_pred => current_bits,
		we1 => we_notfound,
		data1 => newjumpInfo,
		we2 => flag_write,
		addr2 => flag_addr(btb_bits-1 downto 0),
		data2 => flagcorrection
	);
	
	BPB: predbuff port map(
		current_bits => flag_predbits,
		taken => flag_taken,
		new_bits => update_bits
	);

	---------------------------------------------------------------------------------

	formato <= Opcode(15 downto 14);
	OP <= Opcode(13 downto 12);
	MSB <= PC(15 downto btb_bits);
	LSB <= PC(btb_bits-1 downto 0);
	destino <= Opcode(11) & Opcode(11) & Opcode(11) & Opcode(11) & Opcode(11 downto 0) when OP="10" else
				  Opcode(7) & Opcode(7) & Opcode(7) & Opcode(7) & Opcode(7) & Opcode(7) & Opcode(7) & 
			Opcode(7) & Opcode(7 downto 0);
	prediction <= current_bits(1);
	
	--what happens when destino/=BTB_jump_address?????
	jump_en <= '0' when formato/="00" else			--not a jump, never taken
				  '1' when OP(1)='1' else				--inconditional jump, always taken
				  prediction when MSB=TAG else		--conditional jump, check BTB
				  '0';										--Not Taken
	jump_dest <= PCm1+destino when OP="10" else	--inconditional jump
					 RB when OP="11" else				--jump to register value
					 BTB_jump_address;					--jump to BTB value
	bits <= current_bits when MSB=TAG else
			  "01";
	
	---------------Update BTB if not found----------------
	we_notfound <= '1' when formato="00" and MSB/=TAG else
						'0';
	newjumpInfo <= MSB & PCm1 & "01";
	
	---------------Correction from Flags------------------
	flagcorrection <= flag_addr(15 downto btb_bits) & flag_true_jumpaddr & update_bits;
	
end Behavioral;

