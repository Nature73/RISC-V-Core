library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity popcount64_tree is
    Port (
        input  : in  STD_LOGIC_VECTOR(63 downto 0);
        result : out STD_LOGIC_VECTOR(6 downto 0)  -- 7 bits pour compter jusqu'à 64
    );
end popcount64_tree;

architecture Behavioral of popcount64_tree is
    signal level1 : unsigned(31 downto 0);  -- 32 x 1-bit sums
    signal level2 : unsigned(15 downto 0);  -- 16 x 2-bit sums
    signal level3 : unsigned(7 downto 0);   -- 8 x 3-bit sums
    signal level4 : unsigned(3 downto 0);   -- 4 x 4-bit sums
    signal level5 : unsigned(1 downto 0);   -- 2 x 5-bit sums
    signal level6 : unsigned(6 downto 0);   -- Final result
begin

    -- Niveau 1 : additionne les bits deux à deux
    gen_level1: for i in 0 to 31 generate
        level1(i) <= ('0' & input(2*i)) + ('0' & input(2*i+1));
    end generate;

    -- Niveau 2 : additionne les résultats de niveau 1 deux à deux
    gen_level2: for i in 0 to 15 generate
        level2(i) <= resize(level1(2*i), 2) + resize(level1(2*i+1), 2);
    end generate;

    -- Niveau 3
    gen_level3: for i in 0 to 7 generate
        level3(i) <= resize(level2(2*i), 3) + resize(level2(2*i+1), 3);
    end generate;

    -- Niveau 4
    gen_level4: for i in 0 to 3 generate
        level4(i) <= resize(level3(2*i), 4) + resize(level3(2*i+1), 4);
    end generate;

    -- Niveau 5
    gen_level5: for i in 0 to 1 generate
        level5(i) <= resize(level4(2*i), 5) + resize(level4(2*i+1), 5);
    end generate;

    -- Niveau 6 (final)
    level6 <= resize(level5(0), 7) + resize(level5(1), 7);
    result <= std_logic_vector(level6);

end Behavioral;
