// Mark Stankus (c)
// MyTimers.h

#ifndef INCLUDED_MYTIMERS_H
#define INCLUDED_MYTIMERS_H

#ifndef INCLUDED_TIMING_H
#include "Timing.hpp"
#endif
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "simpleString.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#include <utility>
#include <map>
#else
#include <vector.h>
#include <map.h>
#include <pair.h>
#endif
#include "vcpp.hpp"

class MyTimers {
  MyTimers(const MyTimers &);
    // not implemented
  void operator =(const MyTimers &);
    // not implemented
  typedef map<simpleString,Timing *,less<simpleString> > MAP;
  static map<simpleString,Timing *,less<simpleString> > s_map;
public:
  MyTimers() {};
  ~MyTimers() {};
  static Timing * get_timer(const simpleString & s) {
    Timing * result = 0;
    MAP::iterator f =  s_map.find(s);
    if(f==s_map.end()) {
      result = new Timing; 
      pair<const simpleString,Timing *> pr(s,result);
      s_map.insert(pr);
    } else {
      result = (*f).second;
    };
    return result;
  };
  static const MAP & themap() {
    return s_map;
  };
};
#endif
