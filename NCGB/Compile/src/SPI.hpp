// (c) Mark Stankus 1999
// Licencse: Based strongly on the code of Ben Keller July 1997
// SPI.h

#ifndef INCLUDED_SPI_H
#define INCLUDED_SPI_H

#include "RuleID.hpp"
#include "Polynomial.hpp"

class SPI {
  static void errorh(int);
  static void errorc(int);
  RuleID d_left;
  RuleID d_right;
  int    d_len;
  bool   d_computed;
  void  prspolynomial(Polynomial &) const;
public:
  SPI() : d_left(), d_right(), d_len(-1), d_computed(false) {}
  SPI(RuleID L,RuleID R, int len) : d_left(L), d_right(R), d_len(len),
         d_computed(false) {}
  SPI(const SPI& s) : d_left(s.d_left), d_right(s.d_right), 
        d_len(s.d_len), d_computed(false) {};
  const SPI& operator= (const SPI& s) {
    d_left = s.d_left;
    d_right = s.d_right;
    d_len = s.d_len;
    d_computed = s.d_computed;
    return * this;
  };
  ~SPI() {};
  const RuleID & leftID() const { return d_left; }
  const RuleID & rightID() const { return d_right; }
  int overlapLength() const { return d_len; }
  bool operator==(const SPI & s) const { 
    return d_left==s.d_left && d_right==s.d_right && d_len==s.d_len;
  };
  bool operator!=(const SPI & s) const {
    return !operator==(s);
  };
  void spolynomial(Polynomial & x) const {
    if(d_computed) errorh(__LINE__);
    prspolynomial(x);
  };
};
#endif
