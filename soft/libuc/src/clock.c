#include "../libuc.h"
///
///
///
////////////////////////////////////////////////////////////
///
///
///
int get_rtc_seconds()
{
   volatile unsigned int* ptr_clock = (unsigned int*)0x0A000000;
   return ptr_clock[0];
}
///
///
///
int get_rtc_minutes()
{
   volatile unsigned int* ptr_clock = (unsigned int*)0x0A000000;
   return ptr_clock[1];
}
///
///
///
int get_rtc_hours()
{
   volatile unsigned int* ptr_clock = (unsigned int*)0x0A000000;
   return ptr_clock[2];
}
///
///
///
int get_rtc_days()
{
   volatile unsigned int* ptr_clock = (unsigned int*)0x0A000000;
   return ptr_clock[3];
}
///
///
///
int get_rtc_months()
{
   volatile unsigned int* ptr_clock = (unsigned int*)0x0A000000;
   return ptr_clock[4];
}
///
///
///
////////////////////////////////////////////////////////////
///
///
///
void set_rtc_seconds(const int value)
{
   volatile unsigned int* ptr_clock = (unsigned int*)0x0A000000;
   ptr_clock[0] = value;
}
///
///
///
void set_rtc_minutes(const int value)
{
   volatile unsigned int* ptr_clock = (unsigned int*)0x0A000000;
   ptr_clock[1] = value;
}
///
///
///
void set_rtc_hours(const int value)
{
   volatile unsigned int* ptr_clock = (unsigned int*)0x0A000000;
   ptr_clock[2] = value;
}
///
///
///
void set_rtc_days(const int value)
{
   volatile unsigned int* ptr_clock = (unsigned int*)0x0A000000;
   ptr_clock[3] = value;
}
///
///
///
void set_rtc_months(const int value)
{
   volatile unsigned int* ptr_clock = (unsigned int*)0x0A000000;
   ptr_clock[4] = value;
}
///
///
///
////////////////////////////////////////////////////////////
///
///
///