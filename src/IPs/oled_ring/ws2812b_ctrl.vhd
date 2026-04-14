library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ws2812b_ctrl is
    generic (
        CLK_FREQ  : integer := 100_000_000;
        LED_COUNT : integer := 24
    );
    port (
        clk       : in  std_logic;
        reset_n   : in  std_logic;

        --
        -- INTERFACE ECRITURE DANS LES REGs
        --
        led_index : in  std_logic_vector( 7 downto 0); --
        color     : in  std_logic_vector(31 downto 0); --
        we        : in  std_logic;
        
        dout      : out std_logic;
        busy      : out std_logic
    );
end entity;

architecture rtl of ws2812b_ctrl is
    constant T0H    : integer := 40;    -- 0.4us @100MHz
    constant T1H    : integer := 80;    -- 0.8us @100MHz
    constant Tbit   : integer := 125;   -- 1.25us @100MHz
    constant Treset : integer := 5000;  -- 50us @100MHz

    type state_t is (IDLE, PREPARE, SEND, RESET);
    signal state : state_t := IDLE;

    type led_array_t is array (0 to LED_COUNT-1) of std_logic_vector(23 downto 0);
    signal color_mem : led_array_t := (others => (others => '0'));

    signal shreg     : std_logic_vector(24*LED_COUNT-1 downto 0) := (others => '0');
    signal bit_index : integer range 0 to 24*LED_COUNT-1 := 0;
    signal cnt       : integer := 0;
    signal dout_reg  : std_logic := '0';

    -- pending info (stocke la requête start pour être traitée proprement)
    signal pending_flag  : std_logic := '0';
    signal pending_index : integer range 0 to LED_COUNT-1 := 0;
    signal pending_color : std_logic_vector(23 downto 0) := (others => '0');

    signal start : std_logic;  -- pulse 1 cycle

begin
    dout <= dout_reg;
    busy <= '1' when state /= IDLE else '0';

    start <= '1' WHEN color(31) = '1' and we = '1' ELSE '0';

    process(clk)
        VARIABLE index : integer range 0 to LED_COUNT - 1;
    BEGIN
        IF rising_edge(clk) then
            if we = '1' and color(31) = '0' then
                REPORT "LOADING LED VALUE";
                index := TO_INTEGER( UNSIGNED(led_index) );
                color_mem(index) <= color(23 downto 0);
            end if;
        end IF;
    end process;

    process(clk, reset_n)
        -- variables locales pour préparation (utilisées seulement dans PREPARE)
        variable tmp_shreg : std_logic_vector(24*LED_COUNT-1 downto 0);
        variable tmp_leds  : led_array_t;
        --variable i         : integer;
    begin
        if reset_n = '0' then
            state <= IDLE;
--          leds <= (others => (others => '0'));
            shreg <= (others => '0');
            dout_reg <= '0';
            bit_index <= 0;
            cnt <= 0;
            pending_flag <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    dout_reg <= '0';
                    cnt <= 0;
                    bit_index <= 0;
                    if start = '1' and pending_flag = '0' then
                        REPORT "STARTING LED ANNIMATION !";
                        pending_flag  <= '1';
                        pending_index <= TO_INTEGER( UNSIGNED(led_index) );
                        pending_color <= color(23 downto 0);
                        state <= PREPARE;
                    end if;

                when PREPARE =>
                    -- tmp_leds := leds (copie), appliquer la mise à jour demandée
                    tmp_leds := color_mem;
                    if pending_flag = '1' then
                        --tmp_leds(pending_index) := pending_color;
                        pending_flag <= '0';
                    end if;

                    -- construire tmp_shreg en plaçant explicitement chaque slice
                    tmp_shreg := (others => '0');
                    for i in 0 to LED_COUNT-1 loop
                        -- place tmp_leds(i) dans la tranche correspondante (MSB first)
--                      tmp_shreg(24*(LED_COUNT-i)-1 downto 24*(LED_COUNT-i-1)) :=
                        tmp_shreg(24*(i+1)-1 downto 24*i) :=
                            tmp_leds(i);
                    end loop;

                    shreg <= tmp_shreg;
                    --leds <= tmp_leds;        -- confirmer la mise à jour en mémoire
                    bit_index <= 0;
                    cnt <= 0;
                    state <= SEND;

                when SEND =>
                    if cnt = 0 then
                        dout_reg <= '1';
                        cnt <= 1;
                    else
                        -- si le bit courant (MSB) = '1' => T1H, sinon T0H
                        if shreg(24*LED_COUNT-1) = '1' then
                            if cnt = T1H then
                                dout_reg <= '0';
                            end if;
                        else
                            if cnt = T0H then
                                dout_reg <= '0';
                            end if;
                        end if;

                        if cnt = Tbit then
                            -- décaler (MSB consommé)
                            shreg <= shreg(24*LED_COUNT-2 downto 0) & '0';
                            bit_index <= bit_index + 1;
                            cnt <= 0;
                            if bit_index = (24*LED_COUNT - 1) then
                                state <= RESET;
                                cnt <= 0;
                                dout_reg <= '0';
                            end if;
                        else
                            cnt <= cnt + 1;
                        end if;
                    end if;

                when RESET =>
                    dout_reg <= '0';
                    if cnt >= Treset then
                        state <= IDLE;
                        cnt <= 0;
                    else
                        cnt <= cnt + 1;
                    end if;

                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;
end architecture;
