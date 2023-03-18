// (c) Mark Stankus 1999
// FullReduceFor.c

#include "FullReduceFor.hpp"
#include "Polynomial.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <algorithm>
#else
#include <algo.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <iterator>
#else
#include <iterator.h>
#endif

#include "vcpp.hpp"

FullReduceFor::~FullReduceFor() {};

History * FullReduceFor::history() const {
  return  d_x.history();
};

void FullReduceFor::insert(const RuleID & x) {
  d_x.insert(x);
};

void FullReduceFor::remove(const RuleID & x) {
  d_x.remove(x);
};

bool FullReduceFor::reduce(Polynomial & x) const {
  bool flag = false;
  Polynomial temp(x);
  list<Term> L;
  while(d_x.reduce(temp)) { flag = true;};
  while(!temp.zero()) {
    L.push_back(temp.tip());
    temp.removetip();
    while(d_x.reduce(temp)) { flag = true;};
  };
  if(flag) x.setWithList(L);
  return flag;
};

void FullReduceFor::print(MyOstream & os) const {
  d_x.print(os);
};
