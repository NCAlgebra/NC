// StdGBAlg.h

#ifndef INCLUDED_STDGBALG_H
#define INCLUDED_STDGBALG_H

#include "GBAlg.hpp"
#include "History.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif

#include "vcpp.hpp"

class HistoryCompare {
public:
  bool operator()(const History * p1,const History * p2) {
    return p1->index() < p2->index();
  };
};

class StdGBAlg : public GBAlg  {
  int d_iter;
  set<History*,HistoryCompare> d_histories;
public:
  StdGBAlg(Reduce & p1,PolySource &p2,RuleSet &p3) : 
       GBAlg(true,p1,p2,p3), d_iter(0)  {};
  virtual ~StdGBAlg();
  virtual bool perform();
};
#endif
