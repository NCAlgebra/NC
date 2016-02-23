// Mark Stankus 1999 (c)
// PrintReduction.nwh

#ifndef INCLUDED_PRINTREDUCTION_H
#define INCLUDED_PRINTREDUCTION_H

#include <set>
#include "Polynomial.hpp"
#include "ByAdmissible.hpp"
#include "MyOstream.hpp"

class PrintPolys {
  set<Monomial,ByAdmissible> d_S;
public:
  PrintPolys(){};
  void addPolynomial(const Polynomial & x);
  void print(MyOstream & os,const Polynomial & x) const;
  void printTable(MyOstream & os,list<Polynomial> &x);
  void clear() { d_S.clear();};
};
#endif
