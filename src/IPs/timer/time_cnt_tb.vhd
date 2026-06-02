-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity time_cnt_tb is
end;

architecture bench of time_cnt_tb is

  component time_cnt
      Generic(
          clock_freq : integer := 100000000
      );
      Port ( 
          CLK       : in  STD_LOGIC;
          reset     : in  STD_LOGIC;
          index_v   : in  STD_LOGIC_VECTOR( 4 downto 0);
          data_i    : in  STD_LOGIC_VECTOR(31 downto 0);
          write_en  : in  STD_LOGIC;
          data_o    : out STD_LOGIC_VECTOR(31 downto 0)
      );
  end component;

  signal CLK: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal index_v: STD_LOGIC_VECTOR( 4 downto 0);
  signal data_i: STD_LOGIC_VECTOR(31 downto 0);
  signal write_en: STD_LOGIC;
  signal data_o: STD_LOGIC_VECTOR(31 downto 0) ;

  constant clock_period : time := 10 ns;
  signal stop_the_clock : boolean;

begin

  -- Insert values for generic parameters !!
  uut: time_cnt generic map ( clock_freq => 100 )
                   port map ( CLK        => CLK,
                              reset      => reset,
                              index_v    => index_v,
                              data_i     => data_i,
                              write_en   => write_en,
                              data_o     => data_o );

  stimulus: process
  begin
    reset    <= '0';
    index_v  <= "00000";
    data_i   <= x"00000000";
    write_en <= '0';
    
    -- Put initialisation code here


    -- Put test bench stimulus code here

    wait;
  end process;

   clocking: process
   begin
      while not stop_the_clock loop
         CLK <= '0', '1' after clock_period / 2;
         wait for clock_period;
      end loop;
      wait;
   end process;

end;