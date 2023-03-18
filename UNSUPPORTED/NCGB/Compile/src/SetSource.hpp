// (c) Mark Stankus 1999
//  SetSource.h

#ifndef INCLUDED_SETSOURCE_H
#define INCLUDED_SETSOURCE_H

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif

using namespace std;

template<class TYPE>
class SetSource {
public:
  SetSource(){};
  virtual ~SetSource() = 0;
  virtual bool getNext(TYPE & p) = 0;
  virtual SetSource * clone() const = 0;
  virtual void fillForUnknownReason() = 0;
#ifdef OLD_GCC
  bool operator==(const SetSource<TYPE> & x) const {
    return this==&x;
  };
  bool operator!=(const SetSource<TYPE> & x) const {
    return this!=&x;
  };
#endif
};
#endif
