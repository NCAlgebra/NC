// Mark Stankus 1999 (c)
// CategoryBanner.hpp

#ifndef INCLUDED_CATEGORYBANNER_H
#define INCLUDED_CATEGORYBANNER_H

class BroadCastData;
#include "Recipient.hpp"

class CategoryBanner : public Recipient {
public:
  CategoryBanner() {};
  virtual ~CategoryBanner();
  virtual void action(const BroadCastData & x) const;
  virtual Recipient * clone() const;
};
#endif
