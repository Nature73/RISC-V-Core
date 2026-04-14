----------------------------------------------------------------------------------
--
-- UART_fifoed_send_V1
-- Version 1.1
-- 
-- V1.1 : Written by Yannick Bornat (2016/04/20)
--       - build from UART_send v1.1, named to fit the same version number
--
-- Sends chars on the UART line, has a built-in fifo to accept char inputs while
-- sending an older char
-- during character send, busy output bit is set to '1' and the module ignores inputs.
-- works at 100MHz with 115.200kbps transfer rate
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

USE work.stdio_h.all;

entity uart_send is
    Generic (
        CLK_FREQU : integer := 27000000;
        BAUDRATE  : integer := 115200;
        DATA_SIZE : integer := 8
    );
    Port (
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        TX    : out STD_LOGIC;
        din   : in  STD_LOGIC_VECTOR (DATA_SIZE - 1 downto 0);
        den   : in  STD_LOGIC;
        bsy   : out STD_LOGIC
    );
end uart_send;

architecture arch of uart_send is

  SIGNAL buffer_i  : CHARACTER;
  SIGNAL unique_i  : integer := 0;

begin

  PROCESS(clk   )
      variable a : CHARACTER;
  BEGIN
      IF clk'event AND clk = '1' THEN
          IF (RESET = '1') and (unique_i = 0) THEN
              printf("(--)\n");
              printf("(--) RISC-V design framework for teaching\n");
              printf("(--) Bertrand LE GAL 2023-2024\n");
              printf("(--)\n");
              unique_i <= 1;
          ELSIF den = '1' THEN
              a := character'val( TO_INTEGER( UNSIGNED(din) ) );
              putchar( a );
          END IF;
      END IF;
  END PROCESS;


  PROCESS(clk)
  BEGIN
      IF clk'event AND clk = '1' THEN
          IF den = '1' THEN
              buffer_i <= character'val( TO_INTEGER( UNSIGNED(din) ) );
          END IF;
      END IF;
  END PROCESS;

  TX   <= '0';
  bsy  <= '0';

end arch;
