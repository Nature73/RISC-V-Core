library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity registers_pass is
Port ( 
   CLOCK    : in   STD_LOGIC;
   RESET    : in   STD_LOGIC;
   
   e_hold   : IN   STD_LOGIC;

   RS1_id   : IN   STD_LOGIC_VECTOR( 4 DOWNTO 0);
   DATA_rs1 : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);

   RS2_id   : IN   STD_LOGIC_VECTOR( 4 DOWNTO 0);
   DATA_rs2 : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);

   RD_id    : IN   STD_LOGIC_VECTOR( 4 DOWNTO 0);
   RD_id_we : IN   STD_LOGIC;
   DATA_rd  : IN   STD_LOGIC_VECTOR(31 DOWNTO 0)
 );
end registers_pass;

architecture arch of registers_pass is

   ---------------------------------------------------------------------------------------------------
   type RegFile is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);

   impure function InitRegisters(RamFileName : in string)
      return RegFile is
         variable RAM : RegFile;
   begin
      for I in RegFile'range loop
         RAM(I) := x"00000000";
      end loop;
      return RAM;
   end function;
   
   SIGNAL registerFile : RegFile := InitRegisters("FAKE_STRING.hex");

   SIGNAL v_rs1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL v_rs2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

   SIGNAL b_RS1_id   : STD_LOGIC_VECTOR( 4 DOWNTO 0);
   SIGNAL b_RS2_id   : STD_LOGIC_VECTOR( 4 DOWNTO 0);
   SIGNAL b_RD_id    : STD_LOGIC_VECTOR( 4 DOWNTO 0);
   SIGNAL b_RD_id_we : STD_LOGIC;
   SIGNAL b_DATA_rd  : STD_LOGIC_VECTOR(31 DOWNTO 0);


   
begin
   process(CLOCK)
   begin
      if rising_edge(CLOCK) then
         b_RS1_id <= RS1_id;
         b_RS2_id <= RS2_id;
         b_RD_id  <= RD_id;
         b_RD_id_we <= RD_id_we;
         b_DATA_rd <= DATA_rd;
      end if;
   end process;
   
   process(clock)
         variable addr : integer;
   begin
      if rising_edge(clock) then
         if RD_id_we='1' then
            addr := TO_INTEGER(unsigned(RD_id));
            registerFile(addr) <= DATA_rd;
         end if;
      end if;
   end process;

   process(clock)
   begin
         if rising_edge(clock) then
         if e_hold ='0' then
            v_rs1 <= registerFile(to_integer(unsigned(RS1_id)));
            v_rs2 <= registerFile(to_integer(unsigned(RS2_id)));
         end if;
         end if;
   end process;

   DATA_rs1 <= b_DATA_rd when ( b_RS1_id = b_RD_id and  b_RD_id_we ='1' ) else v_rs1;
   DATA_rs2 <= b_DATA_rd when ( b_RS2_id = b_RD_id and  b_RD_id_we ='1' ) else v_rs2;

end arch;
   

 
