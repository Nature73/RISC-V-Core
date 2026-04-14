#ifndef H__FEMTOSTDLIB__H
#define H__FEMTOSTDLIB__H

//#include <femtorv32.h>
//#include <stdint.h>
#include <stddef.h>

#define   int8_t          char
#define  uint8_t unsigned char
#define  int16_t          short
#define uint16_t unsigned short
#define  int32_t          int
#define uint32_t unsigned int

/* My light weight replacement function for printf() */
extern int printf(const char *fmt,...); /* supports %s, %d, %x */

extern void*      memset (void *s, int c, size_t n);
extern void*      memcpy (void *dest, const void *src, size_t n);
extern char*      strcpy (char *dest, const char *src);
extern char*      strncpy(char *dest, const char *src, size_t n);
extern int        strcmp (const char *p1, const char *p2);
extern size_t     strlen (const char* p);
extern long       random();

extern long rand();
extern long random();

/* Specialized print functions (but one can use printf() instead) */
extern int  putchar(const int c);
extern void print_string(const char* s);
extern void print_dec(int val);
extern void print_hex_digits(unsigned int val, int digits);
extern void print_hex(unsigned int val);


/*                       */
/*                       */
/* OLED screen control   */
/*                       */
/*                       */

extern int  pixel           (const int r, const int g, const int b);
extern int  set_12b_from_16b(const int color);
extern void set_pixel       (const int offset, const int color);
extern void clear_screen    ();


/*                       */
/*                       */
/* RGB led color control */
/*                       */
/*                       */

extern void led_rgb_set_red  ();
extern void led_rgb_set_green();
extern void led_rgb_set_blue ();
extern void led_rgb_set_color(const int color);
extern int  led_rgb_get_color();


/*                        */
/*                        */
/* External timer control */
/*                        */
/*                        */

extern int  get_cycles       ();
extern int  time             ();
extern void sleep_cycles     (const int cycles);
extern void sleep_us         (const int cycles);
extern void sleep_ms         (const int cycles);
extern void sleep            (const int cycles);
extern void start_timer      (const int cycles);
extern int  is_timer_finished();

/*                           */
/*                           */
/* External UART read access */
/*                           */
/*                           */

extern int get_soc_id       ();
extern void printf_platform (const int value);
extern int get_soc_frequency();
extern int get_soc_leds     ();
extern int get_soc_buttons  ();
extern int get_soc_switches ();
extern int get_soc_oleds    ();
extern int get_soc_7segs    ();
extern int get_soc_pipeline ();

/*                           */
/*                           */
/* External UART read access */
/*                           */
/*                           */

extern int read_buttons     ();
extern int read_switchs     ();
extern int read_leds        ();

extern void write_leds      (const int value);
extern void write_rgb_leds  (const int value);
extern void write_ring_leds (const int position, const int value);
extern void start_ring_leds ();

//
//
//
//

extern int get_rtc_seconds();
extern int get_rtc_minutes();
extern int get_rtc_hours  ();
extern int get_rtc_days   ();
extern int get_rtc_months ();

extern void set_rtc_seconds(const int value);
extern void set_rtc_minutes(const int value);
extern void set_rtc_hours  (const int value);
extern void set_rtc_days   (const int value);
extern void set_rtc_months (const int value);

#endif
