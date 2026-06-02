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
		0 => (x"3b", x"30", x"5b", x"1b"),
		1 => (x"00", x"6d", x"32", x"33"),
		2 => (x"3b", x"30", x"5b", x"1b"),
		3 => (x"00", x"6d", x"31", x"33"),
		4 => (x"3b", x"30", x"5b", x"1b"),
		5 => (x"00", x"6d", x"37", x"33"),
		6 => (x"29", x"49", x"49", x"28"),
		7 => (x"6d", x"6f", x"43", x"20"),
		8 => (x"61", x"74", x"75", x"70"),
		9 => (x"6e", x"6f", x"69", x"74"),
		10 => (x"20", x"66", x"6f", x"20"),
		11 => (x"61", x"20", x"49", x"50"),
		12 => (x"69", x"72", x"70", x"70"),
		13 => (x"69", x"74", x"61", x"78"),
		14 => (x"00", x"00", x"6e", x"6f"),
		15 => (x"20", x"79", x"61", x"4d"),
		16 => (x"32", x"20", x"39", x"32"),
		17 => (x"00", x"36", x"32", x"30"),
		18 => (x"29", x"49", x"49", x"28"),
		19 => (x"6d", x"6f", x"43", x"20"),
		20 => (x"61", x"6c", x"69", x"70"),
		21 => (x"6e", x"6f", x"69", x"74"),
		22 => (x"74", x"61", x"64", x"20"),
		23 => (x"20", x"3a", x"20", x"65"),
		24 => (x"00", x"0a", x"73", x"25"),
		25 => (x"30", x"3a", x"37", x"31"),
		26 => (x"37", x"34", x"3a", x"34"),
		27 => (x"00", x"00", x"00", x"00"),
		28 => (x"29", x"49", x"49", x"28"),
		29 => (x"6d", x"6f", x"43", x"20"),
		30 => (x"61", x"6c", x"69", x"70"),
		31 => (x"6e", x"6f", x"69", x"74"),
		32 => (x"6d", x"69", x"74", x"20"),
		33 => (x"20", x"3a", x"20", x"65"),
		34 => (x"00", x"0a", x"73", x"25"),
		35 => (x"29", x"49", x"49", x"28"),
		36 => (x"00", x"00", x"00", x"00"),
		37 => (x"29", x"49", x"49", x"28"),
		38 => (x"6d", x"75", x"4e", x"20"),
		39 => (x"20", x"72", x"65", x"62"),
		40 => (x"64", x"20", x"66", x"6f"),
		41 => (x"74", x"69", x"67", x"69"),
		42 => (x"20", x"3a", x"20", x"73"),
		43 => (x"00", x"0a", x"64", x"25"),
		44 => (x"29", x"49", x"49", x"28"),
		45 => (x"6d", x"65", x"4d", x"20"),
		46 => (x"20", x"79", x"72", x"6f"),
		47 => (x"74", x"6f", x"6f", x"66"),
		48 => (x"6e", x"69", x"72", x"70"),
		49 => (x"00", x"00", x"00", x"74"),
		50 => (x"29", x"49", x"49", x"28"),
		51 => (x"50", x"20", x"2d", x"20"),
		52 => (x"69", x"64", x"20", x"49"),
		53 => (x"73", x"74", x"69", x"67"),
		54 => (x"20", x"20", x"20", x"20"),
		55 => (x"3a", x"20", x"20", x"20"),
		56 => (x"20", x"64", x"25", x"20"),
		57 => (x"00", x"0a", x"42", x"6b"),
		58 => (x"29", x"49", x"49", x"28"),
		59 => (x"49", x"20", x"2d", x"20"),
		60 => (x"72", x"65", x"74", x"6e"),
		61 => (x"20", x"6c", x"61", x"6e"),
		62 => (x"75", x"6c", x"61", x"76"),
		63 => (x"3a", x"20", x"73", x"65"),
		64 => (x"20", x"64", x"25", x"20"),
		65 => (x"00", x"0a", x"42", x"6b"),
		66 => (x"20", x"20", x"20", x"20"),
		67 => (x"2e", x"33", x"20", x"20"),
		68 => (x"00", x"00", x"00", x"00"),
		69 => (x"64", x"35", x"25", x"0a"),
		70 => (x"00", x"20", x"7c", x"20"),
		71 => (x"00", x"20", x"20", x"0a"),
		72 => (x"33", x"32", x"31", x"30"),
		73 => (x"37", x"36", x"35", x"34"),
		74 => (x"42", x"41", x"39", x"38"),
		75 => (x"46", x"45", x"44", x"43"),
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
