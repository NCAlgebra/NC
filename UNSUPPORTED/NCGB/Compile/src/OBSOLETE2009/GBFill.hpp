// GBFill.h

#ifndef INCLUDED_GBFILL_H
#define INCLUDED_GBFILL_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifndef INCLUDED_VECTOR_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#endif

#include "vcpp.hpp"

template<class T>
inline void GBFill(vector<T> & C,int sz, const T & value) {
  C.erase(C.begin(),C.end());
  C.reserve(sz);
  for(int i=1;i<=sz;++i) C.push_back(value);
};
#endif
