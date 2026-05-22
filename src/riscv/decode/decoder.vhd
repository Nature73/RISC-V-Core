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
   
    isLoad_o       <= instr_is_load   ( instr_i ); -- '1' when FD_instr(6 downto 2) = "00000" ELSE '0'; -- type I
    isStore_o      <= instr_is_store  ( instr_i ); -- '1' when FD_instr(6 downto 2) = "01000" ELSE '0';
    isALUreg_o     <= instr_is_alu_reg( instr_i ); -- '1' when FD_instr(6 downto 2) = "01100" ELSE '0'; -- type R
    isBranch_o     <= instr_is_branch ( instr_i ); -- '1' when FD_instr(6 downto 2) = "11000" ELSE '0';
    isSYSTEM_o     <= instr_is_system ( instr_i ); -- '1' when FD_instr(6 downto 2) = "11100" ELSE '0';
    isJAL_s        <= instr_is_jal    ( instr_i ); -- '1' when FD_instr(3)          = '1'     ELSE '0';
    isJALR_s       <= instr_is_jalr   ( instr_i ); -- '1' when FD_instr(3)          = '1'     ELSE '0';

    isJAL_o        <= isJAL_s;
    isJALR_o       <= isJALR_s;
    isJALorJALR_o  <= isJAL_s OR isJALR_s;

    isAuipc_o      <= instr_is_auipc ( instr_i ); -- '1' when FD_instr(6 downto 2) = "11100" ELSE '0';
    isLui_o        <= instr_is_lui   ( instr_i ); -- '1' when FD_instr(6 downto 2) = "11100" ELSE '0';

    isCustom_o     <= instr_is_custom( instr_i ); -- custom instruction

    isCSRRS_o      <= instr_is_csrrs ( instr_i );
    isEBreak_o     <= instr_is_ebreak( instr_i );

    isByte_o       <= funct3_is_byte( instr_funct3( instr_i ) ); --'1' when FD_instr(13 downto 12) = "00" ELSE '0';
    isHalf_o       <= funct3_is_half( instr_funct3( instr_i ) ); --'1' when FD_instr(13 downto 12) = "01" ELSE '0';

    funct3_o       <= instr_funct3( instr_i );
    funct7_o       <= instr_funct7( instr_i );

    csrId_o        <= instr_csr_id( instr_i );

    rs1_o          <= instr_rs1_id( instr_i );
    rs2_o          <= instr_rs2_id( instr_i );
    rdId_o         <= instr_rd_id ( instr_i );

end arch;
 
