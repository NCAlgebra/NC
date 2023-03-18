// Mark Stankus (c) 1999
// TriColor.hpp

#ifndef INCLUDED_TRICOLOR_H
#define INCLUDED_TRICOLOR_H

#include "Choice.hpp"
#ifdef INCLUDE_HAS_NO_DOTS
#include <iostream>
#else
#include <iostream.h>
#endif

class TriColor {
  int d_color;
  TriColor(int n) : d_color(n) {};
public:
  TriColor() : d_color(0) {};
  TriColor(const TriColor & x) : d_color(x.d_color) {};
  ~TriColor(){};
  bool possibleColor(int n) const {
    return n==s_zero.d_color || n==s_one.d_color || n==s_two.d_color;
  };
  void operator=(const TriColor & x) { d_color=x.d_color;}
  bool operator==(const TriColor & x) const { return d_color==x.d_color;}
  bool operator!=(const TriColor & x) const { return d_color!=x.d_color;}
  friend ostream & operator <<(ostream & os,const TriColor & x) {
    os << "color#:" << x.d_color << '\n';
    return os;
  };
  int color() const { return d_color;};
  static TriColor s_zero;
  static TriColor s_one;
  static TriColor s_two;
};
#endif
