// (c) Mark Stankus 1999
// RuleIDHelper.h

#ifndef INCLUDED_RULEIDHELPER_H
#define INCLUDED_RULEIDHELPER_H

#include "Polynomial.hpp"

struct RuleIDHelper {
  RuleIDHelper(const Polynomial & p,int num,bool b) : d_p(p), d_num(num), 
       d_valid(b) {};
  const Polynomial d_p;
  int d_num;
  bool d_valid;
};
#endif
