library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity immediate is
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
end immediate;


architecture arch of immediate is

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

   SIGNAL Iimm : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL Simm : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL Uimm : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL Jimm : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL Bimm : STD_LOGIC_VECTOR (31 downto 0);

begin

    Iimm <= repeat_bit(instr(31),20) & instr(31 downto 20);
    Simm <= repeat_bit(instr(31),20) & instr(31 downto 25) & instr(11 downto 7);
    Bimm <= repeat_bit(instr(31),19) & instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0';
    Jimm <= repeat_bit(instr(31),11) & instr(31) & instr(20) & instr(19 downto 12) & instr(30 downto 21)  & '0';
    Uimm <= instr(31 downto 12) & repeat_bit('0',12);



    imm  <= Simm when(isStore = '1') else Bimm when(isbranch = '1') else Jimm when(isjal ='1') else Uimm when (islui = '1' or isauipc ='1') else Iimm;

end arch;