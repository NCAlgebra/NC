// (c) Mark Stankus 1999
// NormalFormKeeper.h

#ifndef INCLUDED_NORMALFORMKEEPER_H
#define INCLUDED_NORMALFORMKEEPER_H

#include "Polynomial.hpp"
#include "Monomial.hpp"

class NormalFormKeeper {
  static void errorh(int);
  static void errorc(int);
  const Polynomial d_original;
  Polynomial d_current;
public:
  NormalFormKeeper(const Polynomial & x) : d_original(x), d_current(x) {};
  ~NormalFormKeeper() {};
  const Polynomial & original() const { return d_original;};
  const Polynomial & poly() const { return d_current;};
  Polynomial & poly() { return d_current;};
  bool zero() const { return d_current.zero();};
  bool contradiction() const { 
    return !d_current.zero() && d_current.tipMonomial().numberOfTerms()==1;
  };
};
#endif
