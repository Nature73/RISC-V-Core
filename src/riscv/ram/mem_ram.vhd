library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.riscv_types.all;
use work.riscv_config.all;

entity mem_ram is 
	Port (
		CLOCK   : IN  STD_LOGIC;
		ADDR_RW : IN  STD_LOGIC_VECTOR(RAM_ADDR-1  DOWNTO 0);
		ENABLE  : IN  STD_LOGIC;
		WRITE_M : IN  STD_LOGIC_VECTOR(          3 DOWNTO 0);
		DATA_W  : IN  STD_LOGIC_VECTOR(RAM_WIDTH-1 DOWNTO 0);
		DATA_R  : OUT STD_LOGIC_VECTOR(RAM_WIDTH-1 DOWNTO 0)
	);
end mem_ram;


architecture arch of mem_ram is

TYPE   ram_type IS ARRAY (0 TO (RAM_DEPTH-1)) OF STD_LOGIC_VECTOR (RAM_WIDTH-1 DOWNTO 0);

	signal memory : ram_type := (
		0 => x"3b305b1b",
		1 => x"006d3233",
		2 => x"3b305b1b",
		3 => x"006d3133",
		4 => x"3b305b1b",
		5 => x"006d3733",
		6 => x"29494928",
		7 => x"6d6f4320",
		8 => x"61747570",
		9 => x"6e6f6974",
		10 => x"20666f20",
		11 => x"61204950",
		12 => x"69727070",
		13 => x"69746178",
		14 => x"00006e6f",
		15 => x"2079614d",
		16 => x"32203932",
		17 => x"00363230",
		18 => x"29494928",
		19 => x"6d6f4320",
		20 => x"616c6970",
		21 => x"6e6f6974",
		22 => x"74616420",
		23 => x"203a2065",
		24 => x"000a7325",
		25 => x"303a3731",
		26 => x"37343a34",
		27 => x"00000000",
		28 => x"29494928",
		29 => x"6d6f4320",
		30 => x"616c6970",
		31 => x"6e6f6974",
		32 => x"6d697420",
		33 => x"203a2065",
		34 => x"000a7325",
		35 => x"29494928",
		36 => x"00000000",
		37 => x"29494928",
		38 => x"6d754e20",
		39 => x"20726562",
		40 => x"6420666f",
		41 => x"74696769",
		42 => x"203a2073",
		43 => x"000a6425",
		44 => x"29494928",
		45 => x"6d654d20",
		46 => x"2079726f",
		47 => x"746f6f66",
		48 => x"6e697270",
		49 => x"00000074",
		50 => x"29494928",
		51 => x"50202d20",
		52 => x"69642049",
		53 => x"73746967",
		54 => x"20202020",
		55 => x"3a202020",
		56 => x"20642520",
		57 => x"000a426b",
		58 => x"29494928",
		59 => x"49202d20",
		60 => x"7265746e",
		61 => x"206c616e",
		62 => x"756c6176",
		63 => x"3a207365",
		64 => x"20642520",
		65 => x"000a426b",
		66 => x"20202020",
		67 => x"2e332020",
		68 => x"00000000",
		69 => x"6435250a",
		70 => x"00207c20",
		71 => x"0020200a",
		72 => x"33323130",
		73 => x"37363534",
		74 => x"42413938",
		75 => x"46454443",
		others => x"00000000"
	);

	SIGNAL R_ADDR : STD_LOGIC_VECTOR(RAM_ADDR-2-1 DOWNTO 0); -- -2 bits because 32b words and not bytes

begin

	R_ADDR <= ADDR_RW(RAM_ADDR-1 DOWNTO 2); -- -2 bits because 32b words and not bytes

	PROCESS (CLOCK)
	BEGIN
		IF (CLOCK'event AND CLOCK = '1') THEN
			if ENABLE = '1' then
				DATA_R <= memory( to_integer(UNSIGNED(R_ADDR)) );
			end if;
		END IF;
	END PROCESS;

	process(CLOCK)
		VARIABLE addr : integer;
	begin
		if rising_edge(CLOCK) then
			if ENABLE = '1' then
				addr := TO_INTEGER( unsigned(R_ADDR) );
				if WRITE_M(0) = '1' then memory( addr )( 7 downto  0) <= DATA_W( 7 downto  0); end if;
				if WRITE_M(1) = '1' then memory( addr )(15 downto  8) <= DATA_W(15 downto  8); end if;
				if WRITE_M(2) = '1' then memory( addr )(23 downto 16) <= DATA_W(23 downto 16); end if;
				if WRITE_M(3) = '1' then memory( addr )(31 downto 24) <= DATA_W(31 downto 24); end if;
			end if;
		end if;
	end process;

end arch;
