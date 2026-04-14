library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity popcount64_tree_tb is
end popcount64_tree_tb;

architecture testbench of popcount64_tree_tb is

    -- Composant à tester
    component popcount64_tree is
        Port (
            input  : in  STD_LOGIC_VECTOR(63 downto 0);
            result : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Signaux de test
    signal input  : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal result : STD_LOGIC_VECTOR(6 downto 0);

begin

    -- Instanciation du DUT (Device Under Test)
    uut: popcount64_tree
        port map (
            input  => input,
            result => result
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test 0 : aucun bit à 1
        input <= (others => '0');
        wait for 10 ns;
        assert result = "0000000"
            report "Erreur : popcount(0) attendu = 0" severity error;

        -- Test 1 : un seul bit à 1
        input <= x"0000000000000001";
        wait for 10 ns;
        assert result = "0000001"
            report "Erreur : popcount(1) attendu = 1" severity error;

        -- Test 2 : tous les bits à 1
        input <= (others => '1');
        wait for 10 ns;
        assert result = "1000000"
            report "Erreur : popcount(64'hFFFFFFFFFFFFFFFF) attendu = 64" severity error;

        -- Test 3 : alternance 1010...
        input <= x"AAAAAAAAAAAAAAAA";
        wait for 10 ns;
        assert result = "0100000"
            report "Erreur : popcount(0xAAAAAAAAAAAAAAAA) attendu = 32" severity error;

        -- Test 4 : alternance 0101...
        input <= x"5555555555555555";
        wait for 10 ns;
        assert result = "0100000"
            report "Erreur : popcount(0x5555555555555555) attendu = 32" severity error;

        -- Test 5 : 16 bits à 1 au début
        input <= x"FFFF000000000000";
        wait for 10 ns;
        assert result = "0010000"
            report "Erreur : popcount(0xFFFF000000000000) attendu = 16" severity error;

        -- Fin de simulation
        wait;
    end process;

end testbench;
