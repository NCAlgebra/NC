// Mark Stankus (c) 1999
// tPool.hpp

#ifndef INCLUDED_TPOOL_H
#define INCLUDED_TPOOL_H

#include "Names.hpp"

template<class T>
class tPool : public Names {
  static const char * s_poolname;
  T * d_p;
public:
  tPool() : d_p((T *)0) {};
  tPool(T * p) : d_p(p) {};
  virtual ~tPool();
  virtual const char * poolname() const;
  virtual Names * prototype() const;
  virtual Names * create(Source &) const;
  virtual PoolVoid getPointer();
};
#endif
