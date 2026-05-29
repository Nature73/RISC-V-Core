-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity registers_pass_tb is
end;

architecture bench of registers_pass_tb is

  component registers_pass
  Port (
     CLOCK    : in   STD_LOGIC;
     RESET    : in   STD_LOGIC;
     e_hold   : IN   STD_LOGIC;
     RS1_id   : IN   STD_LOGIC_VECTOR( 4 DOWNTO 0);
     RS2_id   : IN   STD_LOGIC_VECTOR( 4 DOWNTO 0);
     RD_id    : IN   STD_LOGIC_VECTOR( 4 DOWNTO 0);
     RD_id_we : IN   STD_LOGIC;
     DATA_rd  : IN   STD_LOGIC_VECTOR(31 DOWNTO 0);
     DATA_rs1 : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
     DATA_rs2 : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
   );
  end component;

  signal CLOCK: STD_LOGIC;
  signal RESET: STD_LOGIC;
  signal e_hold: STD_LOGIC;
  signal RS1_id: STD_LOGIC_VECTOR( 4 DOWNTO 0);
  signal RS2_id: STD_LOGIC_VECTOR( 4 DOWNTO 0);
  signal RD_id: STD_LOGIC_VECTOR( 4 DOWNTO 0);
  signal RD_id_we: STD_LOGIC;
  signal DATA_rd: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal DATA_rs1: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal DATA_rs2: STD_LOGIC_VECTOR(31 DOWNTO 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: registers_pass port map ( CLOCK    => CLOCK,
                            RESET    => RESET,
                            e_hold   => e_hold,
                            RS1_id   => RS1_id,
                            RS2_id   => RS2_id,
                            RD_id    => RD_id,
                            RD_id_we => RD_id_we,
                            DATA_rd  => DATA_rd,
                            DATA_rs1 => DATA_rs1,
                            DATA_rs2 => DATA_rs2 );

  stimulus: process
  begin
 
    -- Put initialisation code here
    RESET <= '1';
    wait for 20 ns;
    RESET <= '0';
    wait for clock_period;

    e_hold <= '0';
    rs1_id <= "00000";
    rs2_id <= "00000";
    rd_id <= "00000";
    rd_id_we <= '0';
    data_rd <= (others => '0');
    wait for clock_period;

    assert(DATA_rs1 = x"00000000") report "Test failed (initial value of x0)" severity error;

    -- Put test bench stimulus code here
    
    -- Write to all registers
    for i in 1 to 31 loop
      rd_id <= std_logic_vector(to_unsigned(i, 5));
      data_rd <= std_logic_vector(to_unsigned(i, 32));
      rd_id_we <= '1';
      wait for clock_period;
    end loop;

    -- we = 0
    rd_id_we <= '0';
    wait for clock_period;

    -- Read back from all registers and check values
    for i in 1 to 15 loop
      rs1_id <= std_logic_vector(to_unsigned(i, 5));
      rs2_id <= std_logic_vector(to_unsigned(i+1, 5));
      wait for clock_period;
      assert(DATA_rs1 = std_logic_vector(to_unsigned(i, 32))) report "Test failed (read back from x" & integer'image(i) & ")" severity error;
      assert(DATA_rs2 = std_logic_vector(to_unsigned(i+1, 32))) report "Test failed (read back from x" & integer'image(i+1) & ")" severity error;
    end loop;
    

    ------------------------------------------------------
    -- On intialise les registres
    ------------------------------------------------------

     RS1_id   <= "00000";
     RS2_id   <= "00000";

    wait for 40 ns;

     --1ere valeur
     RD_id    <= "00000";
     RD_id_we <= '1';
     DATA_rd  <= x"00000001";
     

    wait for 10 ns;

   --2e registre
    RD_id    <= "00001";
    DATA_rd  <= x"00000002";

    wait for 10 ns;
    --3e registre
    RD_id    <= "00010";
    DATA_rd  <= x"00000003";

    wait for 10 ns;
    --4e registre
    RD_id    <= "00011";
    DATA_rd  <= x"00000004";

    wait for 10 ns;
    --5e registre
    RD_id    <= "00100";
    DATA_rd  <= x"00000005";

    wait for 10 ns;
    --6e registre
    RD_id    <= "00101";
    DATA_rd  <= x"00000006";

    wait for 10 ns;
    --7e registre
    RD_id    <= "00110";
    DATA_rd  <= x"00000007";

    wait for 10 ns;
    --8e registre
    RD_id    <= "00111";
    DATA_rd  <= x"00000008";

    wait for 10 ns;
    --9e registre
    RD_id    <= "01000";
    DATA_rd  <= x"00000009";

    wait for 10 ns;
    --10e registre
    RD_id    <= "01001";
    DATA_rd  <= x"0000000A";

    wait for 10 ns;
    --11e registre
    RD_id    <= "01010";
    DATA_rd  <= x"0000000B";

    wait for 10 ns;
    --12e registre
    RD_id    <= "01011";
    DATA_rd  <= x"0000000C";

    wait for 10 ns;
    --13e registre
    RD_id    <= "01100";
    DATA_rd  <= x"0000000D";

    wait for 10 ns;
    --14e registre
    RD_id    <= "01101";
    DATA_rd  <= x"0000000E";

    wait for 10 ns;
    --15e registre
    RD_id    <= "01110";
    DATA_rd  <= x"0000000F";

    wait for 10 ns;
    --16e registre
    RD_id    <= "01111";
    DATA_rd  <= x"00000010";

    wait for 10 ns;
    --17e registre
    RD_id    <= "10000";
    DATA_rd  <= x"00000011";

    wait for 10 ns;
    --18e registre
    RD_id    <= "10001";
    DATA_rd  <= x"00000012";

    wait for 10 ns;
    --19e registre
    RD_id    <= "10010";
    DATA_rd  <= x"00000013";

    wait for 10 ns;
    --20e registre
    RD_id    <= "10011";
    DATA_rd  <= x"00000014";

    wait for 10 ns;
    --21e registre
    RD_id    <= "10100";
    DATA_rd  <= x"00000015";

    wait for 10 ns;
    --22e registre
    RD_id    <= "10101";
    DATA_rd  <= x"00000016";

    wait for 10 ns;
    --23e registre
    RD_id    <= "10110";
    DATA_rd  <= x"00000017";

    wait for 10 ns;
    --24e registre
    RD_id    <= "10111";
    DATA_rd  <= x"00000018";

    wait for 10 ns;
    --25e registre
    RD_id    <= "11000";
    DATA_rd  <= x"00000019";

    wait for 10 ns;
    --26e registre
    RD_id    <= "11001";
    DATA_rd  <= x"0000001A";

    wait for 10 ns;
    --27e registre
    RD_id    <= "11010";
    DATA_rd  <= x"0000001B";

    wait for 10 ns;
    --28e registre
    RD_id    <= "11011";
    DATA_rd  <= x"0000001C";

    wait for 10 ns;
    --29e registre
    RD_id    <= "11100";
    DATA_rd  <= x"0000001D";

    wait for 10 ns;
    --30e registre
    RD_id    <= "11101";
    DATA_rd  <= x"0000001E";

    wait for 10 ns;
    --31e registre
    RD_id    <= "11110";
    DATA_rd  <= x"0000001F";

    wait for 20 ns;
    RD_id_we <= '0';

    ------------------------------------------------------------------------------
    -- Partie vérification des registres en passant par RS1 (16 premiers)
    -----------------------------------------------------------------------------

    RS1_id   <= "00000";
    wait for 20 ns;
    assert(DATA_rs1  =  x"00000001" ) report "Test failed" severity error;


    RS1_id <= "00001";
    wait for 20 ns;
    assert(DATA_rs1  =  x"00000002" ) report "Test failed" severity error;

   

    RS1_id <= "00010";
    wait for 20 ns;
    assert(DATA_rs1  =  x"00000003" ) report "Test failed" severity error;

   
    RS1_id <= "00011";
    wait for 20 ns;
    assert(DATA_rs1  =  x"00000004" ) report "Test failed" severity error;

   
    RS1_id <= "00100";
    wait for 20 ns;
    assert(DATA_rs1  =  x"00000005" ) report "Test failed" severity error;

   
    RS1_id <= "00101";
    wait for 20 ns;
    assert(DATA_rs1  =  x"00000006" ) report "Test failed" severity error;

   
    RS1_id <= "00110";
    wait for 20 ns;
    assert(DATA_rs1  =  x"00000007" ) report "Test failed" severity error;

   
    RS1_id <= "00111";
    wait for 20 ns;
    assert(DATA_rs1  =  x"00000008" ) report "Test failed" severity error;

   
    RS1_id <= "01000";
    wait for 20 ns;
    assert(DATA_rs1  =  x"00000009" ) report "Test failed" severity error;

   
    RS1_id <= "01001";
    wait for 20 ns;
    assert(DATA_rs1  =  x"0000000A" ) report "Test failed" severity error;

   
    RS1_id <= "01010";
    wait for 20 ns;
    assert(DATA_rs1  =  x"0000000B" ) report "Test failed" severity error;

   
    RS1_id <= "01011";
    wait for 20 ns;
    assert(DATA_rs1  =  x"0000000C" ) report "Test failed" severity error;

   
    RS1_id <= "01100";
    wait for 20 ns;
    assert(DATA_rs1  =  x"0000000D" ) report "Test failed" severity error;

   
    RS1_id <= "01101";
    wait for 20 ns;
    assert(DATA_rs1  =  x"0000000E" ) report "Test failed" severity error;

   
    RS1_id <= "01110";
    wait for 20 ns;
    assert(DATA_rs1  =  x"0000000F" ) report "Test failed" severity error;

   
    RS1_id <= "01111";
    wait for 20 ns;
    assert(DATA_rs1  =  x"00000010" ) report "Test failed" severity error;

 
   ------------------------------------------------------------------------------
    -- Partie vérification des registres en passant par RS2 (16 derniers)
    -----------------------------------------------------------------------------

    RS2_id <= "10000";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000011" ) report "Test failed" severity error;


    RS2_id <= "10001";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000012" ) report "Test failed" severity error;


    RS2_id <= "10010";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000013" ) report "Test failed" severity error;


    RS2_id <= "10011";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000014" ) report "Test failed" severity error;


    RS2_id <= "10100";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000015" ) report "Test failed" severity error;

 

    RS2_id <= "10101";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000016" ) report "Test failed" severity error;


    RS2_id <= "10110";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000017" ) report "Test failed" severity error;


    RS2_id <= "10111";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000018" ) report "Test failed" severity error;

    RS2_id <= "11000";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000019" ) report "Test failed" severity error;


    RS2_id <= "11001";
    wait for 20 ns;
    assert(DATA_rs2  =  x"0000001A" ) report "Test failed" severity error;


    RS2_id <= "11010";
    wait for 20 ns;
    assert(DATA_rs2  =  x"0000001B" ) report "Test failed" severity error;


    RS2_id <= "11011";
    wait for 20 ns;
    assert(DATA_rs2  =  x"0000001C" ) report "Test failed" severity error;


    RS2_id <= "11100";
    wait for 20 ns;
    assert(DATA_rs2  =  x"0000001D" ) report "Test failed" severity error;


    RS2_id <= "11101";
    wait for 20 ns;
    assert(DATA_rs2  =  x"0000001E" ) report "Test failed" severity error;


    RS2_id <= "11110";
    wait for 20 ns;
    assert(DATA_rs2  =  x"0000001F" ) report "Test failed" severity error;

    ------------------------------------------------------------------------------
    -- Partie vérification des registres avec Hold actif
    -----------------------------------------------------------------------------

    
     RS1_id   <= "00000";
     RS2_id   <= "00000";

    wait for 40 ns;

     --1ere valeur
     RD_id    <= "00000";
     RD_id_we <= '1';
     DATA_rd  <= x"00000000";
     

    wait for 10 ns;

   --2e registre
    RD_id    <= "00001";
    DATA_rd  <= x"00000000";

    wait for 40 ns;

    e_hold <= '1';


    RS2_id <= "11110";
    RS1_id <= "00100";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000000" ) report "Test failed" severity error;
    assert(DATA_rs1  =  x"00000000" ) report "Test failed" severity error;

    RS2_id <= "10001";
    RS1_id <= "11010";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000000" ) report "Test failed" severity error;
    assert(DATA_rs1  =  x"00000000" ) report "Test failed" severity error;

    RS2_id <= "01101";
    RS1_id <= "00101";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000000" ) report "Test failed" severity error;
    assert(DATA_rs1  =  x"00000000" ) report "Test failed" severity error;

    RS2_id <= "11011";
    RS1_id <= "11111";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000000" ) report "Test failed" severity error;
    assert(DATA_rs1  =  x"00000000" ) report "Test failed" severity error;

    RS2_id <= "11110";
    RS1_id <= "00010";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000000" ) report "Test failed" severity error;
    assert(DATA_rs1  =  x"00000000" ) report "Test failed" severity error;
    
    RS2_id <= "11100";
    RS1_id <= "00101";
    wait for 20 ns;
    assert(DATA_rs2  =  x"00000000" ) report "Test failed" severity error;
    assert(DATA_rs1  =  x"00000000" ) report "Test failed" severity error;


  ------------------------------------------------------------------------------
  -- Partie vérification du Bypass sur RS1
  -----------------------------------------------------------------------------

    RD_id    <= "11011";
    DATA_rd  <= x"0000001C";
    RS1_id <= "11011";
    wait for 20 ns;
    assert(DATA_rs1  =  x"0000001C" ) report "Test failed" severity error;

    RD_id    <= "10011";
    DATA_rd  <= x"000A701C";
    RS1_id <= "10011";
    wait for 20 ns;
    assert(DATA_rs1  =  x"000A701C" ) report "Test failed" severity error;

    RD_id    <= "10101";
    DATA_rd  <= x"0185601C";
    RS1_id <= "10101";
    wait for 20 ns;
    assert(DATA_rs1  =  x"0185601C" ) report "Test failed" severity error;

  ------------------------------------------------------------------------------
  -- Partie vérification du Bypass sur RS2
  -----------------------------------------------------------------------------

    RD_id    <= "11011";
    DATA_rd  <= x"0000001C";
    RS2_id <= "11011";
    wait for 20 ns;
    assert(DATA_rs2  =  x"0000001C" ) report "Test failed" severity error;

    RD_id    <= "10011";
    DATA_rd  <= x"000A701C";
    RS2_id <= "10011";
    wait for 20 ns;
    assert(DATA_rs2  =  x"000A701C" ) report "Test failed" severity error;

    RD_id    <= "10101";
    DATA_rd  <= x"0185601C";
    RS2_id <= "10101";
    wait for 20 ns;
    assert(DATA_rs2  =  x"0185601C" ) report "Test failed" severity error;






    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      CLOCK <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;