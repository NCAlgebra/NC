// Mark Stankus 1999 (c)
// Recipient.hpp

#ifndef INCLUDED_RECIPIENT_H
#define INCLUDED_RECIPIENT_H

class BroadCastData;
#include "Choice1.hpp"

class Recipient {
public:
  Recipient() {};
  virtual ~Recipient() = 0;
  virtual void action(const BroadCastData & x) const = 0;
  virtual Recipient * clone() const = 0;
#ifdef OLD_GCC
  bool operator==(const Recipient & x) const {
    return this==&x;
  };
  bool operator!=(const Recipient & x) const {
    return this!=&x;
  };
#endif
};
#endif
