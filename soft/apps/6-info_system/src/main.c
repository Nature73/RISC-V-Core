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

int main()
{
   printf("(ii)\n");
   printf("(ii) HELLO world !\n");
   printf("(ii) Let me introduce myself, I am the BreiZH RISC-V.\n");
   printf("(ii) release :\n");
   printf("(ii) ");
   printf(__DATE__);
   printf(" ");
   printf(__TIME__);
   printf( "\n");
   printf("(II)\n");
   printf("(II) get_soc_id       () = "); print_hex( get_soc_id       () ); printf("\n");
   printf("(II)                     = "); printf_platform( get_soc_id () ); printf("\n");
   printf("(II) get_soc_frequency() = "); print_dec( get_soc_frequency() ); printf("\n");
   printf("(II) get_soc_leds     () = "); print_dec( get_soc_leds     () ); printf("\n");
   printf("(II) get_soc_buttons  () = "); print_dec( get_soc_buttons  () ); printf("\n");
   printf("(II) get_soc_switches () = "); print_dec( get_soc_switches () ); printf("\n");
   printf("(II) get_soc_oleds    () = "); print_dec( get_soc_oleds    () ); printf("\n");
   printf("(II) get_soc_7segs    () = "); print_dec( get_soc_7segs    () ); printf("\n");
   printf("(II) get_soc_pipeline () = "); print_dec( get_soc_pipeline () ); printf("\n");
   printf("(II)\n");

   if( get_soc_buttons() != 0 )
   {
      printf("(II) read_buttons  () = "); print_hex( read_buttons() ); printf("\n");
   }

   if( get_soc_switches() != 0 )
   {
      printf("(II) read_switchs  () = "); print_hex( read_switchs() ); printf("\n");
   }

   if( get_soc_leds() != 0 )
   {
      printf("(II) write_leds  (0x33)"); printf("\n");
      write_leds( 0x33 );
   }

   printf("(II) program ended\n");

   return 0;
}
