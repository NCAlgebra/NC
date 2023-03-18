// Mark Stankus 1999 (c)
// Recipient.hpp

#ifndef INCLUDED_RECIPIENT_H
#define INCLUDED_RECIPIENT_H

class BroadCastData;

class Recipient {
public:
  Recipient() {};
  virtual ~Recipient() = 0;
  virtual void action(const BroadCastData & x) const = 0;
  virtual Recipient * clone() const = 0;
};
#endif
