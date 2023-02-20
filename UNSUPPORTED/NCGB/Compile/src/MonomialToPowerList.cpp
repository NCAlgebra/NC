// (c) Mark Stankus 1999
// MonomialToPowerList.cpp

#include "MonomialToPowerList.hpp"
#include "Monomial.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

void MonomialMakePowerLess(const Monomial & x,Monomial & result) {
  Variable last;
  result.setToOne();
  int sz = x.numberOfFactors();
  MonomialIterator w = x.begin();
  while(sz) {
    const Variable & v = *w;
    if(v!=last) {
      result *= v;
      last = v;
    };
    --sz;++w;
  };
};

void MonomialToPowerList(const Monomial & x,list<pair<Variable,int> > & L) {
  pair<Variable,int> result;
  result.first.assign("DONT_USE_THIS_VARIABLE");
  result.second=0;
  MonomialIterator w = x.begin();
  int n = x.numberOfFactors();
  while(n) {
    const Variable & var = *w;
    if(result.first== var) {
      ++result.second;
    } else {
      if(result.second!=0) {
        L.push_back(result);
      };
      result.first = var;
      result.second = 1;
    };
    --n;++w;
  };
  if(result.second!=0) {
    L.push_back(result);
  };
};
