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
		0 => (x"00", x"00", x"00", x"10"),
		1 => (x"00", x"00", x"00", x"00"),
		2 => (x"00", x"52", x"7a", x"03"),
		3 => (x"01", x"01", x"7c", x"01"),
		4 => (x"00", x"02", x"0d", x"1b"),
		5 => (x"00", x"00", x"00", x"10"),
		6 => (x"00", x"00", x"00", x"18"),
		7 => (x"ff", x"fe", x"ff", x"e4"),
		8 => (x"00", x"00", x"00", x"0c"),
		9 => (x"00", x"00", x"00", x"00"),
		10 => (x"00", x"00", x"00", x"10"),
		11 => (x"00", x"00", x"00", x"2c"),
		12 => (x"ff", x"fe", x"ff", x"dc"),
		13 => (x"00", x"00", x"00", x"50"),
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
