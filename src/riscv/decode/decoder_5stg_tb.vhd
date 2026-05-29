
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity decoder_5stg_tb is
end;

architecture bench of decoder_5stg_tb is

  component decoder_5stg
  Port (
    instr_i       : in  STD_LOGIC_VECTOR (31 downto 0);
    isLoad_o      : out STD_LOGIC;
    isStore_o     : out STD_LOGIC;
    isALUreg_o    : out STD_LOGIC;
    isBranch_o    : out STD_LOGIC;
    isSYSTEM_o    : out STD_LOGIC;
    isJAL_o       : out STD_LOGIC;
    isJALR_o      : out STD_LOGIC;
    isJALorJALR_o : out STD_LOGIC;
    isAuipc_o     : out STD_LOGIC;
    isLui_o       : out STD_LOGIC;
    isCustom_o    : out STD_LOGIC;

    isCSRRS_o     : out STD_LOGIC;
    isEBreak_o    : out STD_LOGIC;

    isByte_o      : out STD_LOGIC;
    isHalf_o      : out STD_LOGIC;

    isRV32M_o     : out STD_LOGIC;
    isMUL_o       : out STD_LOGIC;
    isDIV_o       : out STD_LOGIC;

    funct3_o      : out STD_LOGIC_VECTOR ( 2 downto 0);
    funct7_o      : out STD_LOGIC_VECTOR ( 6 downto 0);

    csrId_o       : out STD_LOGIC_VECTOR ( 1 downto 0);

    rs1_o         : out STD_LOGIC_VECTOR ( 4 downto 0);
    isRs1Used_o   : out STD_LOGIC;
    rs2_o         : out STD_LOGIC_VECTOR ( 4 downto 0);
    isRs2Used_o   : out STD_LOGIC;
    rdId_o        : out STD_LOGIC_VECTOR ( 4 downto 0)
  );
  end component;

  signal instr_i : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal isLoad_o,isStore_o,isALUreg_o,isBranch_o,isSYSTEM_o,isJAL_o,isJALR_o,isJALorJALR_o: STD_LOGIC;
  signal isAuipc_o,isLui_o,isCustom_o: STD_LOGIC;
  signal isCSRRS_o,isEBreak_o: STD_LOGIC;
  signal isByte_o,isHalf_o: STD_LOGIC;
  signal isRV32M_o,isMUL_o,isDIV_o: STD_LOGIC;
  signal funct3_o : STD_LOGIC_VECTOR(2 downto 0);
  signal funct7_o : STD_LOGIC_VECTOR(6 downto 0);
  signal csrId_o  : STD_LOGIC_VECTOR(1 downto 0);
  signal rs1_o,rs2_o,rdId_o: STD_LOGIC_VECTOR(4 downto 0);
  signal isRs1Used_o,isRs2Used_o: STD_LOGIC;

  constant clock_period : time := 10 ns; -- not used but keep style
  signal stop_the_clock : boolean := false;

  -- helper procedure to set fields
  procedure set_instr(
    signal I : out STD_LOGIC_VECTOR(31 downto 0);
    opcode : in STD_LOGIC_VECTOR(6 downto 0);
    rd : in integer := 0;
    funct3 : in STD_LOGIC_VECTOR(2 downto 0) := "000";
    rs1 : in integer := 0;
    rs2 : in integer := 0;
    funct7 : in STD_LOGIC_VECTOR(6 downto 0) := (others=>'0')
  ) is
  begin
    I <= (others => '0');
    I(6 downto 0) <= opcode;
    I(11 downto 7) <= std_logic_vector(to_unsigned(rd,5));
    I(14 downto 12) <= funct3;
    I(19 downto 15) <= std_logic_vector(to_unsigned(rs1,5));
    I(24 downto 20) <= std_logic_vector(to_unsigned(rs2,5));
    I(31 downto 25) <= funct7;
  end procedure;

