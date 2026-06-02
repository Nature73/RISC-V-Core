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

        function reverse(B : std_logic_vector; N : natural) return std_logic_vector is
        variable result : std_logic_vector((N-1) downto 0);
    begin
        for i in 0 to (N-1) loop
            result(i) := B(N-i-1);
        end loop;
        return result;
    end;

    function shift(B : std_logic_vector; N : natural; dec : integer; s : std_logic) return std_logic_vector is
    --    variable result : std_logic_vector(31 downto 0);
    --    variable result2 : std_logic_vector(31 downto 0);
    --begin
    --    result  := repeat_bit(B(31), dec) & B( (N-1) downto dec);
    --    result2 := repeat_bit('0', dec) & B( (N-1) downto dec);
    --    return (s and result) or ((not s) and result2);
    --end;
    variable x : std_logic_vector(32 downto 0);
    begin
        x := (s and B(31)) & B;
        case std_logic_vector(to_unsigned(dec, 5)) is
            when "00000" => return                         x(31 downto  0);
            when "00001" => return                         x(32 downto  1);
            when "00010" => return repeat_bit(x(32),  1) & x(32 downto  2);
            when "00011" => return repeat_bit(x(32),  2) & x(32 downto  3);
            when "00100" => return repeat_bit(x(32),  3) & x(32 downto  4);
            when "00101" => return repeat_bit(x(32),  4) & x(32 downto  5);
            when "00110" => return repeat_bit(x(32),  5) & x(32 downto  6);
            when "00111" => return repeat_bit(x(32),  6) & x(32 downto  7);
            when "01000" => return repeat_bit(x(32),  7) & x(32 downto  8);
            when "01001" => return repeat_bit(x(32),  8) & x(32 downto  9);
            when "01010" => return repeat_bit(x(32),  9) & x(32 downto 10);
            when "01011" => return repeat_bit(x(32), 10) & x(32 downto 11);
            when "01100" => return repeat_bit(x(32), 11) & x(32 downto 12);
            when "01101" => return repeat_bit(x(32), 12) & x(32 downto 13);
            when "01110" => return repeat_bit(x(32), 13) & x(32 downto 14);
            when "01111" => return repeat_bit(x(32), 14) & x(32 downto 15);
            when "10000" => return repeat_bit(x(32), 15) & x(32 downto 16);
            when "10001" => return repeat_bit(x(32), 16) & x(32 downto 17);
            when "10010" => return repeat_bit(x(32), 17) & x(32 downto 18);
            when "10011" => return repeat_bit(x(32), 18) & x(32 downto 19);
            when "10100" => return repeat_bit(x(32), 19) & x(32 downto 20);
            when "10101" => return repeat_bit(x(32), 20) & x(32 downto 21);
            when "10110" => return repeat_bit(x(32), 21) & x(32 downto 22);
            when "10111" => return repeat_bit(x(32), 22) & x(32 downto 23);
            when "11000" => return repeat_bit(x(32), 23) & x(32 downto 24);
            when "11001" => return repeat_bit(x(32), 24) & x(32 downto 25);
            when "11010" => return repeat_bit(x(32), 25) & x(32 downto 26);
            when "11011" => return repeat_bit(x(32), 26) & x(32 downto 27);
            when "11100" => return repeat_bit(x(32), 27) & x(32 downto 28);
            when "11101" => return repeat_bit(x(32), 28) & x(32 downto 29);
            when "11110" => return repeat_bit(x(32), 29) & x(32 downto 30);
