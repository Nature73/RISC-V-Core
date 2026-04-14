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
		0 => x"29696928",
		1 => x"0000000a",
		2 => x"29696928",
		3 => x"4c454820",
		4 => x"77204f4c",
		5 => x"646c726f",
		6 => x"000a2120",
		7 => x"29696928",
		8 => x"74654c20",
		9 => x"20656d20",
		10 => x"72746e69",
		11 => x"6375646f",
		12 => x"796d2065",
		13 => x"666c6573",
		14 => x"2049202c",
		15 => x"74206d61",
		16 => x"42206568",
		17 => x"5a696572",
		18 => x"49522048",
		19 => x"562d4353",
		20 => x"00000a2e",
		21 => x"29696928",
		22 => x"6c657220",
		23 => x"65736165",
		24 => x"000a3a20",
		25 => x"29696928",
		26 => x"00000020",
		27 => x"20727041",
		28 => x"32203431",
		29 => x"00363230",
		30 => x"333a3131",
		31 => x"38343a33",
		32 => x"00000000",
		33 => x"692e2e2e",
		34 => x"2e2e6963",
		35 => x"0000002e",
		36 => x"33323130",
		37 => x"37363534",
		38 => x"42413938",
		39 => x"46454443",
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
