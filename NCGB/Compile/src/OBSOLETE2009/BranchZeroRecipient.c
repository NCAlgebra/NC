// Mark Stankus 1999 (c)
// BranchZeroRecipient.c

#include "BranchZeroRecipient.hpp"

BranchZeroRecipient()::~BranchZeroRecipient() {};

void BranchZeroRecipeint::action(const BroadCastData & x) const {
  d_normalformkeeper.access()..makeZero();
};
Recipient * BranchZeroRecipient::clone() const {
  return new BranchZeroRecipient(d_normalformkeeper);
};