--          when "11111" => return repeat_bit(x(32), 30) & x(32 downto 31);
            when OTHERS  => return repeat_bit(x(32), 30) & x(32 downto 31);
        end case;
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


    --Signaux op
    signal operande2 : std_logic_vector(31 downto 0);

    --signaux de decalage
    signal gauche        : std_logic ;
    signal is_signed     : std_logic ;
    signal rs1_shifted   : std_logic_vector(31 downto 0);
    signal rs1_shifted_r : std_logic_vector(31 downto 0);
    signal rs1_v_r       : std_logic_vector(31 downto 0);
    signal op : std_logic_vector(31 downto 0);


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
   --Opération 
   --------------------------------------------------------------------------------------------------
    operande2 <= rs2_v when (isALUreg = '1') else imm_v;

    op_nim_add  <= std_logic_vector( signed(rs1_v) + signed(operande2) );
    op_nim_sub  <= std_logic_vector( signed(rs1_v) - signed(operande2) );
    op_nim_xor  <= (rs1_v) xor (operande2) ;
    op_nim_or   <= (rs1_v) or  (operande2) ;
    op_nim_and  <= (rs1_v) and (operande2) ;
    -- op_nim_sll  <= std_logic_vector(shift_left  ( signed(rs1_v), to_integer(unsigned(operande2(4 downto 0)))) );
    -- op_nim_srl  <= std_logic_vector(shift_right ( signed(rs1_v), to_integer(unsigned(operande2(4 downto 0)))) );
    -- op_nim_sra  <= std_logic_vector(shift_right ( signed(rs1_v) ,to_integer(unsigned(operande2(4 downto 0)))) );
    op_nim_slt  <= (repeat_bit('0',31) & '1') when (signed(operande2)>signed(rs1_v)) else (repeat_bit('0',31) & '0') ;
    op_nim_sltu <= (repeat_bit('0',31) & '1') when (unsigned(operande2)>unsigned(rs1_v)) else (repeat_bit('0',31) & '0') ;

    --------------------------------------------------------------------------------------------------
    -- Opération de shift
    --------------------------------------------------------------------------------------------------
    rs1_v_r       <= reverse(rs1_v, 32);
    gauche        <= '1' when func3 = "001" else '0'; -- 1 à gauche, 0 à droite
    is_signed     <= '1' when (func3 = "101" and func7(5) = '1' ) else '0';
    rs1_shifted   <= shift(rs1_v, 32,to_integer(unsigned(operande2(4 downto 0))),is_signed) when gauche = '0' else shift(rs1_v_r, 32,to_integer(unsigned(operande2(4 downto 0))),is_signed);
    rs1_shifted_r <= reverse(rs1_shifted,32);

    op_nim_sll  <= rs1_shifted_r ;
    op_nim_srl  <= rs1_shifted ;
    op_nim_sra  <= rs1_shifted ;



   ----------------------------------------------------------------------------------------------------
   --Mise à jour de la sortie de l'alu
   ----------------------------------------------------------------------------------------------------

   aluOut_v <=  --non immediate
                op_nim_sub  when ( func3 = "000" and isAluSubstraction = '1' and (isALUreg = '1') ) else
                op_nim_add  when ( func3 = "000"  ) else 
                op_nim_xor  when ( func3 = "100"  ) else 
                op_nim_or   when ( func3 = "110"  ) else
                op_nim_and  when ( func3 = "111"  ) else 
                op_nim_sll  when ( func3 = "001"  ) else 
                op_nim_sra  when ( func3 = "101" and isAluSubstraction = '1' and (isALUreg = '1')) else
                op_nim_srl  when ( func3 = "101"  ) else 
                op_nim_slt  when ( func3 = "010"  ) else 
                op_nim_sltu ;
                --immediate
                -- op_im_add   when ( (isALUreg = '0') and func3 = "000"  ) else
                -- op_im_xor   when ( (isALUreg = '0') and func3 = "100"  ) else
                -- op_im_or    when ( (isALUreg = '0') and func3 = "110"  ) else
                -- op_im_and   when ( (isALUreg = '0') and func3 = "111"  ) else
                -- op_im_sll   when ( (isALUreg = '0') and func3 = "001" and imm_v(11 downto 5) = "0000000" ) else 
                -- op_im_srl   when ( (isALUreg = '0') and func3 = "101" and imm_v(11 downto 5) = "0000000" ) else
                -- op_im_sra   when ( (isALUreg = '0') and func3 = "101" and imm_v(11 downto 5) = "0100000" ) else
                -- op_im_slt   when ( (isALUreg = '0') and func3 = "010" ) else
                -- op_im_sltu  when ( (isALUreg = '0') and func3 = "011" ) ; 




end arch;