library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

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

	type word_t is array (3 downto 0) of std_logic_vector(7 downto 0);
	type ram_type is array (0 to 16383) of word_t;


	SIGNAL memory : ram_type := (
		0 => (x"29", x"69", x"69", x"28"),
		1 => (x"00", x"00", x"00", x"0a"),
		2 => (x"29", x"69", x"69", x"28"),
		3 => (x"4c", x"45", x"48", x"20"),
		4 => (x"77", x"20", x"4f", x"4c"),
		5 => (x"64", x"6c", x"72", x"6f"),
		6 => (x"00", x"0a", x"21", x"20"),
		7 => (x"29", x"69", x"69", x"28"),
		8 => (x"74", x"65", x"4c", x"20"),
		9 => (x"20", x"65", x"6d", x"20"),
		10 => (x"72", x"74", x"6e", x"69"),
		11 => (x"63", x"75", x"64", x"6f"),
		12 => (x"79", x"6d", x"20", x"65"),
		13 => (x"66", x"6c", x"65", x"73"),
		14 => (x"20", x"49", x"20", x"2c"),
		15 => (x"74", x"20", x"6d", x"61"),
		16 => (x"42", x"20", x"65", x"68"),
		17 => (x"5a", x"69", x"65", x"72"),
		18 => (x"49", x"52", x"20", x"48"),
		19 => (x"56", x"2d", x"43", x"53"),
		20 => (x"00", x"00", x"0a", x"2e"),
		21 => (x"29", x"69", x"69", x"28"),
		22 => (x"6c", x"65", x"72", x"20"),
		23 => (x"65", x"73", x"61", x"65"),
		24 => (x"00", x"0a", x"3a", x"20"),
		25 => (x"29", x"69", x"69", x"28"),
		26 => (x"00", x"00", x"00", x"20"),
		27 => (x"20", x"72", x"70", x"41"),
		28 => (x"32", x"20", x"34", x"31"),
		29 => (x"00", x"36", x"32", x"30"),
		30 => (x"33", x"3a", x"31", x"31"),
		31 => (x"38", x"34", x"3a", x"33"),
		32 => (x"00", x"00", x"00", x"00"),
		33 => (x"69", x"2e", x"2e", x"2e"),
		34 => (x"2e", x"2e", x"69", x"63"),
		35 => (x"00", x"00", x"00", x"2e"),
		36 => (x"33", x"32", x"31", x"30"),
		37 => (x"37", x"36", x"35", x"34"),
		38 => (x"42", x"41", x"39", x"38"),
		39 => (x"46", x"45", x"44", x"43"),
		others => (others => x"00")
	);

	SIGNAL R_ADDR : STD_LOGIC_VECTOR(RAM_ADDR-2-1 DOWNTO 0); -- -2 bits because 32b words and not bytes

	SIGNAL data_in_0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_in_1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_in_2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_in_3 : STD_LOGIC_VECTOR(7 DOWNTO 0);

	SIGNAL addr   : integer range 0 to 2 ** (RAM_ADDR-2) -1;
	SIGNAL line_r : word_t;


begin

	addr <= TO_INTEGER( unsigned( ADDR_RW(RAM_ADDR-1 DOWNTO 2) ) ); -- -2 bits because 32b words and not bytes

	PROCESS (CLOCK)
	BEGIN
		IF rising_edge(CLOCK) THEN
			if ENABLE = '1' then
				line_r <= memory( addr );
			end if;
		END IF;
	END PROCESS;

	DATA_R( 7 downto  0) <= line_r(0);
	DATA_R(15 downto  8) <= line_r(1);
	DATA_R(23 downto 16) <= line_r(2);
	DATA_R(31 downto 24) <= line_r(3);

	data_in_0 <= DATA_W( 7 downto  0);
	data_in_1 <= DATA_W(15 downto  8);
	data_in_2 <= DATA_W(23 downto 16);
	data_in_3 <= DATA_W(31 downto 24);

	process(CLOCK)
		begin
			IF rising_edge(CLOCK) THEN
				if ENABLE = '1' then
					if WRITE_M(0) = '1' then
						memory( addr )(0) <= data_in_0;
					end if;
					if WRITE_M(1) = '1' then
						memory( addr )(1) <= data_in_1;
					end if;
					if WRITE_M(2) = '1' then
						memory( addr )(2) <= data_in_2;
					end if;
					if WRITE_M(3) = '1' then
						memory( addr )(3) <= data_in_3;
					end if;
				end if;
			end if;
		end process;

end arch;
