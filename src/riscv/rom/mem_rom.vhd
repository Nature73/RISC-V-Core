library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.riscv_types.all;
use work.riscv_config.all;

entity mem_rom is 
	Port ( 
		CLOCK   : IN  STD_LOGIC;
		ENABLE  : IN  STD_LOGIC;
		ADDR_R  : IN  STD_LOGIC_VECTOR(ROM_ADDR-1  DOWNTO 0); -- -2 bits because 32b words and not bytes
		DATA_O  : OUT STD_LOGIC_VECTOR(ROM_WIDTH-1 DOWNTO 0)
	);
end mem_rom;


architecture arch of mem_rom is

	TYPE rom_type IS ARRAY (0 TO (ROM_DEPTH-1)) OF STD_LOGIC_VECTOR (ROM_WIDTH-1 DOWNTO 0);

	signal memory : rom_type := (
		0 => x"06000737",
		1 => x"00a72023",
		2 => x"00008067",
		3 => x"000047b7",
		4 => x"0d000737",
		5 => x"40078793",
		6 => x"00f72023",
		7 => x"04800693",
		8 => x"060007b7",
		9 => x"00d7a023",
		10 => x"06500693",
		11 => x"00d7a023",
		12 => x"06c00693",
		13 => x"00d7a023",
		14 => x"00d7a023",
		15 => x"06f00693",
		16 => x"00d7a023",
		17 => x"00a00693",
		18 => x"00d7a023",
		19 => x"04400793",
		20 => x"00f72023",
		21 => x"00100073",
		22 => x"0000006f",
		others => x"00000000"
	);

    SIGNAL ADDR   : STD_LOGIC_VECTOR(ROM_ADDR-2-1 DOWNTO 0); -- -2 bits because 32b words and not bytes

begin

    ADDR <= ADDR_R(ROM_ADDR-1 DOWNTO 2); -- -2 bits because 32b words and not bytes

    PROCESS (CLOCK)
    BEGIN
        IF (CLOCK'event AND CLOCK = '1') THEN
            IF ENABLE = '1' THEN
                DATA_O <= memory( to_integer(UNSIGNED(ADDR)) );
            END IF;
        END IF;
    END PROCESS;

end arch;
