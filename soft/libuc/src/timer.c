#include "../libuc.h"

/*                        */
/*                        */
/* External timer control */
/*                        */
/*                        */

extern int get_cycles()
{
   volatile unsigned int* ptr_timer = (unsigned int*)0x0C000000;
   return (*ptr_timer);
}

int time()
{
   return get_cycles();
}

void sleep_cycles(const int cycles)
{
   volatile unsigned int* ptr_timer = (unsigned int*)0x0C000000;
   ptr_timer[1] = cycles;
   while( ptr_timer[1] != 0 );
}

void sleep_us(const int delay)
{
   const int freq     = get_soc_frequency() / 1000000;
   const int cycles = freq * delay;
   sleep_cycles( cycles );
}

void sleep_ms(const int delay)
{
   const int freq     = get_soc_frequency() / 1000;
   const int cycles = freq * delay;
   sleep_cycles( cycles );
}

void sleep(const int delay)
{
   const int freq     = get_soc_frequency();
   const int cycles = freq * delay;
   sleep_cycles( cycles );
}

void start_timer(const int cycles)
{
   volatile unsigned int* ptr_timer = (unsigned int*)0x0C000000;
   ptr_timer[1] = cycles;
}

int is_timer_finished()
{
   volatile unsigned int* ptr_timer = (unsigned int*)0x0C000000;
   return (ptr_timer[1] == 0);
}
