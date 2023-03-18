// Timing.c

#include "Timing.hpp"

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Instructions

NOTE:  This file is not to be used with Timing.h or Timing.inline.h - it is the
C implementation of timing commands.

To time a section of code, first allocate a long, assigning it to the return
value of TimingStart().

long ts = TimingStart();

From then on, the elapsed time can be computed by passing this returned value
to TimingCheck:

long elapsedTime = TimingCheck(ts);

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

double TimingStart() {
#ifdef USE_UNIX
  timeval tp;
  struct timezone tzp;
  gettimeofday(&tp, &tzp);
  return tp.tv_sec + tp.tv_usec / Timing::s_DividingFactor;
#else
  return  0.0;
#endif
};

#ifdef USE_UNIX
double TimingCheck(double t) {
  timeval tp;
  struct timezone tzp;
  gettimeofday(&tp, &tzp);
  return((tp.tv_sec + tp.tv_usec / Timing::s_DividingFactor) - t);
};
#else
double TimingCheck(double) {
  return 0.0;
};
#endif

//const int Timing::s_DividingFactor = 1000000;   
//const int Timing::s_DividingFactor = 1;   
const int Timing::s_DividingFactor = 1000;   
