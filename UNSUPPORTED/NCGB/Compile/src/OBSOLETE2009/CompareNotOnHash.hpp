// CompareNotOnHash.h

#ifndef INCLUDED_COMPARENOTONHASH_H
#define INCLUDED_COMPARENOTONHASH_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <string>
#else
#include <string.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif

class  CompareNotOnHash {
public:
  bool operator()(const pair<char *,int> & x,const pair<char *,int> & y) const {
    return x.second!=y.second ?  (x.second<y.second) : 
                                  strcmp(x.first,y.first)<0;
  };
};
#endif
