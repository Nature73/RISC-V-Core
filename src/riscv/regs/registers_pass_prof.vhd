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
        VARIABLE addr : integer;   
   begin
     if rising_edge(CLOCK) then
        b_RS1_id   <= RS1_id;
        b_RS2_id   <= RS2_id;
        b_RD_id    <= RD_id;
        b_RD_id_we <= RD_id_we;
        b_DATA_rd  <= DATA_rd;
     end if;
   end process;

   process(CLOCK)
        VARIABLE addr : integer;   
   begin
     if rising_edge(CLOCK) then
        if RD_id_we = '1' then
            addr := TO_INTEGER( unsigned(RD_id) );
            registerFile( addr ) <= DATA_rd;
        end if;
     end if;
   end process;
   
   --
   -- DECODAGE COMBINATOIRE DES REGISTRES
   --

   process(CLOCK)
        VARIABLE addr : integer;   
   begin
     if rising_edge(CLOCK) then
        if e_hold = '0' then
            v_rs1 <= registerFile( TO_INTEGER( unsigned( RS1_id ) ) ); --WHEN FD_instr( 19 downto 15) /= "00000" ELSE x"00000000";
            v_rs2 <= registerFile( TO_INTEGER( unsigned( RS2_id ) ) ); --WHEN FD_instr( 24 downto 20) /= "00000" ELSE x"00000000";
        end if;
     end if;
   end process;
   
   DATA_rs1 <= b_DATA_rd when (b_RS1_id = b_RD_id) AND (b_RD_id_we = '1') else v_rs1;
   DATA_rs2 <= b_DATA_rd when (b_RS2_id = b_RD_id) AND (b_RD_id_we = '1') else v_rs2;
   
end arch;
 
