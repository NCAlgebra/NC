// Mark Stankus 1999 (c)
// OrderTeXBanner.hpp

#ifndef INCLUDED_ORDERTEXBANNER_H
#define INCLUDED_ORDERTEXBANNER_H

class BroadCastData;

class OrderTeXBanner : public Recipient {
public:
  OrderTeXBanner() {};
  virtual ~OrderTeXBanner();
  virtual void action(const BroadCastData & x) const;
  virtual Recipient * clone() const;
};
#endif
