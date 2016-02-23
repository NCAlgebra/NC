// Mark Stankus 1999 (c)
// LatticePool.hpp

#ifndef INCLUDED_LATTICEPOOL_H
#define INCLUDED_LATTICEPOOL_H

#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#include <set>
#else
#include <vector.h>
#include <set.h>
#endif
#include "Debug1.hpp"

class LatticePool {
  static const set<int,less<int> > s_empty;
  vector<set<int,less<int> > > d_parents;
  int d_sz;
  void makeok(int n) {
    d_parents.reserve(n);
    while(d_sz<=n) {
      d_parents.push_back(s_empty);
      ++d_sz;
    };
  };
public:
  LatticePool() : d_parents(), d_sz(0) {};
  void addParent(int child,int parent) {
    if(d_sz<=child) {
       makeok(child);
    };
    d_parents[child].insert(parent);
  };
  void removeParent(int child,int parent) {
    if(d_sz<=child) DBG();
    set<int,less<int> >::const_iterator w = d_parents[child].find(parent);
    if(w==d_parents[child].end()) DBG();
    d_parents[child].erase(w);
  };
  bool isOrphan(int child) {
    if(d_sz<=child)  DBG();
    return d_parents[child].empty();
  };
  const set<int,less<int> > & parents(int child) {
    if(d_sz<=child) {
       makeok(child);
    };
    return d_parents[child];
  };
  void setChildren(const set<int,less<int> > & x,int parent) { 
    typedef set<int,less<int> >::const_iterator SI;
    SI w = x.begin(), e = x.end();
    while(w!=e) {
      addParent(*w,parent);
      ++w;
    };
  };
};
#endif
