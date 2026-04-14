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
   ---------------------------------------------------------------------------------------------------
  -- Non immediate operation
   Signal add_or_sub_s :STD_LOGIC_VECTOR(31 downto 0);
   signal xor_s        :STD_LOGIC_VECTOR(31 downto 0);
   signal or_s         :STD_LOGIC_VECTOR(31 downto 0);
   signal and_s        :STD_LOGIC_VECTOR(31 downto 0);
   signal sll_s        :STD_LOGIC_VECTOR(31 downto 0);
   signal srl_or_sra   :STD_LOGIC_VECTOR(31 downto 0);
   signal slt_s        :STD_LOGIC_VECTOR(31 downto 0);
   signal sltu_s       :STD_LOGIC_VECTOR(31 downto 0);

   -- Immediate operation ( exept load )
   Signal addi_s       :STD_LOGIC_VECTOR(31 downto 0);
   signal xori_s       :STD_LOGIC_VECTOR(31 downto 0);
   signal ori_s        :STD_LOGIC_VECTOR(31 downto 0);
   signal andi_s       :STD_LOGIC_VECTOR(31 downto 0);
   signal slli_s       :STD_LOGIC_VECTOR(31 downto 0);
   signal srli_or_srai :STD_LOGIC_VECTOR(31 downto 0);
   signal slti_s       :STD_LOGIC_VECTOR(31 downto 0);
   signal sltui_s      :STD_LOGIC_VECTOR(31 downto 0);



begin

    -- FMT = R
    add_or_sub_s <= std_logic_vector(signed(rs1_v) - signed(rs2_v)) when(isAluSubstraction = '1') else std_logic_vector(signed(rs1_v) + signed(rs2_v));
    xor_s        <= rs1_v xor rs2_v;
    or_s         <= rs1_v or rs2_v;
    and_s        <= rs1_v and rs2_v;
    sll_s        <= std_logic_vector(shift_left(signed(rs1_v), to_integer(unsigned(rs2_v(4 downto 0)))));
    srl_or_sra   <= std_logic_vector(shift_right(signed(rs1_v), to_integer(unsigned(rs2_v(4 downto 0))))); 
    slt_s        <= repeat_bit('0',31) & '1' when(signed(rs1_v) < signed(rs2_v)) else repeat_bit('0',32);
    sltu_s       <= repeat_bit('0',31) & '1' when(unsigned(rs1_v) < unsigned(rs2_v)) else repeat_bit('0',32); 

    -- FMT = I , Immediate operation ( exept load )
    addi_s       <= std_logic_vector(signed(rs1_v) + signed(imm_v));
    xori_s       <= rs1_v xor imm_v;
    ori_s        <= rs1_v or imm_v;
    andi_s       <= rs1_v and imm_v;
    slli_s       <= std_logic_vector(shift_left(signed(rs1_v), to_integer(unsigned(imm_v(4 downto 0)))));
    srli_or_srai <= std_logic_vector(shift_right(signed(rs1_v), to_integer(unsigned(imm_v(4 downto 0))))); 
    slti_s       <= repeat_bit('0',31) & '1' when(signed(rs1_v) < signed(imm_v)) else repeat_bit('0',32);
    sltui_s      <= repeat_bit('0',31) & '1' when(unsigned(rs1_v) < unsigned(imm_v)) else repeat_bit('0',32);  
    
    -- Setting output
    aluOut_v     <= add_or_sub_s when( isALUreg = '1' and func3 = "000") else
                    xor_s        when( isALUreg = '1' and func3 = "100") else
                    or_s         when( isALUreg = '1' and func3 = "110") else
                    and_s        when( isALUreg = '1' and func3 = "111") else
                    sll_s        when( isALUreg = '1' and func3 = "001") else
                    srl_or_sra   when( isALUreg = '1' and func3 = "101") else
                    slt_s        when( isALUreg = '1' and func3 = "010") else
                    sltu_s       when( isALUreg = '1' and func3 = "011") else
                    addi_s       when( isALUreg = '0' and func3 = "000") else
                    xori_s       when( isALUreg = '0' and func3 = "100") else
                    ori_s        when( isALUreg = '0' and func3 = "110") else
                    andi_s       when( isALUreg = '0' and func3 = "111") else
                    slli_s       when( isALUreg = '0' and func3 = "001") else
                    srli_or_srai when( isALUreg = '0' and func3 = "101") else
                    slti_s       when( isALUreg = '0' and func3 = "010") else
                    sltui_s      when( isALUreg = '0' and func3 = "011");

    takeBranch    <= to_stdl(isBranch = '1' and ((func3 = "000" and slt_s(0) = '1') or (func3 = "001" and slt_s(0) = '0') or (func3 = "100" and xor_s = "00000000000000000000000000000000") or (func3 = "101" and xor_s /= "00000000000000000000000000000000")));

end arch;
 
