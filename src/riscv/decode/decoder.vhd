library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.riscv_types.all;

entity decoder is
Port ( 
    instr_i       : in  STD_LOGIC_VECTOR (31 downto 0);
    isLoad_o      : out STD_LOGIC;  -- is load instruction ?
    isStore_o     : out STD_LOGIC;  -- is store instruction ?
    isALUreg_o    : out STD_LOGIC;  -- is using rs1 and rs2 in ALU ?
    isBranch_o    : out STD_LOGIC;  -- is branch instruction ?
    isSYSTEM_o    : out STD_LOGIC;  -- is system instruction ?
    isJAL_o       : out STD_LOGIC;  -- is JAL instruction ?
    isJALR_o      : out STD_LOGIC;  -- is JALR instruction ?
    isJALorJALR_o : out STD_LOGIC;  -- is JAL or JALR instruction ?
    isAuipc_o     : out STD_LOGIC;  -- is AUIPC instruction ?
    isLui_o       : out STD_LOGIC;  -- is LUI instruction ?
    isCustom_o    : out STD_LOGIC;  -- custom instruction (not used yet)

    isCSRRS_o     : out STD_LOGIC;  -- is CSRRS instruction ?
    isEBreak_o    : out STD_LOGIC;  -- is EBREAK instruction ?

    isByte_o      : out STD_LOGIC;  -- load or store instruction with byte access ?
    isHalf_o      : out STD_LOGIC;  -- load or store instruction with half access ?

    -- sign extension pour le load 

    funct3_o      : out STD_LOGIC_VECTOR ( 2 downto 0); -- funct3 field
    funct7_o      : out STD_LOGIC_VECTOR ( 6 downto 0); -- funct7 field

    csrId_o       : out STD_LOGIC_VECTOR ( 1 downto 0); -- CSR register ID

    rs1_o         : out STD_LOGIC_VECTOR ( 4 downto 0); -- rs1 register ID
    rs2_o         : out STD_LOGIC_VECTOR ( 4 downto 0); -- rs2 register ID
    rdId_o        : out STD_LOGIC_VECTOR ( 4 downto 0)  -- rd  register ID
 );
end decoder;

architecture arch of decoder is

    SIGNAL isJAL_s  : STD_LOGIC;
    SIGNAL isJALR_s : STD_LOGIC;

begin

    isLoad_o      <= '1' when (instr_i(6 downto 0) = "0000011") else '0';
    isStore_o     <= '1' when (instr_i(6 downto 0) = "0100011") else '0';
    isALUreg_o    <= '1' when (instr_i(6 downto 0) = "0110011") else '0';
    isBranch_o    <= '1' when (instr_i(6 downto 0) = "1100011") else '0';
    isSYSTEM_o    <= '1' when (instr_i(6 downto 0) = "1110011") else '0';
    isJAL_o       <= '1' when (instr_i(6 downto 0) = "1101111") else '0';
    isJALR_o      <= '1' when (instr_i(6 downto 0) = "1100111") else '0';
    isJALorJALR_o <= (isJAL_o or isJALR_o);
    isAuipc_o     <= '1' when (instr_i(6 downto 0) = "0010111") else '0';
    isLui_o       <= '1' when (instr_i(6 downto 0) = "0110111") else '0';
    isCustom_o    <= '1' when (instr_i(6 downto 0) = "0101111") else '0';
    isCSRRS_o     <= instr_is_csrrs(instr_i);
    isEBreak_o    <= '1' when (instr_i(6 downto 0) = "1110011") else '0';

    funct3_o      <= instr_i(14 downto 12);
    funct7_o      <= instr_i(31 downto 25);

    isByte_o      <= '1' when (funct3_o(1 downto 0) = "00") else '0';
    isHalf_o      <= '1' when (funct3_o(1 downto 0) = "01") else '0';

    rs1_o         <= instr_i(19 downto 15);
    rs2_o         <= instr_i(24 downto 20);
    rdId_o        <= instr_i(11 downto 7);
    csrId_o       <= instr_i(27) & instr_i(21);

   


end arch;
 
