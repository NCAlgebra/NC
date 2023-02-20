// Mark Stankus 1999 (c)
// RecordToPolySource.hpp

#ifndef INCLUDED_RECORDTOPOLYSOURCE_H
#define INCLUDED_RECORDTOPOLYSOURCE_H

#include "BroadCast.hpp"
class PolySource;

class RecordToPolySource : public Recipient {
  PolySource & d_ps;
public:
  RecordToPolySource(PolySource & ps) : d_ps(ps) {};
  virtual ~RecordToPolySource();
  virtual void action(const BroadCastData & x) const;
  virtual Recipient * clone() const;
};
#endif
