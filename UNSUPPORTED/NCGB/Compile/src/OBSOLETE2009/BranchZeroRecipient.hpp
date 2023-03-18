// Mark Stankus 1999 (c)
// BranchZeroRecipient.hpp

#ifndef INCLUDED_BRANCHZERORECIPIENT_H
#define INCLUDED_BRANCHZERORECIPIENT_H

#include "Recipient.hpp"
#include "NormalFormKeeper.hpp"
#include "Alias.hpp"

class BranchZeroRecipient : public Recipient {
  Alias<NormalFormKeeper> d_normalformkeeper;
public:
  BranchZeroRecipient() {};
  virtual ~BranchZeroRecipient();
  virtual void action(const BroadCastData & x) const;
  virtual Recipient * clone() const;
};
#endif
