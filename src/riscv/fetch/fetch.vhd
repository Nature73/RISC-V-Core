library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity fetch is
Port ( 
   CLK                 : in  STD_LOGIC;
   resetn              : in  STD_LOGIC;
   enable_f            : in  STD_LOGIC;
   enable_m            : in  STD_LOGIC;
   jumpOrBranchAddress : in  STD_LOGIC_VECTOR (31 downto 0);
   jumpOrBranch        : in  STD_LOGIC;
   pc_value            : out STD_LOGIC_VECTOR (31 downto 0)
 );
end fetch;


architecture arch of fetch is

   SIGNAL pc_addr : UNSIGNED (31 downto 0);

begin

   process(CLK, resetn)
   begin
      if resetn = '0' then
         pc_addr <= (others => '0');
      elsif rising_edge(CLK) then
         if enable_f = '1' then
            pc_addr <= pc_addr + 4;
         elsif enable_m = '1' and jumpOrBranch = '1' then
            pc_addr <= UNSIGNED(jumpOrBranchAddress);
         end if;
      end if;
   end process;

   pc_value <= STD_LOGIC_VECTOR(pc_addr);

   
end arch;
 
