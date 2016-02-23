// Mark Stankus 1999 (c)
// RecordToReduction.hpp

#ifndef INCLUDED_RECORDTOREDUCTION_H
#define INCLUDED_RECORDTOREDUCTION_H

#include "BroadCast.hpp"
class Reduction;

class RecordToReduction : public Recipient {
  Reduction & d_red;
public:
  RecordToReduction(Reduction & red) : d_red(red) {};
  virtual ~RecordToReduction();
  virtual void action(const BroadCastData & x) const;
  virtual Recipient * clone() const;
};
#endif
