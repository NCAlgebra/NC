// AllTimings.h

#ifndef INCLUDED_ALLTIMINGS_H
#define INCLUDED_ALLTIMINGS_H

#ifndef INCLUDED_TIMING_H
#include "Timing.hpp"
#endif
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "simpleString.hpp"
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#include "vcpp.hpp"

// ALL OF THE WORK IS DONE BY THE CONTRUCTOR

class AllTimings {
  AllTimings(const AllTimings &);
    // not implemented
  void operator =(const AllTimings &);
    // not implemented
public:
  AllTimings();
  ~AllTimings() {};
  static void s_setTiming(bool fl) { 
    timingOn = fl;
    Debug1::s_setTimingFile(); 
  };
  static void s_setTiming() {
    timingOn = true;
    Debug1::s_setTimingFile(); 
  };
  static bool s_getTiming() {
    return timingOn;
  };
  static vector<pair<simpleString,long> > s_report();
  static bool timingOn;
  static int s_numberBuiltInCounter;
  static Timing * cleanUpBasisTiming;
  static Timing * matchesTiming;
  static Timing * spolynomialsTiming;
  static Timing * reductionTiming;
  static Timing * orderTiming;
  static Timing * reductionMatchingTiming;
  static Timing * reductionPolyTiming1;
  static Timing * reductionPolyTiming2;
  static Timing * reductionPolyTiming3;
  static Timing * * s_AllTimings_pp;
  static vector<Timing *> s_otherTimers;
    // The user is on his own when using s_otherTimers.
    // The following scheme is recommended (has a memory leak, though):
    //   The order of the first two lines is very important.
    //       int myTimer = AllTimings::s_otherTimers.size();
    //       AllTimings::s_otherTimers.push_back(new Timing);
    //          ... CODE ...
    //       AllTimings::s_otherTimers[myTimer]->start();
    //          ... CODE ...
    //       long n1 = AllTimings::s_otherTimers[myTimer]->check();
    //          ... CODE ...
    //       long n2 = AllTimings::s_otherTimers[myTimer]->check();
    //          ... CODE ...
    //       delete AllTimings::s_otherTimers[myTimer];
    //       AllTimings::s_otherTimers[myTimer] = (Timing *)0;
    //
    //   Do not delete a timer since then the indices get messed up.
};
#endif
