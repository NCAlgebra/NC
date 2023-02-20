// Mark Stankus (c) 1999
// tdPool.hpp

#ifndef INCLUDED_TDPOOL_H
#define INCLUDED_TDPOOL_H

#include "Names.hpp"

template<class T>
class tdPool : public Names {
  static const char * s_poolname;
  T * d_p;
public:
  tdPool() : d_p((T *)0) {};
  tdPool(T * p) : d_p(p) {};
  virtual ~tdPool();
  virtual const char * poolname() const;
  virtual Names * prototype() const;
  virtual Names * create(Source &) const;
  virtual PoolVoid getPointer();
};
#endif
