// (c) Mark Stankus 1999
// RuleID.c

#include "RuleID.hpp"
#include "Term.hpp"
#include "Polynomial.hpp"
#include "MyOstream.hpp"

MyOstream & operator <<(MyOstream & os,const RuleID & x) {
  if(!x.valid()) RuleID::errorc(__LINE__);
  Polynomial p = x.poly();
  if(p.zero()) {
    os << "[rule from a zero polynomial]";
  } else {
    os << p.tip();
    p.removetip();
    os << "->";
    p.printNegative(os);
  };
  return os;
};

#if 0
#include "Choice.hpp"
#ifdef USE_UNIX
#include "Copy.c"
#else
#include "Copy.cpp"
#endif

template class Copy<RuleIDHelper>;
#endif

void RuleID::errorh(int n) { DBGH(n); };

void RuleID::errorc(int n) { DBGC(n); };
