-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity riscv_soc_tb is
end;

architecture bench of riscv_soc_tb is

   COMPONENT riscv_soc_altera is
   Port ( 
      CLOCK     : in  STD_LOGIC;
      BTN       : in  STD_LOGIC_VECTOR (1 downto 0); -- BTN(0) = reset inversé | BTN(1) = user (inversé)
      SW        : in  STD_LOGIC_VECTOR (9 downto 0);
      LED       : out STD_LOGIC_VECTOR (9 downto 0);
      uart_rx   : in  STD_LOGIC;
      uart_tx   : out STD_LOGIC
   );
   end COMPONENT;

   signal CLK50MHZ       : STD_LOGIC;
   signal RESET          : STD_LOGIC;
   signal LED            : STD_LOGIC_VECTOR (9 downto 0);
   signal SW             : STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
   signal BTN            : STD_LOGIC_VECTOR (1 downto 0);
   signal UART_RXD_OUT   : STD_LOGIC ; 

   constant clock_period : time := 20 ns;
   signal stop_the_clock : boolean;


begin


   ------------------------------------------------------------------------------------

   BTN <= '1' & RESET;
   SW  <= "0100100011";

   uut: riscv_soc_altera
   port map (
      CLOCK   => CLK50MHZ,
      BTN     => BTN,
      LED     => LED,
      SW      => SW,
      uart_tx => UART_RXD_OUT,
      uart_rx => '0'
   );

   ------------------------------------------------------------------------------------


   clocking: process
   begin
      while not stop_the_clock loop
         CLK50MHZ <= '0', '1' after clock_period / 2;
         wait for clock_period;
      end loop;
      wait;
   end process;


   ------------------------------------------------------------------------------------


   stimulus: process
   begin
      -- Put initialisation code here
      RESET <= '0';
      wait for 4 * clock_period;

      RESET <= '1';
      wait for clock_period;

      -- Put test bench stimulus code here

      --stop_the_clock <= true;
      wait;
   end process;

end;
