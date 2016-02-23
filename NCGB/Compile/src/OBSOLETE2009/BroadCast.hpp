// Mark Stankus 1999 (c)
// BroadCast.hpp

#ifndef INCLUDED_BROADCAST_H
#define INCLUDED_BROADCAST_H

#include "Recipient.hpp"
#include "BroadCastData.hpp"
#include "ICopy.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

class BroadCast {
public:
  BroadCast(){};
  ~BroadCast(){};
  list<ICopy<Recipient > > d_L;
  void broadcast(const BroadCastData & x) const {
    typedef list<ICopy<Recipient> >::const_iterator LI;
    LI w = d_L.begin(), e = d_L.end();
    while(w!=e) {
      (*w)().action(x);
      ++w;
    };
  };
};
#endif
