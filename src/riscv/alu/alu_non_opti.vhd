library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity alu is
Port (
   rs1_v             : in  STD_LOGIC_VECTOR (31 downto 0);  -- rs_1 value
   rs2_v             : in  STD_LOGIC_VECTOR (31 downto 0);  -- rs_2 value
   isALUreg          : in  STD_LOGIC;                       -- does computation invole rs_1 and rs_2 ? or imm ?
   isBranch          : in  STD_LOGIC;                       -- branch instruction ?
   isAluSubstraction : in  STD_LOGIC;                       -- function7 field, bit 6
   isCustom          : in  STD_LOGIC;                       -- custom instruction
   func3             : in  STD_LOGIC_VECTOR ( 2 downto 0);  -- funct3 field
   func7             : in  STD_LOGIC_VECTOR ( 6 downto 0);  -- funct7 field
   imm_v             : in  STD_LOGIC_VECTOR (31 downto 0);  -- immediate value

   aluOut_v          : out STD_LOGIC_VECTOR (31 downto 0);  -- result of the ALU computation
   takeBranch        : out STD_LOGIC
 );
end alu;


architecture arch of alu is

   ---------------------------------------------------------------------------------------------------

    function repeat_bit(B: std_logic; N: natural) return std_logic_vector is
        variable result: std_logic_vector(1 to N);
    begin
        for i in 1 to N loop
            result(i) := B;
        end loop;
        return result;
    end;

    function to_stdl(L: BOOLEAN) return std_ulogic is
    begin
        if L then
            return('1');
        else
            return('0');
        end if;
    end;

   ---------------------------------------------------------------------------------------------------
    --signaux de branchements
    signal t_eq    : std_logic ;
    signal t_ne    : std_logic ;
    signal t_lt    : std_logic ;
    signal t_ge    : std_logic ;
    signal t_ltu   : std_logic ;
    signal t_geu   : std_logic ;

    --signaux op_non_imme
    signal op_nim_add  : std_logic_vector(31 downto 0);
    signal op_nim_sub  : std_logic_vector(31 downto 0);
    signal op_nim_xor  : std_logic_vector(31 downto 0);
    signal op_nim_or   : std_logic_vector(31 downto 0);
    signal op_nim_and  : std_logic_vector(31 downto 0);
    signal op_nim_sll  : std_logic_vector(31 downto 0);
    signal op_nim_srl  : std_logic_vector(31 downto 0);
    signal op_nim_sra  : std_logic_vector(31 downto 0);
    signal op_nim_slt  : std_logic_vector(31 downto 0);
    signal op_nim_sltu : std_logic_vector(31 downto 0);

    --signaux op_non_imme
    signal op_im_add  : std_logic_vector(31 downto 0);
    signal op_im_xor  : std_logic_vector(31 downto 0);
    signal op_im_or   : std_logic_vector(31 downto 0);
    signal op_im_and  : std_logic_vector(31 downto 0);
    signal op_im_sll  : std_logic_vector(31 downto 0);
    signal op_im_srl  : std_logic_vector(31 downto 0);
    signal op_im_sra  : std_logic_vector(31 downto 0);
    signal op_im_slt  : std_logic_vector(31 downto 0);
    signal op_im_sltu : std_logic_vector(31 downto 0);


