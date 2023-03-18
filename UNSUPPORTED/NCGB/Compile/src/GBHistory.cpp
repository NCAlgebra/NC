// GBHistory.c

#include "GBHistory.hpp"
#include "load_flags.hpp"
#pragma warning(disable:4786)
#ifdef PDLOAD
#ifndef INCLUDED_STDLIB_H
#define INCLUDED_STDLIB_H
#include <stdlib.h>
#endif
#include "MyOstream.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#include "SPIID.hpp"
#include "SPIIDSet.hpp"

GBHistory::GBHistory() : _first(-999), _second(-999), _reductions() {}; 

void GBHistory::assign(const SPIID & a,const SPIID & b,
          const HistoryContainerType & aList) {
  _first = a.d_data;
  _second = b.d_data;
  _reductions = aList;
};

// Ugly print function for the history
MyOstream & operator << (MyOstream & os,const GBHistory & aHistory) {
  os << "First number: " << aHistory.first() << '\n';
  os << "Second number: " << aHistory.second() << '\n';
  os << "Reduction numbers: \n";
  const set<SPIID,less<SPIID> > & S = aHistory.reductions().SET();
  set<SPIID,less<SPIID> >::const_iterator w = S.begin();
  const int len = S.size();
  for(int i=1;i<=len;++i,++w) {
    os << (*w).d_data << ' ';
  }
  os << '\n';
  return os;
};
#endif
