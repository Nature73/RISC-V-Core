/**
 * 
 * Bertrand LE GAL (bertrand.le-gal@irisa.fr)
 * 
*/
#include <libuc.h>

inline long cycles() {
   int cycles;
   asm volatile ("rdcycle %0" : "=r"(cycles));
   return cycles;
}

inline long insn() {
   int insns;
   asm volatile ("rdinstret %0" : "=r"(insns));
   return insns;
}

void show_time()
{
   const int hours   = get_rtc_hours  ();
   const int minutes = get_rtc_minutes();
   const int seconds = get_rtc_seconds();

   print_dec( hours );
   if( minutes < 10 ) printf(":0");
   else               printf(":");
   print_dec( minutes );
   if( seconds < 10 ) printf(":0");
   else               printf(":");
   print_dec( seconds );
   printf(" - ");
   print_dec( get_rtc_days  () ); printf(":");
   print_dec( get_rtc_months() ); printf(":");
   printf   ( "????" );           printf("\r\n");
}

int main()
{
   printf("\033[2J\033[H"); // effacement du terminal
   printf("\r\n");
   printf("EEEEEEE  NN   N  SSSSSS  SSSSSS  AAAAAA  TTTTTTT\r\n");
   printf("E        N N  N  S       S       A    A     T   \r\n");
   printf("EEEEE    N  N N   SSSSS   SSSSS  AAAAAA     T   \r\n");
   printf("E        N   NN       S       S  A    A     T   \r\n");
   printf("EEEEEEE  N    N  SSSSSS  SSSSSS  A    A     T   \r\n");
   printf("                                     (2025-2026)\r\n");
   printf("                                 Bertrand LE GAL\r\n");
   printf("\r\n");
   printf("Let me introduce myself, I am the ENSSAT's RISC-V\r\n");
   printf("Program release :\r\n");
   printf(__DATE__);
   printf(" ");
   printf(__TIME__);
   printf( "\r\n");
   printf("(II)\r\n");
   printf("(II) Processor id       = "); print_hex( get_soc_id       () ); printf("\r\n");
   printf("(II)                    = "); printf_platform( get_soc_id () ); printf("\r\n");
   printf("(II) is pipeline core   = "); print_dec( get_soc_pipeline () ); printf("\r\n");
   printf("(II) Clock frequency    = "); print_dec( get_soc_frequency() ); printf("\r\n");
   printf("(II)\r\n");
   printf("(II) Platform #LEDs     = "); print_dec( get_soc_leds     () ); printf("\r\n");
   printf("(II) Platform #buttons  = "); print_dec( get_soc_buttons  () ); printf("\r\n");
   printf("(II) Platform #switches = "); print_dec( get_soc_switches () ); printf("\r\n");
   printf("(II) Platform has OLED  = "); print_dec( get_soc_oleds    () ); printf("\r\n");
   printf("(II) Platform has 7segs = "); print_dec( get_soc_7segs    () ); printf("\r\n");
   printf("(II)\r\n");

   printf("RTC module\r\n");
   show_time();

   printf("LEDs annimation : start\r\n");

   int* ptr_leds = (int*)0x04000000;
   int leds = 0x01;

   int cnt = 0;
   while( 1 )
   {
      *ptr_leds = leds;
// INTEL DE-10 Lite      
//    leds = (leds << 1) | ((leds >>  7) & 0x01);
// TANG
      leds = (leds << 1) | ((leds >>  5) & 0x01);
// AMD XILINX NEXYS A7
//      leds = (leds << 1) | ((leds >>  7) & 0x01);
// AMD XILINX CMOD-A7
//    leds = (leds << 1) | ((leds >>  1) & 0x01);
      sleep( 1 );

      if( cnt == 10 ){
         cnt = 0;
         show_time();
      }else{
         cnt += 1;
      }
   }

   printf("LEDs annimation : stop\r\n");

   return 0;
}
