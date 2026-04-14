library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.riscv_config.all;

use work.mem_ram_pkg.all; -- RAM
use work.mem_rom_pkg.all; -- ROM

entity riscv_soc_cmod is
Port ( 
   CLK_12MHz     : in  STD_LOGIC;
   RESET_i       : in  STD_LOGIC;
   USER_i        : in  STD_LOGIC;
   
   LED 		     : out STD_LOGIC_VECTOR ( 1 downto 0);

   JA_PMOD_CS    : out STD_LOGIC;
   JA_PMOD_MOSI  : out STD_LOGIC;
   JA_PMOD_SCK   : out STD_LOGIC;
   JA_PMOD_DC    : out STD_LOGIC;
   JA_PMOD_RES   : out STD_LOGIC;
   JA_PMOD_VCCEN : out STD_LOGIC;
   JA_PMOD_EN    : out STD_LOGIC;

   led0_b        : out STD_LOGIC;
   led0_g        : out STD_LOGIC;
   led0_r        : out STD_LOGIC;

   ws2812b_pin   : out STD_LOGIC;

   UART_RXD_OUT  : out STD_LOGIC;
   UART_TXD_IN   : in  STD_LOGIC
);
end riscv_soc_cmod;

architecture arch of riscv_soc_cmod is

    CONSTANT OLED_BPP  : INTEGER := 16;

    COMPONENT riscv IS
    PORT ( 
       CLK           : in  STD_LOGIC;
       resetn        : in  STD_LOGIC;

       im_addr       : out STD_LOGIC_VECTOR (31 downto 0);
       im_rdata      : in  STD_LOGIC_VECTOR (31 downto 0);
    
       dm_addr       : out STD_LOGIC_VECTOR (31 downto 0);
       dm_rdata      : in  STD_LOGIC_VECTOR (31 downto 0);
       dm_wdata      : out STD_LOGIC_VECTOR (31 downto 0);
       dm_wmask      : out STD_LOGIC_VECTOR ( 3 downto 0);
       dm_rd         : out STD_LOGIC;
       dm_wr         : out STD_LOGIC
    );
    END COMPONENT;

   ---------------------------------------------------------------------------------------------------
    
    COMPONENT uart_send is
        Generic ( fifo_size             : integer := 64;
                  fifo_almost           : integer := 60;
                  drop_oldest_when_full : boolean := False;
                  asynch_fifo_full      : boolean := True);
        Port ( clk_100MHz : in  STD_LOGIC;
               reset      : in  STD_LOGIC;
               dat_en     : in  STD_LOGIC;
               dat        : in  STD_LOGIC_VECTOR (7 downto 0);
               TX         : out STD_LOGIC;
               fifo_empty : out STD_LOGIC;
               fifo_afull : out STD_LOGIC;
               fifo_full  : out STD_LOGIC);
    end COMPONENT;

   ---------------------------------------------------------------------------------------------------
    

    COMPONENT UART_recv is
       Port ( clk    : in  STD_LOGIC;
              reset  : in  STD_LOGIC;
              rx     : in  STD_LOGIC;
              dat    : out STD_LOGIC_VECTOR (7 downto 0);
              dat_en : out STD_LOGIC);
    end COMPONENT;

   ---------------------------------------------------------------------------------------------------

    COMPONENT clk_wiz_0 is
       Port (
        clk_in1  : in  STD_LOGIC;
        clk_out1 : out STD_LOGIC);
    end COMPONENT;

   ---------------------------------------------------------------------------------------------------

   COMPONENT time_cnt is
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
   end COMPONENT; 

   ---------------------------------------------------------------------------------------------------

   COMPONENT ws2812b_ctrl is
   generic (
        CLK_FREQ  : integer := 100_000_000;
        LED_COUNT : integer := 24
   );
   port (
      clk       : in  std_logic;
      reset_n   : in  std_logic;
      led_index : in  std_logic_vector( 7 downto 0);
      color     : in  std_logic_vector(31 downto 0);
      we        : in  std_logic;
      dout      : out std_logic;
      busy      : out std_logic
    );
   end COMPONENT;

   ---------------------------------------------------------------------------------------------------

   SIGNAL im_addr     : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL im_rdata    : STD_LOGIC_VECTOR (31 downto 0);

   SIGNAL dm_addr     : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL dm_rdata    : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL dm_wdata    : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL dm_wmask    : STD_LOGIC_VECTOR ( 3 downto 0);
   SIGNAL dm_wmask_v  : STD_LOGIC_VECTOR ( 3 downto 0);
   SIGNAL dm_rd       : STD_LOGIC;
   SIGNAL dm_wr       : STD_LOGIC;

   SIGNAL CLOCK : STD_LOGIC;
   SIGNAL RESET      : STD_LOGIC;
   SIGNAL RESETN     : STD_LOGIC;
   SIGNAL USER_BTN   : STD_LOGIC;
   
    SIGNAL IO_wordaddr  : STD_LOGIC_VECTOR (13 downto 0);

    SIGNAL uart_ready : STD_LOGIC;
    SIGNAL uart_full  : STD_LOGIC;

    SIGNAL data_to_spi         : STD_LOGIC_VECTOR (7 downto 0);
    SIGNAL data_from_spi_en    : STD_LOGIC;
    SIGNAL data_from_spi       : STD_LOGIC_VECTOR (7 downto 0);
    SIGNAL data_from_spi_busy  : STD_LOGIC;

   SIGNAL data_from_oled_rgb  : STD_LOGIC_VECTOR (OLED_BPP-1 downto 0);
   SIGNAL data_to_oled_rgb    : STD_LOGIC_VECTOR (OLED_BPP-1 downto 0);
   SIGNAL data_x_to_oled_rgb  : STD_LOGIC_VECTOR ( 6 downto 0);
   SIGNAL data_y_to_oled_rgb  : STD_LOGIC_VECTOR ( 5 downto 0);

   SIGNAL data_to_uart         : STD_LOGIC_VECTOR (7 downto 0);
   SIGNAL uart_for_debug       : STD_LOGIC_VECTOR (7 downto 0);

   SIGNAL data_from_uart_en    : STD_LOGIC;
   SIGNAL data_from_uart       : STD_LOGIC_VECTOR (7 downto 0);
   SIGNAL data_from_uart_s     : STD_LOGIC;
   SIGNAL data_from_uart_b     : STD_LOGIC_VECTOR (7 downto 0);

  	SIGNAL   leds_buffer        : STD_LOGIC_VECTOR (1 downto 0);

   SIGNAL ring_load_we         : STD_LOGIC_VECTOR (7 downto 0);
   SIGNAL ring_start_we        : STD_LOGIC_VECTOR (7 downto 0);


	SIGNAL data_to_ram_en        : STD_LOGIC;
	SIGNAL data_to_leds_en       : STD_LOGIC;
	SIGNAL data_to_sws_btn_en    : STD_LOGIC;
	SIGNAL data_to_uart_en       : STD_LOGIC;
	SIGNAL data_to_spi_en        : STD_LOGIC;
	SIGNAL data_to_vga_en        : STD_LOGIC;
	SIGNAL data_to_sdcart_en     : STD_LOGIC;
	SIGNAL data_to_RT_clk_en    : STD_LOGIC;
	SIGNAL data_to_oled_scr_en   : STD_LOGIC;
	SIGNAL data_to_timer_en      : STD_LOGIC;
	SIGNAL data_to_ledrgb_en     : STD_LOGIC;
	SIGNAL data_to_ring_led_en   : STD_LOGIC;
	SIGNAL data_to_soc_id_en     : STD_LOGIC;

	SIGNAL data_to_ram_wen       : STD_LOGIC;
	SIGNAL data_to_leds_wen      : STD_LOGIC;
	SIGNAL data_to_sws_btn_wen   : STD_LOGIC;
	SIGNAL data_to_uart_wen      : STD_LOGIC;
	SIGNAL data_to_spi_wen       : STD_LOGIC;
	SIGNAL data_to_vga_wen       : STD_LOGIC;
	SIGNAL data_to_sdcart_wen    : STD_LOGIC;
	SIGNAL data_to_RT_clk_wen    : STD_LOGIC;
	SIGNAL data_to_oled_scr_wen  : STD_LOGIC;
	SIGNAL data_to_timer_wen     : STD_LOGIC;
	SIGNAL data_to_ledrgb_wen    : STD_LOGIC;
	SIGNAL data_to_ring_led_wen  : STD_LOGIC;

   SIGNAL d32b_from_leds       : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL d32b_from_swit       : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL d32b_from_btns       : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL d32b_from_uart       : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL d32b_from_spi        : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL d32b_from_vga_buff   : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL d32b_from_sd_card    : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL d32b_from_RT_clk     : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL d32b_from_oled_rgb   : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL d32b_from_timer      : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL d32b_from_led_rgb    : STD_LOGIC_VECTOR (31 downto 0); 
   SIGNAL d32b_from_ram        : STD_LOGIC_VECTOR (31 downto 0); 
   SIGNAL d32b_from_soc_id     : STD_LOGIC_VECTOR (31 downto 0);

