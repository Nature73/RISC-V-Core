library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity mem_store is 
    Port ( 
        ADDR_W     : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
        DATA_W     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        is_byte    : IN  STD_LOGIC;
        is_half    : IN  STD_LOGIC;
        data_mask  : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
        data_value : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     );
end mem_store;


architecture arch of mem_store is

   SIGNAL S_STORE_W : STD_LOGIC_VECTOR( 31 DOWNTO 0);
   SIGNAL S_STORE_H : STD_LOGIC_VECTOR( 31 DOWNTO 0);
   SIGNAL S_STORE_B : STD_LOGIC_VECTOR( 31 DOWNTO 0);

begin

   S_STORE_W <= DATA_W;
   S_STORE_H <= DATA_W(15 DOWNTO 0) & DATA_W(15 DOWNTO 0);
   S_STORE_B <= DATA_W(7 DOWNTO 0) & DATA_W(7 DOWNTO 0) & DATA_W(7 DOWNTO 0) & DATA_W(7 DOWNTO 0);

   data_value <= S_STORE_W when is_byte = '0' and is_half = '0' else
                 S_STORE_H when is_byte = '0' and is_half = '1' else
                 S_STORE_B;
               
   data_mask <= "1111" when is_byte = '0' and is_half = '0' else
                "0011" when is_half = '1' and ADDR_W = "00" else
                "1100" when is_half = '1' and ADDR_W = "10" else
                "0001" when ADDR_W = "00" else -- For the bytes, the mask depends on the address
                "0010" when ADDR_W = "01" else
                "0100" when ADDR_W = "10" else
                "1000";
   
end arch;