begin

    --------------------------------------------------------------------------------------------------
   --Branchement
   --------------------------------------------------------------------------------------------------
    t_eq <= '1' when (signed(rs1_v)  = signed(rs2_v)) else '0';
    t_ne <= '1' when ( not(signed(rs1_v) = signed(rs2_v))) else '0';
    t_lt <= '1' when (signed(rs1_v) <  signed(rs2_v)) else '0';
    t_ge <= '1' when (signed(rs1_v) >= signed(rs2_v)) else '0';
    t_ltu <= '1' when (unsigned(rs1_v) < unsigned(rs2_v)) else '0';
    t_geu <= '1' when (unsigned(rs1_v) >=unsigned(rs2_v)) else '0';

    takeBranch <=   t_eq    when (func3 = "000" and isBranch = '1') else
                    t_ne    when (func3 = "001" and isBranch = '1') else
                    t_lt    when (func3 = "100" and isBranch = '1') else
                    t_ge    when (func3 = "101" and isBranch = '1') else
                    t_ltu   when (func3 = "110" and isBranch = '1') else
                    t_geu ; --  when (func3 = "111" and isBranch = '1') ;
   
   --------------------------------------------------------------------------------------------------
   --Opération non immédiate
   --------------------------------------------------------------------------------------------------
    op_nim_add  <= std_logic_vector( signed(rs1_v) + signed(rs2_v) );
    op_nim_sub  <= std_logic_vector( signed(rs1_v) - signed(rs2_v) );
    op_nim_xor  <= (rs1_v) xor (rs2_v) ;
    op_nim_or   <= (rs1_v) or  (rs2_v) ;
    op_nim_and  <= (rs1_v) and (rs2_v) ;
    op_nim_sll  <= std_logic_vector(shift_left  ( signed(rs1_v), to_integer(unsigned(rs2_v(4 downto 0)))) );
    op_nim_srl  <= std_logic_vector(shift_right ( signed(rs1_v), to_integer(unsigned(rs2_v(4 downto 0)))) );
    op_nim_sra  <= std_logic_vector(shift_right ( signed(rs1_v) ,to_integer(unsigned(rs2_v(4 downto 0)))) );
    op_nim_slt  <= (repeat_bit('0',31) & '1') when (signed(rs2_v)>signed(rs1_v)) else (repeat_bit('0',31) & '0') ;
    op_nim_sltu <= (repeat_bit('0',31) & '1') when (unsigned(rs2_v)>unsigned(rs1_v)) else (repeat_bit('0',31) & '0') ;

    --------------------------------------------------------------------------------------------------
   --Opération immédiate
   --------------------------------------------------------------------------------------------------
    op_im_add  <= std_logic_vector( signed(rs1_v) + signed(imm_v) );
    op_im_xor  <= (rs1_v) xor (imm_v) ;
    op_im_or   <= (rs1_v) or  (imm_v) ;
    op_im_and  <= (rs1_v) and (imm_v) ;
    op_im_sll  <= std_logic_vector(shift_left  ( signed(rs1_v), to_integer(unsigned(imm_v(4 downto 0))) ) );
    op_im_srl  <= std_logic_vector(shift_right ( signed(rs1_v), to_integer(unsigned(imm_v(4 downto 0))) ) );
    op_im_sra  <= std_logic_vector(shift_right ( signed(rs1_v) ,to_integer(unsigned(imm_v(4 downto 0))) ) );
    op_im_slt  <= (repeat_bit('0',31) & '1') when (signed(imm_v)>signed(rs1_v)) else (repeat_bit('0',31) & '0') ;
    op_im_sltu <= (repeat_bit('0',31) & '1') when (unsigned(imm_v)>unsigned(rs1_v)) else (repeat_bit('0',31) & '0') ;

   ----------------------------------------------------------------------------------------------------
   --Mise à jour de la sortie de l'alu
   ----------------------------------------------------------------------------------------------------

   aluOut_v <=  --non immediate
                op_nim_add  when ( (isALUreg = '1') and func3 = "000" and isAluSubstraction = '0' ) else
                op_nim_sub  when ( (isALUreg = '1') and func3 = "000" and isAluSubstraction = '1' ) else 
                op_nim_xor  when ( (isALUreg = '1') and func3 = "100" and isAluSubstraction = '0' ) else 
                op_nim_or   when ( (isALUreg = '1') and func3 = "110" and isAluSubstraction = '0' ) else
                op_nim_and  when ( (isALUreg = '1') and func3 = "111" and isAluSubstraction = '0' ) else 
                op_nim_sll  when ( (isALUreg = '1') and func3 = "001" and isAluSubstraction = '0' ) else 
                op_nim_srl  when ( (isALUreg = '1') and func3 = "101" and isAluSubstraction = '0' ) else 
                op_nim_sra  when ( (isALUreg = '1') and func3 = "101" and isAluSubstraction = '1' ) else 
                op_nim_slt  when ( (isALUreg = '1') and func3 = "010" and isAluSubstraction = '0' ) else 
                op_nim_sltu when ( (isALUreg = '1') and func3 = "011" and isAluSubstraction = '0' ) else
                --immediate
                op_im_add   when ( (isALUreg = '0') and func3 = "000"  ) else
                op_im_xor   when ( (isALUreg = '0') and func3 = "100"  ) else
                op_im_or    when ( (isALUreg = '0') and func3 = "110"  ) else
                op_im_and   when ( (isALUreg = '0') and func3 = "111"  ) else
                op_im_sll   when ( (isALUreg = '0') and func3 = "001" and imm_v(11 downto 5) = "0000000" ) else 
                op_im_srl   when ( (isALUreg = '0') and func3 = "101" and imm_v(11 downto 5) = "0000000" ) else
                op_im_sra   when ( (isALUreg = '0') and func3 = "101" and imm_v(11 downto 5) = "0100000" ) else
                op_im_slt   when ( (isALUreg = '0') and func3 = "010" ) else
                op_im_sltu  when ( (isALUreg = '0') and func3 = "011" ) ; 



end arch;