begin

   -- 31   27   23   19    15   11    7    3  0
   -- 0000 0000 0000 0000  0000 0000  0000 0000 ROM      (0x00010000) -- 64 bytes max.
   -- 0000 0000 0000 0001  0000 0000  0000 0000 RAM      (0x00010000) -- 64 bytes max.
   -- 0000 0100 0000 0000  0000 0000  0000 0000 LEDS     (0x04000000)
   -- 0000 0101 0000 0000  0000 0000  0000 0000 SWITCH   (0x05000000) -- SWITCHs / BTNs
   -- 0000 1010 0000 0000  0000 0000  0000 0000 UART     (0x06000000)
   -- 0000 0011 0000 0000  0000 0000  0000 0000 OLED SPI (0x07000000)
   -- 0000 0100 0000 0000  0000 0000  0000 0000 VGA      (0x08000000)
   -- 0000 0101 0000 0000  0000 0000  0000 0000 SD card  (0x09000000)
   -- 0000 0110 0000 0000  0000 0000  0000 0000 fake-RTC (0x0A000000)
   -- 0000 0111 0000 0000  0000 0000  0000 0000 oled-scr (0x0B000000)
   -- 0000 1000 0000 0000  0000 0000  0000 0000 timer    (0x0C000000)
   -- 0000 1001 0000 0000  0000 0000  0000 0000 RGB-LED  (0x0D000000)

   data_to_ram_en       <= '1' WHEN dm_addr(27 downto 24) = "0000" else '0';

   data_to_leds_en      <= '1' WHEN dm_addr(27 downto 24) = "0100" else '0'; -- 0x04
   data_to_sws_btn_en   <= '1' WHEN dm_addr(27 downto 24) = "0101" else '0'; -- 0x05
   data_to_uart_en      <= '1' WHEN dm_addr(27 downto 24) = "0110" else '0'; -- 0x06
   data_to_spi_en       <= '1' WHEN dm_addr(27 downto 24) = "0111" else '0'; -- 0x07
   data_to_vga_en       <= '1' WHEN dm_addr(27 downto 24) = "1000" else '0'; -- 0x08
   data_to_sdcart_en    <= '1' WHEN dm_addr(27 downto 24) = "1001" else '0'; -- 0x09
   data_to_RT_clk_en    <= '1' WHEN dm_addr(27 downto 24) = "1010" else '0'; -- 0x0A
   data_to_oled_scr_en  <= '1' WHEN dm_addr(27 downto 24) = "1011" else '0'; -- 0x0B
   data_to_timer_en     <= '1' WHEN dm_addr(27 downto 24) = "1100" else '0'; -- 0x0C
   data_to_ledrgb_en    <= '1' WHEN dm_addr(27 downto 24) = "1101" else '0'; -- 0x0D
   data_to_ring_led_en  <= '1' WHEN dm_addr(27 downto 24) = "1110" else '0'; -- 0x0E
   data_to_soc_id_en    <= '1' WHEN dm_addr(27 downto 24) = "1111" else '0'; -- 0x0F

   data_to_ram_wen      <= data_to_ram_en      and dm_wr;
   data_to_leds_wen     <= data_to_leds_en     and dm_wr;
   data_to_sws_btn_wen  <= data_to_sws_btn_en  and dm_wr;
   data_to_uart_wen     <= data_to_uart_en     and dm_wr;
   data_to_spi_wen      <= data_to_spi_en      and dm_wr;
   data_to_vga_wen      <= data_to_vga_en      and dm_wr;
   data_to_sdcart_wen   <= data_to_sdcart_en   and dm_wr;
   data_to_RT_clk_wen   <= data_to_RT_clk_en   and dm_wr;
   data_to_oled_scr_wen <= data_to_oled_scr_en and dm_wr;
   data_to_timer_wen    <= data_to_timer_en    and dm_wr;
   data_to_ledrgb_wen   <= data_to_ledrgb_en   and dm_wr;
   data_to_ring_led_wen <= data_to_ring_led_en and dm_wr;

   ---------------------------------------------------------------------------------------------------

   time_ctrl : ENTITY work.timer_ctrl
   PORT MAP(
      clock     => CLOCK,
      reset     => RESET,
      addr_lsb  => dm_addr(3 downto 0),
      data_i    => dm_wdata,
      data_o    => d32b_from_timer,
      write_en  => data_to_timer_wen
   );

   ---------------------------------------------------------------------------------------------------

   horloge : time_cnt
   GENERIC MAP( clock_freq => 100000000 ) -- 100 MHz
   PORT MAP ( 
      CLK       => CLOCK,
      reset     => RESET,
      index_v   => dm_addr(4 downto 0),
      data_i    => dm_wdata,
      write_en  => data_to_RT_clk_wen,
      data_o    => d32b_from_RT_clk
   );


   ---------------------------------------------------------------------------------------------------

    led_rgb_1 : ENTITY work.led_rgb_ctrl
    PORT MAP(
      clock     => CLOCK,
      reset     => RESET,
      data_i    => dm_wdata,
      data_o    => d32b_from_led_rgb,
      write_en  => data_to_ledrgb_wen,
      led_r_o   => led0_r,
      led_g_o   => led0_g,
      led_b_o   => led0_b
    );

   ---------------------------------------------------------------------------------------------------

   PROCESS(CLOCK)
   BEGIN
      if rising_edge(CLOCK) then
         RESET  <=     RESET_i;
         RESETN <= NOT RESET_i;
      END IF;
   END PROCESS;

   ---------------------------------------------------------------------------------------------------

   PROCESS(CLOCK)
   BEGIN
      if rising_edge(CLOCK) then
         d32b_from_btns  <=  x"0000000" & "000" & USER_i;
      END IF;
   END PROCESS;

   ---------------------------------------------------------------------------------------------------

   clk_gen : clk_wiz_0
   PORT MAP(
      clk_in1  => CLK_12MHz,
      clk_out1 => CLOCK
   );

   ---------------------------------------------------------------------------------------------------

   CPU : riscv
   PORT MAP(
      clk          => CLOCK,
      resetn       => RESETN,
      im_addr      => im_addr,
      im_rdata     => im_rdata,
      dm_addr      => dm_addr,
      dm_rdata     => dm_rdata,
      dm_wdata     => dm_wdata,
      dm_wmask     => dm_wmask,
      dm_rd        => dm_rd,
      dm_wr        => dm_wr   
   );

   ---------------------------------------------------------------------------------------------------

   IO_wordaddr <= dm_addr(15 downto 2);

   ---------------------------------------------------------------------------------------------------

   prog_rom : mem_rom
   PORT MAP ( 
       CLOCK  => CLOCK,
       ENABLE => '1',
       ADDR_R => im_addr(ROM_ADDR-1 downto 0),
       DATA_O => im_rdata
   );

   ---------------------------------------------------------------------------------------------------

   data_ram : mem_ram
   PORT MAP( 
      CLOCK   => CLOCK,
      ADDR_RW => dm_addr(RAM_ADDR-1 downto 0),
      ENABLE  => data_to_ram_en,
      WRITE_M => dm_wmask_v,
      DATA_W  => dm_wdata,
      DATA_R  => d32b_from_ram
   );

   ---------------------------------------------------------------------------------------------------

   dm_wmask_v <= dm_wmask when data_to_ram_wen = '1' else "0000";

   ---------------------------------------------------------------------------------------------------

   process(CLOCK)
   begin   
      if rising_edge(CLOCK) then
         IF RESET = '1' THEN
            leds_buffer <= (others => '0');
         ELSIF data_to_leds_wen = '1' then
            leds_buffer <= dm_wdata(1 downto 0);
         end if;
      end if;
   end process;

   ---------------------------------------------------------------------------------------------------

   process(CLOCK)
   begin   
      if rising_edge(CLOCK) then
         if RESET = '1' then
            LED <= "11";
         else
            LED <= leds_buffer;
         end if;
      end if;
   end process;

   ---------------------------------------------------------------------------------------------------

   uart_ready     <= NOT uart_full;
   data_to_uart   <= dm_wdata(7 downto 0);
   data_to_spi    <= dm_wdata(7 downto 0);

   ---------------------------------------------------------------------------------------------------

   UART_s_custom : uart_send
      Generic MAP(
         fifo_size        => 2048,
         fifo_almost      => 2000,
         asynch_fifo_full => True
      )
      PORT MAP(
         clk_100MHz => CLOCK,
         reset      => reset,
         dat_en     => data_to_uart_wen,
         dat        => data_to_uart,
         TX         => UART_RXD_OUT,
         fifo_empty => open,
         fifo_afull => uart_full,
         fifo_full  => open);
   
   ---------------------------------------------------------
   
   UART_r_custom : UART_recv
      PORT MAP(
         clk        => CLOCK,
         reset      => reset,
         rx         => UART_TXD_IN,
         dat        => data_from_uart,
         dat_en     => data_from_uart_en
      );
      
   ---------------------------------------------------------

   process(CLOCK)
   begin   
      if rising_edge(CLOCK) then
        IF RESET = '1' THEN
           data_from_uart_b <= x"00";
           data_from_uart_s <= '0'; 

        ELSIF data_from_uart_en = '1' THEN 
           data_from_uart_b <= data_from_uart;
           data_from_uart_s <= data_from_uart_en; 

        ELSIF (data_from_uart_en = '1') and (dm_rd = '1') THEN 
           data_from_uart_b <= x"00";
           data_from_uart_s <= '0'; 
        END IF;
      end if;
    end process;
 
	----------------------------------------------------------
	------                                             -------
	----------------------------------------------------------

   oled_rgb_96x64 : ENTITY work.PmodOLEDrgb_bitmap
        GENERIC MAP(CLK_FREQ_HZ => 100000000, -- by default, we run at 100MHz
                BPP         => OLED_BPP,      -- bits per pixel
                GREYSCALE   => False,         -- color or greyscale ? (only for BPP>6)
                LEFT_SIDE   => False)         -- True if the Pmod is on the left side of the board
        PORT MAP(
            clk          => CLOCK,
            reset        => RESET,
          
            pix_write    => data_to_oled_scr_wen,
            pix_col      => data_x_to_oled_rgb,
            pix_row      => data_y_to_oled_rgb,
            pix_data_in  => data_to_oled_rgb,
            pix_data_out => data_from_oled_rgb,
          
            PMOD_CS      => JA_PMOD_CS,
            PMOD_MOSI    => JA_PMOD_MOSI,
            PMOD_SCK     => JA_PMOD_SCK,
            PMOD_DC      => JA_PMOD_DC,
            PMOD_RES     => JA_PMOD_RES,
            PMOD_VCCEN   => JA_PMOD_VCCEN,
            PMOD_EN      => JA_PMOD_EN
        );

    data_to_oled_rgb   <= dm_wdata(OLED_BPP-1 downto 0);

    data_x_to_oled_rgb <= std_logic_vector( to_unsigned(to_integer(UNSIGNED(IO_wordaddr)) mod 96, 7) );
    data_y_to_oled_rgb <= std_logic_vector( to_unsigned(to_integer(UNSIGNED(IO_wordaddr))   / 96, 6) );

	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------

   ring_cmp :  ws2812b_ctrl
   GENERIC MAP (
        CLK_FREQ  => 100_000_000,
        LED_COUNT => 113
   )
   PORT MAP (
      clk       => CLOCK,
      reset_n   => RESETN,
      led_index => dm_addr(9 downto 2),
      color     => dm_wdata,
      we        => data_to_ring_led_wen,
      dout      => ws2812b_pin,
      busy      => open
    );

	----------------------------------------------------------
	------                LED Control                  -------
	----------------------------------------------------------

    d32b_from_leds         <= x"000000" & "000000" & leds_buffer;
    d32b_from_swit         <= (others => '0');
     
    -- adresse de base        = uart_send
    -- adresse de base + 0x04 = uart_rcv
    d32b_from_uart         <= x"0000000" & "000" & (uart_ready)  when dm_addr(2) = '0' else
                              x"00000"   & "000" & data_from_uart_s  & data_from_uart_b;
                              
    d32b_from_spi          <= (others => '0');
    d32b_from_vga_buff     <= (others => '0');
    d32b_from_sd_card      <= (others => '0');
    d32b_from_oled_rgb     <= x"0000" & data_from_oled_rgb; -- OLED_BPP
    
    dm_rdata <= d32b_from_leds       when data_to_leds_en     = '1'
            else d32b_from_swit      when data_to_sws_btn_en  = '1' AND dm_addr(2) = '0'
            else d32b_from_btns      when data_to_sws_btn_en  = '1' AND dm_addr(2) = '1'
            else d32b_from_uart      when data_to_uart_en     = '1'
            else d32b_from_spi       when data_to_spi_en      = '1'
            else d32b_from_vga_buff  when data_to_vga_en      = '1'
            else d32b_from_sd_card   when data_to_sdcart_en   = '1'
            else d32b_from_RT_clk    when data_to_RT_clk_en = '1'
            else d32b_from_oled_rgb  when data_to_oled_scr_en = '1'
            else d32b_from_timer     when data_to_timer_en    = '1'
            else d32b_from_led_rgb   when data_to_ledrgb_en   = '1'
            -- ele le RING RGB qui ne retourne rien
            else d32b_from_soc_id    when data_to_soc_id_en   = '1' -- identifiant du coeur
            else d32b_from_ram;

   d32b_from_soc_id <= x"434D4F44"                                    WHEN dm_addr(4 downto 2) = "000" else -- NEXYS-A7 SoC
                       STD_LOGIC_VECTOR( TO_UNSIGNED(100000000, 32) ) WHEN dm_addr(4 downto 2) = "001" else -- frequence core
                       STD_LOGIC_VECTOR( TO_UNSIGNED(        2, 32) ) WHEN dm_addr(4 downto 2) = "010" else -- #leds
                       STD_LOGIC_VECTOR( TO_UNSIGNED(        1, 32) ) WHEN dm_addr(4 downto 2) = "011" else -- #boutons
                       STD_LOGIC_VECTOR( TO_UNSIGNED(        0, 32) ) WHEN dm_addr(4 downto 2) = "100" else -- #switches
                       STD_LOGIC_VECTOR( TO_UNSIGNED(        1, 32) ) WHEN dm_addr(4 downto 2) = "101" else -- OLED RGB ?
                       STD_LOGIC_VECTOR( TO_UNSIGNED(        0, 32) ) WHEN dm_addr(4 downto 2) = "110" else -- 7 segs
                       STD_LOGIC_VECTOR( TO_UNSIGNED(        0, 32) ) WHEN dm_addr(4 downto 2) = "111" else -- Pipelined core
                       x"00000000"; 

   ---------------------------------------------------------------------------------------------------

end arch;

