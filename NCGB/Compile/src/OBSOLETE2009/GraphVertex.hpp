// Mark Stankus 1999 (c)
// GraphVertex.h

#ifndef INCLUDED_GRAPHVERTEX_H
#define INCLUDED_GRAPHVERTEX_H

#include "Choice.hpp"
#ifndef HAS_INCLUDE_NO_DOTS
#include <string>
#else
#include <string>
#endif

struct GraphVertex { 
  static void errorh(int);
  static void errorc(int);
#ifdef OLD_GCC
  GraphVertex() { errorh(__LINE__);};
#endif
  GraphVertex(const string & s) : d_s(s) {};
  GraphVertex(const GraphVertex& x) : d_s(x.d_s) {};
  void operator=(const GraphVertex & x) { d_s = x.d_s;};
  bool operator <(const GraphVertex & x) const { return d_s.compare(x.d_s)<0;};
  bool operator==(const GraphVertex & x) const { return d_s==x.d_s;}
  bool operator!=(const GraphVertex & x) const { return d_s!=x.d_s;}
  string d_s;
};
#endif
