library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.riscv_types.all;

entity decoder_5stg is
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
    isCustom_o    : out STD_LOGIC; -- custom instruction

    isCSRRS_o     : out STD_LOGIC;
    isEBreak_o    : out STD_LOGIC;

    isByte_o      : out STD_LOGIC;
    isHalf_o      : out STD_LOGIC;

    isRV32M_o     : out STD_LOGIC;
    isMUL_o       : out STD_LOGIC;
    isDIV_o       : out STD_LOGIC;

    -- sign extension pour le load 

    funct3_o      : out STD_LOGIC_VECTOR ( 2 downto 0);
    funct7_o      : out STD_LOGIC_VECTOR ( 6 downto 0);

    csrId_o       : out STD_LOGIC_VECTOR ( 1 downto 0);

    rs1_o         : out STD_LOGIC_VECTOR ( 4 downto 0);
    isRs1Used_o   : out STD_LOGIC;
    rs2_o         : out STD_LOGIC_VECTOR ( 4 downto 0);
    isRs2Used_o   : out STD_LOGIC;
    rdId_o        : out STD_LOGIC_VECTOR ( 4 downto 0)
 );
end decoder_5stg;

architecture arch of decoder_5stg is

    SIGNAL isJAL_s    : STD_LOGIC;
    SIGNAL isJALR_s   : STD_LOGIC;
    SIGNAL isCSRRS_s  : STD_LOGIC;
    SIGNAL isAuipc_s  : STD_LOGIC;
    SIGNAL isALUreg_s : STD_LOGIC;
    SIGNAL isBranch_s : STD_LOGIC;
    SIGNAL isStore_s  : STD_LOGIC;
    SIGNAL isLui_s    : STD_LOGIC;
    SIGNAL isRV32M_s  : STD_LOGIC;
 --   SIGNAL isCSRRS_0  : STD_LOGIC;

begin

   isLoad_o      <= '1' when (instr_i(6 downto 0) = "0000011") else '0';
   isStore_s     <= '1' when (instr_i(6 downto 0) = "0100011") else '0';
   isALUreg_s    <= '1' when (instr_i(6 downto 0) = "0110011") else '0';
   isBranch_s    <= '1' when (instr_i(6 downto 0) = "1100011") else '0';
   isSYSTEM_o    <= '1' when (instr_i(6 downto 0) = "1110011") else '0';
   isJAL_s       <= '1' when (instr_i(6 downto 0) = "1101111") else '0';
   isJALR_o      <= '1' when (instr_i(6 downto 0) = "1100111") else '0';
   isJALorJALR_o <= '1' when (instr_i(6 downto 0) = "1101111" or instr_i(6 downto 0) = "1100111") else '0' ;
   isAuipc_s     <= '1' when (instr_i(6 downto 0) = "0010111") else '0';
   isLui_s       <= '1' when (instr_i(6 downto 0) = "0110111") else '0';
   isCustom_o    <= '1' when (instr_i(6 downto 0) = "0101111") else '0';
   isCSRRS_o     <= instr_is_csrrs(instr_i);
   isEBreak_o    <= instr_is_ebreak( instr_i );
   funct3_o      <= instr_i(14 downto 12);
   funct7_o      <= instr_i(31 downto 25);
   isByte_o      <= '1' when (instr_i(13 downto 12) = "00") else '0';
   isHalf_o      <= '1' when (instr_i(13 downto 12) = "01") else '0';
   rs1_o         <= instr_i(19 downto 15);
   rs2_o         <= instr_i(24 downto 20);
   rdId_o        <= instr_i(11 downto 7);
   csrId_o       <= instr_i(27) & instr_i(21);

   

   isRV32M_s     <= '1' when (instr_i(6 downto 0) = "0110011" and instr_i(31 downto 25) = "0000001") else '0';
   isMUL_o       <= '1' when ( isRV32M_s = '1' and ( instr_i(14 downto 12) = "000" or instr_i(14 downto 12) = "001" or instr_i(14 downto 12) = "011" or instr_i(14 downto 12) = "010" )) else '0' ;
   isDIV_o       <= '1' when ( isRV32M_s = '1' and ( instr_i(14 downto 12) = "100" or instr_i(14 downto 12) = "101"  )) else '0' ;
   isRs1Used_o   <= '0' when ( isJAL_s = '1' or isAuipc_s = '1' or isLui_s = '1') else '1';
   isRs2Used_o   <= '1' when ( isBranch_s = '1' or isALUreg_s = '1' or isStore_s ='1' ) else '0';

   isJAL_o <= isJAL_s;
   isAuipc_o <= isAuipc_s;
   isBranch_o <= isBranch_s;
   isALUreg_o <= isALUreg_s;
   isStore_o  <= isStore_s;
   isLui_o    <= isLui_s;
   isRV32M_o  <= isRV32M_s;


end arch;
 
