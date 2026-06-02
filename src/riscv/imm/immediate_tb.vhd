-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity immediate_tb is
end;

architecture bench of immediate_tb is

  component immediate
  Port ( 
     INSTR    : in  STD_LOGIC_VECTOR (31 downto 0);
     isStore  : in  STD_LOGIC;
     isLoad   : in  STD_LOGIC;
     isbranch : in  STD_LOGIC;
     isJAL    : in  STD_LOGIC;
     isAuipc  : in  STD_LOGIC;
     isLui    : in  STD_LOGIC;
     imm      : out STD_LOGIC_VECTOR (31 downto 0)
   );
  end component;

  signal INSTR: STD_LOGIC_VECTOR (31 downto 0);
  signal isStore: STD_LOGIC;
  signal isLoad: STD_LOGIC;
  signal isbranch: STD_LOGIC;
  signal isJAL: STD_LOGIC;
  signal isAuipc: STD_LOGIC;
  signal isLui: STD_LOGIC;
  signal imm: STD_LOGIC_VECTOR (31 downto 0) ;

begin

  uut: immediate port map ( INSTR    => INSTR,
                            isStore  => isStore,
                            isLoad   => isLoad,
                            isbranch => isbranch,
                            isJAL    => isJAL,
                            isAuipc  => isAuipc,
                            isLui    => isLui,
                            imm      => imm );

  stimulus: process
  begin
  
    --
    --
    -- TEST DES IMMEDIATS DANS LE CAS D'UNE INSTRUCTION LUI
    --
    --

    INSTR    <= "00000000000000000001000010110111"; -- lui x1, 1
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '1';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(4096, 32) ) report "Test failed for imm (U)" severity error;

    INSTR    <= "00000000000001100100000010110111"; -- lui x1, 100
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '1';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(409600, 32) ) report "Test failed for imm (U)" severity error;

    INSTR    <= "00000000111111111111000010110111"; -- lui x1, 4095
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '1';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(16773120, 32) ) report "Test failed for imm (U)" severity error;

    INSTR    <= "00010000000000000000000010110111"; -- lui x1, 65536
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '1';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(268435456, 32) ) report "Test failed for imm (U)" severity error;

    INSTR    <= "11111111111111111111000010110111"; -- lui x1, -1
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '1';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-4096, 32) ) report "Test failed for imm (U)" severity error;

    INSTR    <= "11111111111110011100000010110111"; -- lui x1, -100
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '1';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-409600, 32) ) report "Test failed for imm (U)" severity error;
    
    INSTR    <= "11111111000000000001000010110111"; -- lui x1, -4095
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '1';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-16773120, 32) ) report "Test failed for imm (U)" severity error;
    
    INSTR    <= "11110000000000000000000010110111"; -- lui x1, -65536
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '1';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-268435456, 32) ) report "Test failed for imm (U)" severity error;


    --
    --
    -- TEST DES IMMEDIATS DANS LE CAS D'UNE INSTRUCTION Immediate
    --
    --


    
    INSTR    <= "00000000000000000000000010010011"; -- addi x1, x0, 0
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(0, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(0, 32) )) severity error;
    
    INSTR    <= "00000000000100000000000010010011"; -- addi x1, x0, 1
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1, 32) )) severity error;
    
    INSTR    <= "00000000110100000000000010010011"; -- addi x1, x0, 13
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(13, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(13, 32) )) severity error;
    
    INSTR    <= "01111111111100000000000010010011"; -- addi x1, x0, 2047
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(2047, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(2047, 32) )) severity error;
    
    INSTR    <= "10000000000000000000000010010011"; -- addi x1, x0, -2048
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-2048, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-2048, 32) )) severity error;
    
    INSTR    <= "11111111001100000000000010010011"; -- addi x1, x0, -13
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-13, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-13, 32) )) severity error;
    
    INSTR    <= "11111111111100000000000010010011"; -- addi x1, x0, -1
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1, 32) )) severity error;
    
    INSTR    <= "10000000000000010000000010010011"; -- addi x1, x2, -2048
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-2048, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-2048, 32) )) severity error;
    
    INSTR    <= "10001000000000010000000010010011"; -- addi x1, x2, -1920
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1920, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1920, 32) )) severity error;
    
    INSTR    <= "10010000000000010000000010010011"; -- addi x1, x2, -1792
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1792, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1792, 32) )) severity error;
    
    INSTR    <= "10011000000000010000000010010011"; -- addi x1, x2, -1664
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1664, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1664, 32) )) severity error;
    
    INSTR    <= "10100000000000010000000010010011"; -- addi x1, x2, -1536
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1536, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1536, 32) )) severity error;
    
    INSTR    <= "10101000000000010000000010010011"; -- addi x1, x2, -1408
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1408, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1408, 32) )) severity error;
    
    INSTR    <= "10110000000000010000000010010011"; -- addi x1, x2, -1280
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1280, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1280, 32) )) severity error;
    
    INSTR    <= "10111000000000010000000010010011"; -- addi x1, x2, -1152
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1152, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1152, 32) )) severity error;
    
    INSTR    <= "11000000000000010000000010010011"; -- addi x1, x2, -1024
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1024, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1024, 32) )) severity error;
    
    INSTR    <= "11001000000000010000000010010011"; -- addi x1, x2, -896
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-896, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-896, 32) )) severity error;
    
    INSTR    <= "11010000000000010000000010010011"; -- addi x1, x2, -768
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-768, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-768, 32) )) severity error;
    
    INSTR    <= "11011000000000010000000010010011"; -- addi x1, x2, -640
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-640, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-640, 32) )) severity error;
    
    INSTR    <= "11100000000000010000000010010011"; -- addi x1, x2, -512
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-512, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-512, 32) )) severity error;
    
    INSTR    <= "11101000000000010000000010010011"; -- addi x1, x2, -384
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-384, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-384, 32) )) severity error;
    
    INSTR    <= "11110000000000010000000010010011"; -- addi x1, x2, -256
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-256, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-256, 32) )) severity error;
    
    INSTR    <= "11111000000000010000000010010011"; -- addi x1, x2, -128
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-128, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-128, 32) )) severity error;
    
    INSTR    <= "00000000000000010000000010010011"; -- addi x1, x2, 0
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(0, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(0, 32) )) severity error;
    
    INSTR    <= "00001000000000010000000010010011"; -- addi x1, x2, 128
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(128, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(128, 32) )) severity error;
    
    INSTR    <= "00010000000000010000000010010011"; -- addi x1, x2, 256
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(256, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(256, 32) )) severity error;
    
    INSTR    <= "00011000000000010000000010010011"; -- addi x1, x2, 384
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(384, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(384, 32) )) severity error;
    
    INSTR    <= "00100000000000010000000010010011"; -- addi x1, x2, 512
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(512, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(512, 32) )) severity error;
    
    INSTR    <= "00101000000000010000000010010011"; -- addi x1, x2, 640
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(640, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(640, 32) )) severity error;
    
    INSTR    <= "00110000000000010000000010010011"; -- addi x1, x2, 768
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(768, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(768, 32) )) severity error;
    
    INSTR    <= "00111000000000010000000010010011"; -- addi x1, x2, 896
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(896, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(896, 32) )) severity error;
    
    INSTR    <= "01000000000000010000000010010011"; -- addi x1, x2, 1024
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1024, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1024, 32) )) severity error;
    
    INSTR    <= "01001000000000010000000010010011"; -- addi x1, x2, 1152
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1152, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1152, 32) )) severity error;
    
    INSTR    <= "01010000000000010000000010010011"; -- addi x1, x2, 1280
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1280, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1280, 32) )) severity error;
    
    INSTR    <= "01011000000000010000000010010011"; -- addi x1, x2, 1408
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1408, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1408, 32) )) severity error;
    
    INSTR    <= "01100000000000010000000010010011"; -- addi x1, x2, 1536
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1536, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1536, 32) )) severity error;
    
    INSTR    <= "01101000000000010000000010010011"; -- addi x1, x2, 1664
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1664, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1664, 32) )) severity error;
    
    INSTR    <= "01110000000000010000000010010011"; -- addi x1, x2, 1792
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1792, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1792, 32) )) severity error;
    
    INSTR    <= "01111000000000010000000010010011"; -- addi x1, x2, 1920
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1920, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1920, 32) )) severity error;
    



    --
    --
    -- TEST DES IMMEDIATS DANS LE CAS D'UNE INSTRUCTION TYPE-I (LOAD)
    --
    --

    
    INSTR    <= "00000000000000010010000010000011"; -- lw x1, 0(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(0, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(0, 32) )) severity error;
    
    INSTR    <= "00000000110100010010000010000011"; -- lw x1, 13(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(13, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(13, 32) )) severity error;
    
    INSTR    <= "01111111111100010010000010000011"; -- lw x1, 2047(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(2047, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(2047, 32) )) severity error;
    
    INSTR    <= "11111111001100010010000010000011"; -- lw x1, -13(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-13, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-13, 32) )) severity error;
    
    INSTR    <= "10000000000000010010000010000011"; -- lw x1, -2048(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-2048, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-2048, 32) )) severity error;
    
    INSTR    <= "10000000000000010010000010000011"; -- lw x1, -2048(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-2048, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-2048, 32) )) severity error;
    
    INSTR    <= "10001000000000010010000010000011"; -- lw x1, -1920(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1920, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1920, 32) )) severity error;
    
    INSTR    <= "10010000000000010010000010000011"; -- lw x1, -1792(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1792, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1792, 32) )) severity error;
    
    INSTR    <= "10011000000000010010000010000011"; -- lw x1, -1664(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1664, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1664, 32) )) severity error;
    
    INSTR    <= "10100000000000010010000010000011"; -- lw x1, -1536(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1536, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1536, 32) )) severity error;
    
    INSTR    <= "10101000000000010010000010000011"; -- lw x1, -1408(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1408, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1408, 32) )) severity error;
    
    INSTR    <= "10110000000000010010000010000011"; -- lw x1, -1280(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1280, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1280, 32) )) severity error;
    
    INSTR    <= "10111000000000010010000010000011"; -- lw x1, -1152(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1152, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1152, 32) )) severity error;
    
    INSTR    <= "11000000000000010010000010000011"; -- lw x1, -1024(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1024, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1024, 32) )) severity error;
    
    INSTR    <= "11001000000000010010000010000011"; -- lw x1, -896(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-896, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-896, 32) )) severity error;
    
    INSTR    <= "11010000000000010010000010000011"; -- lw x1, -768(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-768, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-768, 32) )) severity error;
    
    INSTR    <= "11011000000000010010000010000011"; -- lw x1, -640(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-640, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-640, 32) )) severity error;
    
    INSTR    <= "11100000000000010010000010000011"; -- lw x1, -512(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-512, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-512, 32) )) severity error;
    
    INSTR    <= "11101000000000010010000010000011"; -- lw x1, -384(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-384, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-384, 32) )) severity error;
    
    INSTR    <= "11110000000000010010000010000011"; -- lw x1, -256(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-256, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-256, 32) )) severity error;
    
    INSTR    <= "11111000000000010010000010000011"; -- lw x1, -128(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-128, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-128, 32) )) severity error;
    
    INSTR    <= "00000000000000010010000010000011"; -- lw x1, 0(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(0, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(0, 32) )) severity error;
    
    INSTR    <= "00001000000000010010000010000011"; -- lw x1, 128(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(128, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(128, 32) )) severity error;
    
    INSTR    <= "00010000000000010010000010000011"; -- lw x1, 256(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(256, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(256, 32) )) severity error;
    
    INSTR    <= "00011000000000010010000010000011"; -- lw x1, 384(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(384, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(384, 32) )) severity error;
    
    INSTR    <= "00100000000000010010000010000011"; -- lw x1, 512(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(512, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(512, 32) )) severity error;
    
    INSTR    <= "00101000000000010010000010000011"; -- lw x1, 640(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(640, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(640, 32) )) severity error;
    
    INSTR    <= "00110000000000010010000010000011"; -- lw x1, 768(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(768, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(768, 32) )) severity error;
    
    INSTR    <= "00111000000000010010000010000011"; -- lw x1, 896(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(896, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(896, 32) )) severity error;
    
    INSTR    <= "01000000000000010010000010000011"; -- lw x1, 1024(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1024, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1024, 32) )) severity error;
    
    INSTR    <= "01001000000000010010000010000011"; -- lw x1, 1152(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1152, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1152, 32) )) severity error;
    
    INSTR    <= "01010000000000010010000010000011"; -- lw x1, 1280(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1280, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1280, 32) )) severity error;
    
    INSTR    <= "01011000000000010010000010000011"; -- lw x1, 1408(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1408, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1408, 32) )) severity error;
    
    INSTR    <= "01100000000000010010000010000011"; -- lw x1, 1536(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1536, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1536, 32) )) severity error;
    
    INSTR    <= "01101000000000010010000010000011"; -- lw x1, 1664(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1664, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1664, 32) )) severity error;
    
    INSTR    <= "01110000000000010010000010000011"; -- lw x1, 1792(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1792, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1792, 32) )) severity error;
    
    INSTR    <= "01111000000000010010000010000011"; -- lw x1, 1920(x2)
    isStore  <= '0';
    isLoad   <= '1';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(1920, 32) ) report "Test failed for imm (I-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(1920, 32) )) severity error;
    

    --
    --
    -- TEST DES IMMEDIATS DANS LE CAS D'UNE INSTRUCTION TYPE-S
    --
    --

    
    INSTR    <= "00000000000100010010000000100011"; -- sw xNone, 0(x2)
    isStore  <= '1';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(0, 32) ) report "Test failed for imm (S-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(0, 32) )) severity error;
    
    INSTR    <= "00000000000100010010011010100011"; -- sw xNone, 13(x2)
    isStore  <= '1';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(13, 32) ) report "Test failed for imm (S-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(13, 32) )) severity error;
    
    INSTR    <= "01111110000100010010111110100011"; -- sw xNone, 2047(x2)
    isStore  <= '1';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(2047, 32) ) report "Test failed for imm (S-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(2047, 32) )) severity error;
    
    INSTR    <= "11111110000100010010100110100011"; -- sw xNone, -13(x2)
    isStore  <= '1';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-13, 32) ) report "Test failed for imm (S-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-13, 32) )) severity error;
    
    INSTR    <= "10000000000100010010000000100011"; -- sw xNone, -2048(x2)
    isStore  <= '1';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-2048, 32) ) report "Test failed for imm (S-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-2048, 32) )) severity error;
    

    --
    --
    -- TEST DES IMMEDIATS DANS LE CAS D'UNE INSTRUCTION TYPE-B
    --
    --

    
    INSTR    <= "00000000001000001000100001100011"; -- beq x1, x2, 16
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '1';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(16, 32) ) report "Test failed for imm (B-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(16, 32) )) severity error;
    
    INSTR    <= "01111110001000001000111111100011"; -- beq x1, x2, 4094
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '1';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(4094, 32) ) report "Test failed for imm (B-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(4094, 32) )) severity error;
    
    INSTR    <= "11111110001000001000100011100011"; -- beq x1, x2, -16
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '1';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-16, 32) ) report "Test failed for imm (B-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-16, 32) )) severity error;
    
    INSTR    <= "10101010000000000000000111100011"; -- beq x0, x0, -1374
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '1';
    isJAL    <= '0';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-1374, 32) ) report "Test failed for imm (B-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-1374, 32) )) severity error;
    



    --
    --
    -- TEST DES IMMEDIATS DANS LE CAS D'UNE INSTRUCTION TYPE-J
    --
    --

    
    INSTR    <= "00000000001000000000000011101111"; -- jal x1, 2
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '1';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(2, 32) ) report "Test failed for imm (J-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(2, 32) )) severity error;
    
    INSTR    <= "11111111111111111111000011101111"; -- jal x1, -2
    isStore  <= '0';
    isLoad   <= '0';
    isbranch <= '0';
    isJAL    <= '1';
    isAuipc  <= '0';
    isLui    <= '0';
    wait for 10 ns;
    assert imm = STD_LOGIC_VECTOR( TO_SIGNED(-2, 32) ) report "Test failed for imm (J-type) : Got Imm=" & to_string(imm) & " instead of " & to_string(STD_LOGIC_VECTOR( TO_SIGNED(-2, 32) )) severity error;
    
    
    wait;
  end process;


end;