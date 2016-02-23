// Mark Stankus 1999 (c)
// OrderBanner.hpp

#ifndef INCLUDED_ORDERBANNER_H
#define INCLUDED_ORDERBANNER_H

class BroadCastData;

class OrderBanner : public Recipient {
public:
  OrderBanner() {};
  virtual ~OrderBanner();
  virtual void action(const BroadCastData & x) const;
  virtual Recipient * clone() const;
};
#endif
