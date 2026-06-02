library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity time_cnt is
    Generic(
        clock_freq : integer := 100000000
    );
    Port ( 
        CLK       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        index_v   : in  STD_LOGIC_VECTOR( 4 downto 0);
        data_i    : in  STD_LOGIC_VECTOR(31 downto 0); -- données à écrire (GRB)
        write_en  : in  STD_LOGIC;                      -- écriture couleur
        data_o    : out STD_LOGIC_VECTOR(31 downto 0)
    );
end time_cnt; 

architecture arch of time_cnt is

    SIGNAL cnt_ticks   : INTEGER RANGE 0 TO 100000000 := 0; -- clock ticks
    SIGNAL cnt_months  : INTEGER RANGE 0 TO 11 :=  5;
    SIGNAL cnt_days    : INTEGER RANGE 0 TO 31 := 23;
    SIGNAL cnt_hours   : INTEGER RANGE 0 TO 23 := 12;
    SIGNAL cnt_minutes : INTEGER RANGE 0 TO 59 :=  6;
    SIGNAL cnt_seconds : INTEGER RANGE 0 TO 59 := 13;

    SIGNAL max_jours   : INTEGER RANGE 0 TO 31;
    
    SIGNAL d_ticks   : STD_LOGIC := '0';
    SIGNAL d_seconds : STD_LOGIC := '0';
    SIGNAL d_minutes : STD_LOGIC := '0';
    SIGNAL d_hours   : STD_LOGIC := '0';
    SIGNAL d_days    : STD_LOGIC := '0';
    
begin

    -----------------------------------------------------------------------
    -- 
    -- Gestion des ticks d'horloge
    --
    process(clk)
    begin   
        if rising_edge(clk) then
            if cnt_ticks = (clock_freq-1) then
                cnt_ticks <=  0;
                d_ticks   <= '1';
            else
                cnt_ticks <= cnt_ticks + 1;
                d_ticks   <= '0';
            end if;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- 
    -- Gestion des secondes (60s)
    --
    process(clk)
    begin   
        if rising_edge(clk) then
            if (d_ticks = '1') and (cnt_seconds = 59) then
                cnt_seconds  <=  0;
                d_seconds    <= '1';
            elsif write_en = '1' and index_v(4 downto 2) = "000" then
                cnt_seconds  <= TO_INTEGER( UNSIGNED(data_i(5 downto 0)) );
                d_seconds    <= '0';
            elsif d_ticks = '1' then
                cnt_seconds  <= cnt_seconds + 1;
                d_seconds    <= '0';
            else
                cnt_seconds  <= cnt_seconds;
                d_seconds    <= '0';
            end if;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- 
    -- Gestion des minutes (60mn)
    --
    process(clk)
    begin   
        if rising_edge(clk) then
            if (d_seconds = '1') and (cnt_minutes = 59) then
                cnt_minutes  <=  0;
                d_minutes    <= '1';
            elsif write_en = '1' and index_v(4 downto 2) = "001" then
                cnt_minutes  <= TO_INTEGER( UNSIGNED(data_i(5 downto 0)) );
                d_minutes    <= '0';
            elsif d_seconds = '1' then
                cnt_minutes  <= cnt_minutes + 1;
                d_minutes    <= '0';
            else
                cnt_minutes  <= cnt_minutes;
                d_minutes    <= '0';
            end if;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- 
    -- Gestion des heures (24h)
    --
    process(clk)
    begin   
        if rising_edge(clk) then
            if (d_minutes = '1') and (cnt_hours = 23) then
                cnt_hours  <=  0;
                d_hours    <= '1';
            elsif write_en = '1' and index_v(4 downto 2) = "010" then
                cnt_hours  <= TO_INTEGER( UNSIGNED(data_i(4 downto 0)) );
                d_hours    <= '0';
            elsif d_minutes = '1' then
                cnt_hours  <= cnt_hours + 1;
                d_hours    <= '0';
            else
                cnt_hours  <= cnt_hours;
                d_hours    <= '0';
            end if;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- 
    -- Gestion des mois (28, 30, 31 jours)
    --

    process(clk)
    begin   
        if rising_edge(clk) then
            if (d_hours = '1') and (cnt_days = (max_jours-1)) then
                cnt_days <=  0;
                d_days   <= '1';
            elsif write_en = '1' and index_v(4 downto 2) = "011" then
                cnt_days <= TO_INTEGER( UNSIGNED(data_i(4 downto 0)) );
                d_days   <= '0';
            elsif d_hours = '1' then
                cnt_days <= cnt_days + 1;
                d_days   <= '0';
            else
                cnt_days <= cnt_days;
                d_days   <= '0';
            end if;
        end if;
    end process;

    max_jours <= 31 when cnt_months =  0 else -- Janvier
                 28 when cnt_months =  1 else -- Février
                 31 when cnt_months =  2 else -- Mars
                 30 when cnt_months =  3 else -- Avril
                 31 when cnt_months =  4 else -- Mai
                 30 when cnt_months =  5 else -- Juin
                 31 when cnt_months =  6 else -- Juillet
                 31 when cnt_months =  7 else -- Aout
                 30 when cnt_months =  8 else -- Septembre
                 31 when cnt_months =  9 else -- Octobre
                 30 when cnt_months = 10 else -- Novembre
                 31;                          -- Decembre

    -----------------------------------------------------------------------
    -- 
    -- Gestion des mois
    --
    process(clk)
    begin   
        if rising_edge(clk) then
            if d_days = '1' then
                cnt_months <= cnt_months + 1;
            elsif write_en = '1' and index_v(4 downto 2) = "100" then
                cnt_months <= TO_INTEGER( UNSIGNED(data_i(3 downto 0)) );
            end if;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- 
    -- Gestion de la selection
    --
    data_o <=   STD_LOGIC_VECTOR( TO_UNSIGNED(cnt_seconds, 32) ) when index_v(4 downto 2) = "000" else 
                STD_LOGIC_VECTOR( TO_UNSIGNED(cnt_minutes, 32) ) when index_v(4 downto 2) = "001" else 
                STD_LOGIC_VECTOR( TO_UNSIGNED(cnt_hours,   32) ) when index_v(4 downto 2) = "010" else 
                STD_LOGIC_VECTOR( TO_UNSIGNED(cnt_days,    32) ) when index_v(4 downto 2) = "011" else 
                STD_LOGIC_VECTOR( TO_UNSIGNED(cnt_months,  32) );

end arch;
 
