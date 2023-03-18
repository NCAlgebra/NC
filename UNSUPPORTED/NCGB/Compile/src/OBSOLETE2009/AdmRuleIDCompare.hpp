// (c) Mark Stankus 1999
// AdmRuleIDCompare.h

#ifndef INCLUDED_ADMRULEIDCOMPARE_H
#define INCLUDED_ADMRULEIDCOMPARE_H

#include "AdmissibleOrder.hpp"
#include "Polynomial.hpp"
#include "RuleID.hpp"
#include "Choice.hpp"

class AdmRuleIDCompare {
  const AdmissibleOrder &  d_ord;
  static void errorh(int);
  static void errorc(int);
public:
#ifdef OLD_GCC
  AdmRuleIDCompare() : d_ord( * (const AdmissibleOrder *)0) {};
  void operator=(const AdmRuleIDCompare & x) { errorh(__LINE__);};
#endif
  AdmRuleIDCompare(const AdmissibleOrder &  ord) : 
        d_ord(ord) {};
  bool operator()(const RuleID & x,const RuleID & y) const {
    return d_ord.monomialLess(x.poly().tipMonomial(),y.poly().tipMonomial());
  };
};
#endif
