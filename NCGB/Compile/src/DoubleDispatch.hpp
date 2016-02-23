// Mark Stankus 1999 (c)
// DoubleDispatch.hpp

#ifndef INCLUDED_DOUBLEDISPATCH_H
#define INCLUDED_DOUBLEDISPATCH_H

#include "Holder.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#include <utility>
#else
#include <map.h>
#include <pair.h>
#endif

struct intpairless {
  bool 
  operator()
  (const std::pair<int, int>& x,const std::pair<int, int>& y) const {
    return x.first < y.first || (x.first==y.first && x.second < y.second);
  };
};

class DoubleDispatch {
  static void errorh(int);
  static void errorc(int);
  typedef std::map<std::pair<int,int>, void(*)(Holder &, Holder &), intpairless> MAP;
  MAP d_M;
public:
  bool assiged(std::pair<int,int> & x) const {
    return d_M.find(x)!=d_M.end();
  };
  void assign(std::pair<int,int> & x,void (*f)(Holder &,Holder &)) {
    MAP::iterator w = d_M.find(x);
    if(w!=d_M.end()) errorh(__LINE__);
    std::pair<const std::pair<int,int>,void (*)(Holder&,Holder &)> pr(x,f);
    d_M.insert(pr);
  };
  void execute(Holder & x,Holder & y) {
    std::pair<int,int> pr(x.ID(),y.ID());
    MAP::iterator w = d_M.find(pr);
    if(w!=d_M.end()) errorh(__LINE__);
    (*w).second(x,y);
  };
};
#endif
