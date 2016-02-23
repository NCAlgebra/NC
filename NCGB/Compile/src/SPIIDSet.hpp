// SPIIDSet.h

#ifndef INCLUDED_SPIIDSET_H
#define INCLUDED_SPIIDSET_H

#include "SPIID.hpp"

#define SPIIDSET_USE_SET

#ifdef SPIIDSET_USE_SET
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#else
#include "GBList.hpp"
#endif
#include "vcpp.hpp"

using namespace std;

class SPIIDSet {
public:
#ifdef SPIIDSET_USE_SET
  set<SPIID,less<SPIID> > d_data;
#else
  GBList<SPIID> d_data;
#endif
#ifdef SPIIDSET_USE_SET
  const set<SPIID,less<SPIID> > & SET() const { return d_data;};
#else
  const GBList<SPIID> & SET() const { return d_data;}
#endif
  SPIIDSet() : d_data() {};
  SPIIDSet(const SPIIDSet & x) : d_data(x.d_data) {};
  ~SPIIDSet() {};
  void operator=(const SPIIDSet & x) {
    d_data = x.d_data;
  };
  bool operator==(const SPIIDSet & x) const {
    return d_data==x.d_data;
  };
  bool operator!=(const SPIIDSet & x) const {
    return d_data!=x.d_data;
  };
  void insert(const SPIID & x) { 
#ifdef SPIIDSET_USE_SET
    d_data.insert(x);
#else
    d_data.push_back(x);
#endif
  };
#ifdef SPIIDSET_USE_SET
  typedef set<SPIID,less<SPIID> > Internal;
#else
  typedef GBList<SPIID> Internal;
#endif
  void clear() {
#ifdef SPIIDSET_USE_SET
    d_data.erase(d_data.begin(),d_data.end());
#else
    d_data.clear();
#endif
  };
  void remove(const SPIID & x) {
#ifdef SPIIDSET_USE_SET
    set<SPIID,less<SPIID> >::iterator w = d_data.find(x);
    if(w!=d_data.end()) {
      d_data.erase(w);
    };
#else
    DBG();
#endif
  };
  int size() const { 
    return d_data.size();
  };
};
#endif
