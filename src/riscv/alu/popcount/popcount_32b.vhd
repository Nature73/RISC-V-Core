library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity popcount32_tree is
    Port (
        input  : in  STD_LOGIC_VECTOR(31 downto 0);
        result : out STD_LOGIC_VECTOR(5 downto 0)  -- 6 bits pour un max de 32
    );
end popcount32_tree;

architecture Behavioral of popcount32_tree is
    signal level1 : unsigned(15 downto 0);  -- 16 x 1-bit sums
    signal level2 : unsigned(7 downto 0);   -- 8 x 2-bit sums
    signal level3 : unsigned(3 downto 0);   -- 4 x 3-bit sums
    signal level4 : unsigned(1 downto 0);   -- 2 x 4-bit sums
    signal level5 : unsigned(5 downto 0);   -- final result
begin

    -- Niveau 1 : paire de bits
    gen_level1: for i in 0 to 15 generate
        level1(i) <= ('0' & input(2*i)) + ('0' & input(2*i+1));
    end generate;

    -- Niveau 2 : additionne les résultats 2 à 2
    gen_level2: for i in 0 to 7 generate
        level2(i) <= resize(level1(2*i), 2) + resize(level1(2*i+1), 2);
    end generate;

    -- Niveau 3
    gen_level3: for i in 0 to 3 generate
        level3(i) <= resize(level2(2*i), 3) + resize(level2(2*i+1), 3);
    end generate;

    -- Niveau 4
    gen_level4: for i in 0 to 1 generate
        level4(i) <= resize(level3(2*i), 4) + resize(level3(2*i+1), 4);
    end generate;

    -- Niveau 5 (final)
    level5 <= resize(level4(0), 6) + resize(level4(1), 6);
    result <= std_logic_vector(level5);

end Behavioral;
