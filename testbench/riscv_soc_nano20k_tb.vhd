-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity riscv_soc_tb is
end;

architecture bench of riscv_soc_tb is

  component riscv_soc_nano20k
  Port ( 
      CLOCK     : in  STD_LOGIC;
      RESET_i   : in  STD_LOGIC; -- INVERTED RESET
      user      : in  STD_LOGIC; -- INVERTED BUTTON
      LED       : out STD_LOGIC_VECTOR ( 5 downto 0);
      uart_rx   : in  STD_LOGIC;
      uart_tx   : out STD_LOGIC;
      WS2812    : out STD_LOGIC
   );
  end component;

  signal CLK100MHZ      : STD_LOGIC;
  signal RESET          : STD_LOGIC;
  signal USER           : STD_LOGIC := '1';
  signal LED            : STD_LOGIC_VECTOR (5 downto 0);
  signal UART_RXD_OUT   : STD_LOGIC ; 
  signal UART_TXD_IN    : STD_LOGIC := '0'; 
  signal led_rgb        : STD_LOGIC;
  

  constant clock_period : time := 4 ns; -- presque 27 Mhz
  signal stop_the_clock : boolean;

begin


   ------------------------------------------------------------------------------------


   uut: riscv_soc_nano20k
    port map (
        CLOCK         => CLK100MHZ,
        RESET_i       => RESET,
        user          => user,
        LED           => LED,
        uart_rx       => UART_RXD_OUT,
        uart_tx       => UART_TXD_IN,
        WS2812        => led_rgb
    );


   ------------------------------------------------------------------------------------


   clocking: process
   begin
      while not stop_the_clock loop
         CLK100MHZ <= '0', '1' after clock_period / 2;
         wait for clock_period;
      end loop;
      wait;
   end process;


   ------------------------------------------------------------------------------------


   stimulus: process
   begin
      -- Put initialisation code here
      RESET <= '1';
      wait for 4 * clock_period;

      RESET <= '0';
      wait for clock_period;

      -- Put test bench stimulus code here

      --stop_the_clock <= true;
      wait;
   end process;

end;
