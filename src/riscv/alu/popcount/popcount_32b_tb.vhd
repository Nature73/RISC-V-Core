library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity popcount32_tree_tb is
end popcount32_tree_tb;

architecture testbench of popcount32_tree_tb is

    -- Composant à tester
    component popcount32_tree
        Port (
            input  : in  STD_LOGIC_VECTOR(31 downto 0);
            result : out STD_LOGIC_VECTOR(5 downto 0)
        );
    end component;

    -- Signaux de test
    signal input  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal result : STD_LOGIC_VECTOR(5 downto 0);

begin

    -- Instanciation du DUT (Device Under Test)
    uut: popcount32_tree
        port map (
            input  => input,
            result => result
        );

    -- Processus de stimulation
    stim_proc: process
    begin
        -- Test 0 : tous les bits à 0
        input <= (others => '0');
        wait for 10 ns;
        assert result = "000000"
            report "Erreur : popcount(0) attendu = 0" severity error;

        -- Test 1 : un seul bit à 1
        input <= x"00000001";
        wait for 10 ns;
        assert result = "000001"
            report "Erreur : popcount(1) attendu = 1" severity error;

        -- Test 2 : tous les bits à 1
        input <= x"FFFFFFFF";
        wait for 10 ns;
        assert result = "100000"
            report "Erreur : popcount(0xFFFFFFFF) attendu = 32" severity error;

        -- Test 3 : alternance 1010...
        input <= x"AAAAAAAA";
        wait for 10 ns;
        assert result = "010000"
            report "Erreur : popcount(0xAAAAAAAA) attendu = 16" severity error;

        -- Test 4 : alternance 0101...
        input <= x"55555555";
        wait for 10 ns;
        assert result = "010000"
            report "Erreur : popcount(0x55555555) attendu = 16" severity error;

        -- Test 5 : 8 bits à 1 au début
        input <= x"FF000000";
        wait for 10 ns;
        assert result = "001000"
            report "Erreur : popcount(0xFF000000) attendu = 8" severity error;

        wait;
    end process;

end testbench;
