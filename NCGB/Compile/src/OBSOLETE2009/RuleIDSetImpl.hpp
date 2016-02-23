// Mark Stankus 1999 (c)
// RuleIDSetImpl.h

#ifndef INCLUDED_RULEIDSETIMPL_H
#define INCLUDED_RULEIDSETIMPL_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#include "vcpp.hpp"

class RuleIDSetImpl {
public:
  set<int,less<int> > d_data;
  RuleIDSetImpl() : d_data() {};
  RuleIDSetImpl(const set<int,less<int> > & data) : d_data(data) {};
  void clear() { d_data.erase(d_data.begin(),d_data.end());};
};
#endif
