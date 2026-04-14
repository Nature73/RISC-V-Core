#include "../libuc.h"

/*                        */
/*                        */
/* External timer control */
/*                        */
/*                        */
int get_soc_id       ()
{
   volatile unsigned int* ptr = (unsigned int*)0x0F000000;
   return (*ptr);
}

void printf_platform  (const int value)
{
// 43 4D 4F 44 CMOD
   if( value == 0x434D4F44 ) 
      printf("CMOD-A7");
// 4E 45 58 59 NEXY-S
   else if ( value == 0x4E455859 ) 
      printf("NEXYS-A7");
// 54 41 4E 47 TANG
   else if ( value == 0x54414E47 ) 
      printf("NANO 20K");
// 44 45 31 30 DE10
   else if ( value == 0x44453130 ) 
      printf("DE-10 Lite");
   else
      printf("UNKNOW");
}

int get_soc_frequency()
{
   volatile unsigned int* ptr = (unsigned int*)0x0F000004;
   return (*ptr);
}

int get_soc_leds     ()
{
   volatile unsigned int* ptr = (unsigned int*)0x0F000008;
   return (*ptr);
}

int get_soc_buttons  ()
{
   volatile unsigned int* ptr = (unsigned int*)0x0F00000C;
   return (*ptr);
}

int get_soc_switches ()
{
   volatile unsigned int* ptr = (unsigned int*)0x0F000010;
   return (*ptr);
}

int get_soc_oleds()
{
   volatile unsigned int* ptr = (unsigned int*)0x0F000014;
   return (*ptr);
}

int get_soc_7segs()
{
   volatile unsigned int* ptr = (unsigned int*)0x0F000018;
   return (*ptr);
}

int get_soc_pipeline()
{
   volatile unsigned int* ptr = (unsigned int*)0x0F00001C;
   return (*ptr);
}

int read_buttons()
{
   volatile unsigned int* ptr = (unsigned int*)0x05000004;
   return (*ptr);
}

int read_switchs()
{
   volatile unsigned int* ptr = (unsigned int*)0x05000000;
   return (*ptr);
}

void write_leds(const int value)
{
   volatile unsigned int* ptr = (unsigned int*)0x04000000;
   (*ptr) = value;
}

int read_leds      ()
{
   volatile unsigned int* ptr = (unsigned int*)0x04000000;
   return (*ptr);
}

void write_ring_leds(const int position, const int value)
{
   volatile unsigned int* base = (unsigned int*)0x0E000000;
   volatile unsigned int* ptr  = base + position;
   (*ptr) = value & 0x7FFFFFFF;
}

void start_ring_leds()
{
   volatile unsigned int* ptr   = (unsigned int*)0x0E000000;
   volatile unsigned int  order = 0x80000000;
   (*ptr) = order;
}

void write_rgb_leds(const int value)
{
   volatile unsigned int* ptr = (unsigned int*)0x0D000000;
   (*ptr) = value;
}

