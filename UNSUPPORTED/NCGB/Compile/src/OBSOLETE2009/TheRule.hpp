// Mark Stankus 1999 (c)
// TheRule.nwh

#ifndef INCLUDED_THERULE_H
#define INCLUDED_THERULE_H

#include "Monomial.hpp"
#include "Polynomial.hpp"
#include "PrintStyle.hpp"
#include "GBStream.hpp"

class SFSGNode;
  
struct TheRule {
private:
  static int s_number;
public:
  PrintStyle d_style;
  const int d_number;
  TheRule(const Monomial &);
  TheRule(const TheRule & x);
  const Monomial d_m;
  typedef list<Polynomial>  LIST;
private:
  LIST  d_rest;
public:
  bool d_recent;
  void addRest(const Polynomial & p) {
    GBStream << "ADDING " << p << " for " << d_m << '\n';
    d_rest.push_back(p);
  };
  const LIST & rests() const {
    return d_rest;
  };
  LIST & rests() {
    return d_rest;
  };
  void print(MyOstream & os,PrintStyle s) const;
  inline void print(MyOstream & os) const { print(os,d_style);};
};
#endif
