library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package FULL_MEMORY is 
type RamType is array(0 to 65535) of STD_LOGIC_VECTOR(15 downto 0);
end package FULL_MEMORY;