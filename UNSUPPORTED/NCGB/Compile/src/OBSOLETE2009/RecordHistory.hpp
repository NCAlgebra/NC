// Mark Stankus 1999 (c)
// RecordHistory.hpp

#ifndef INCLUDED_RECORDHISTORY_H
#define INCLUDED_RECORDHISTORY_H

#include "BroadCast.hpp"
#include "GBHistory.hpp"
#include <list>

class RecordHistory : public Recipient {
  static void errorh(int);
  static void errorc(int);
  list<GBHistory> & d_L;
public:
  RecordHistory(list<GBHistory> & L) : d_L(L) {};
  virtual ~RecordHistory();
  virtual void action(const BroadCastData & x) const;
  virtual Recipient * clone() const;
};
#endif