begin

  uut: decoder_5stg port map(
    instr_i => instr_i,
    isLoad_o => isLoad_o,
    isStore_o => isStore_o,
    isALUreg_o => isALUreg_o,
    isBranch_o => isBranch_o,
    isSYSTEM_o => isSYSTEM_o,
    isJAL_o => isJAL_o,
    isJALR_o => isJALR_o,
    isJALorJALR_o => isJALorJALR_o,
    isAuipc_o => isAuipc_o,
    isLui_o => isLui_o,
    isCustom_o => isCustom_o,
    isCSRRS_o => isCSRRS_o,
    isEBreak_o => isEBreak_o,
    isByte_o => isByte_o,
    isHalf_o => isHalf_o,
    isRV32M_o => isRV32M_o,
    isMUL_o => isMUL_o,
    isDIV_o => isDIV_o,
    funct3_o => funct3_o,
    funct7_o => funct7_o,
    csrId_o => csrId_o,
    rs1_o => rs1_o,
    isRs1Used_o => isRs1Used_o,
    rs2_o => rs2_o,
    isRs2Used_o => isRs2Used_o,
    rdId_o => rdId_o
  );

  stimulus: process
  begin
    -- Test LOAD
    set_instr(instr_i, "0000011", rd=>5, funct3=>"010", rs1=>3, rs2=>0, funct7=>"0000000");
    wait for 10 ns;
    assert(isLoad_o = '1') report "LOAD not detected" severity error;
    assert(isStore_o = '0') report "STORE wrongly asserted on LOAD" severity error;
    assert(rs1_o = std_logic_vector(to_unsigned(3,5))) report "rs1 mismatch on LOAD" severity error;
    assert(rdId_o = std_logic_vector(to_unsigned(5,5))) report "rd mismatch on LOAD" severity error;
    assert(isRs1Used_o = '1') report "isRs1Used wrong on LOAD" severity error;
    assert(isRs2Used_o = '0') report "isRs2Used wrong on LOAD" severity error;

    -- Test STORE
    set_instr(instr_i, "0100011", rd=>0, funct3=>"010", rs1=>7, rs2=>8, funct7=>"0000000");
    wait for 10 ns;
    assert(isStore_o = '1') report "STORE not detected" severity error;
    assert(isRs2Used_o = '1') report "isRs2Used wrong on STORE" severity error;

    -- Test ALUreg
    set_instr(instr_i, "0110011", rd=>10, funct3=>"000", rs1=>11, rs2=>12, funct7=>"0000000");
    wait for 10 ns;
    assert(isALUreg_o = '1') report "ALUreg not detected" severity error;
    assert(isRs2Used_o = '1') report "isRs2Used wrong on ALUreg" severity error;

    -- Test BRANCH
    set_instr(instr_i, "1100011", rd=>0, funct3=>"000", rs1=>1, rs2=>2, funct7=>"0000000");
    wait for 10 ns;
    assert(isBranch_o = '1') report "BRANCH not detected" severity error;

    -- Test JAL (no rs1 used)
    set_instr(instr_i, "1101111", rd=>3, funct3=>"000", rs1=>0, rs2=>0, funct7=>"0000000");
    wait for 10 ns;
    assert(isJAL_o = '1') report "JAL not detected" severity error;
    assert(isRs1Used_o = '0') report "isRs1Used wrong on JAL" severity error;

    -- Test JALR (rs1 used)
    set_instr(instr_i, "1100111", rd=>4, funct3=>"000", rs1=>9, rs2=>0, funct7=>"0000000");
    wait for 10 ns;
    assert(isJALR_o = '1') report "JALR not detected" severity error;
    assert(isRs1Used_o = '1') report "isRs1Used wrong on JALR" severity error;

    -- Test AUIPC and LUI impact on isRs1Used
    set_instr(instr_i, "0010111", rd=>6, funct3=>"000", rs1=>0, rs2=>0, funct7=>"0000000");
    wait for 10 ns;
    assert(isAuipc_o = '1') report "AUIPC not detected" severity error;
    assert(isRs1Used_o = '0') report "isRs1Used wrong on AUIPC" severity error;

    set_instr(instr_i, "0110111", rd=>7, funct3=>"000", rs1=>0, rs2=>0, funct7=>"0000000");
    wait for 10 ns;
    assert(isLui_o = '1') report "LUI not detected" severity error;
    assert(isRs1Used_o = '0') report "isRs1Used wrong on LUI" severity error;

    -- Test SYSTEM EBREAK and CSRRS
    set_instr(instr_i, "1110011", rd=>0, funct3=>"000", rs1=>0, rs2=>0, funct7=>"0000000");
    wait for 10 ns;
    assert(isEBreak_o = '1') report "EBREAK not detected" severity error;

    set_instr(instr_i, "1110011", rd=>0, funct3=>"010", rs1=>0, rs2=>0, funct7=>"0000000");
    wait for 10 ns;
    assert(isCSRRS_o = '1') report "CSRRS not detected" severity error;

    -- Test RV32M (funct7 = 0000001)
    set_instr(instr_i, "0110011", rd=>15, funct3=>"000", rs1=>13, rs2=>14, funct7=>"0000001");
    wait for 10 ns;
    assert(isRV32M_o = '1') report "RV32M not detected" severity error;

    -- finish
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      wait for 5 ns;
    end loop;
    wait;
  end process;

end;