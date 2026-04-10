library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

use work.riscv_config.all;

entity mem_ram_dp is 
	Port (
		CLOCK    : IN  STD_LOGIC;
		ADDR_R   : IN  STD_LOGIC_VECTOR(RAM_ADDR-1  DOWNTO 0);
		DATA_R   : OUT STD_LOGIC_VECTOR(RAM_WIDTH-1 DOWNTO 0);
		ADDR_W   : IN  STD_LOGIC_VECTOR(RAM_ADDR-1  DOWNTO 0);
		DATA_W   : IN  STD_LOGIC_VECTOR(RAM_WIDTH-1 DOWNTO 0);
		WRITE_M  : IN  STD_LOGIC_VECTOR(          3 DOWNTO 0)
	);
end mem_ram_dp;


architecture arch of mem_ram_dp is

TYPE   ram_type IS ARRAY (0 TO (RAM_DEPTH-1)) OF STD_LOGIC_VECTOR (RAM_WIDTH-1 DOWNTO 0);

	signal memory : ram_type := (
		0 => x"00000010",
		1 => x"00000000",
		2 => x"00527a03",
		3 => x"01017c01",
		4 => x"00020d1b",
		5 => x"00000010",
		6 => x"00000018",
		7 => x"fffeffe4",
		8 => x"0000000c",
		9 => x"00000000",
		10 => x"00000010",
		11 => x"0000002c",
		12 => x"fffeffdc",
		13 => x"00000050",
		others => x"00000000"
	);

	SIGNAL R_ADDR : STD_LOGIC_VECTOR(RAM_ADDR-2-1 DOWNTO 0); -- -2 bits because 32b words and not bytes
	SIGNAL W_ADDR : STD_LOGIC_VECTOR(RAM_ADDR-2-1 DOWNTO 0); -- -2 bits because 32b words and not bytes

begin

	R_ADDR <= ADDR_R(RAM_ADDR-1 DOWNTO 2);
	W_ADDR <= ADDR_W(RAM_ADDR-1 DOWNTO 2);

	PROCESS (CLOCK)
	BEGIN
		IF (CLOCK'event AND CLOCK = '1') THEN
			DATA_R <= memory( to_integer(UNSIGNED(R_ADDR)) );
		END IF;
	END PROCESS;

	PROCESS(CLOCK)
		VARIABLE addr : integer;
	BEGIN
		if rising_edge(CLOCK) then
			addr := TO_INTEGER( unsigned(W_ADDR) );
			if WRITE_M(0) = '1' then memory( addr )( 7 downto  0) <= DATA_W( 7 downto  0); end if;
			if WRITE_M(1) = '1' then memory( addr )(15 downto  8) <= DATA_W(15 downto  8); end if;
			if WRITE_M(2) = '1' then memory( addr )(23 downto 16) <= DATA_W(23 downto 16); end if;
			if WRITE_M(3) = '1' then memory( addr )(31 downto 24) <= DATA_W(31 downto 24); end if;
		end if;
	END PROCESS;

END arch;
