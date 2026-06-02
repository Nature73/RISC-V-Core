library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_rgb_ctrl_nano20k is
  Port (
    clock    : in  STD_LOGIC;
    reset    : in  STD_LOGIC;
    data_i   : in  STD_LOGIC_VECTOR(31 downto 0); -- données à écrire (GRB)
    data_o   : out STD_LOGIC_VECTOR(31 downto 0); -- données lues
    write_en : in  STD_LOGIC;                      -- écriture couleur
    wire_o   : out STD_LOGIC                       -- sortie WS2812B
  );
end led_rgb_ctrl_nano20k;

architecture rtl of led_rgb_ctrl_nano20k is

  --------------------------------------------------------------------------
  -- Paramètres pour une fréquence de 27 MHz
  -- Période d'horloge = 37,037 ns
  -- 0 : T0H = 0.4 µs  → ~10,8 cycles ≈ 11
  -- 1 : T1H = 0.8 µs  → ~21,6 cycles ≈ 22
  -- Total : 1.25 µs   → ~33,75 cycles ≈ 34
  -- Reset : 50 µs     → ~1350 cycles
  --------------------------------------------------------------------------
  constant T0H          : integer := 11;
  constant T1H          : integer := 22;
  constant TOTAL_PERIOD : integer := 34;
  constant RESET_PERIOD : integer := 1350;

  type state_type is (IDLE, SEND, LATCH);
  signal state       : state_type := IDLE;
  signal color_reg   : std_logic_vector(23 downto 0) := (others => '0');
  signal bit_index   : integer range 0 to   23 := 0;
  signal cnt         : integer range 0 to 2047 := 0;
  signal led_data    : std_logic := '0';

begin

  -- Retourne la couleur actuellement stockée
  data_o <= x"00" & color_reg;

  process(clock, reset)
  begin
    if reset = '1' then
      state     <= IDLE;
      cnt       <= 0;
      bit_index <= 0;
      led_data  <= '0';
      color_reg <= (others => '0');

    elsif rising_edge(clock) then
      case state is

        ------------------------------------------------------------------
        -- IDLE : attend un write_en pour capturer la nouvelle couleur
        ------------------------------------------------------------------
        when IDLE =>
          led_data <= '0';
          cnt <= 0;
          if write_en = '1' then
--          color_reg <= data_i(23 downto 0);
            color_reg <= data_i(15 downto 8) & data_i(7 downto 0) & data_i(23 downto 16); -- LE DONNEES ARRIVENT EN [B..G..R] =>> (gg << 16) | (rr << 8) | bb;
            bit_index <= 23;
            state <= SEND;
          end if;

        ------------------------------------------------------------------
        -- SEND : envoi du flux WS2812B (24 bits GRB)
        ------------------------------------------------------------------
        when SEND =>
          cnt <= cnt + 1;

          -- niveau haut selon bit
          if color_reg(bit_index) = '1' then
            if cnt < T1H then
              led_data <= '1';
            else
              led_data <= '0';
            end if;
          else
            if cnt < T0H then
              led_data <= '1';
            else
              led_data <= '0';
            end if;
          end if;

          -- passage au bit suivant
          if cnt >= TOTAL_PERIOD then
            cnt <= 0;
            if bit_index = 0 then
              state <= LATCH;
            else
              bit_index <= bit_index - 1;
            end if;
          end if;

        ------------------------------------------------------------------
        -- LATCH : délai de reset (50 µs)
        ------------------------------------------------------------------
        when LATCH =>
          led_data <= '0';
          cnt <= cnt + 1;
          if cnt >= RESET_PERIOD then
            cnt <= 0;
            state <= IDLE;
          end if;

      end case;
    end if;
  end process;

  wire_o <= led_data;

end rtl;
