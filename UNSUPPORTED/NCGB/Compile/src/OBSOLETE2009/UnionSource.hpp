// Mark Stankus 1999 (c)
// UnionSource.hpp

#ifndef INCLUDED_UNIONSOURCE_H
#define INCLUDED_UNIONSOURCE_H

#include "SetSource.hpp"
#include "ICopy.hpp"
#include <list>

template<class T>
class UnionSource : public SetSource<T> {
  list<ICopy<SetSource<T> > > d_L;
public:
  UnionSource(const list<ICopy<SetSource<T> > > & L) : d_L(L) {};
  virtual ~UnionSource();
  virtual bool getNext(T &);
  virtual SetSource<T> * clone() const;
  virtual void fillForUnknownReason();
};
#endif
