// (c) Mark Stankus 1999
// PolynomialRep1.hpp

#ifndef INCLUDED_POLYNOMIALREP1_H
#define INCLUDED_POLYNOMIALREP1_H

#include "PolynomialRep.hpp"
#ifdef USE_POLYNOMIAL_NN

class PolynomialRep1 : public PolynomialRep {
  virtual bool vRemoveTip();
  list<Copy<Term> > d_L;
public:
  PolynomialRep1(const list<Copy<Term> > & L) : 
        PolynomialRep(L.front()), d_L(L) {
    d_L.pop_front();
  };
  PolynomialRep1(const Copy<Term> & term,const list<Copy<Term> > & L) : 
        PolynomialRep(term), d_L(L) {};
  virtual ~PolynomialRep1();
  virtual PolynomialRep * clone() const;
  virtual void print() const;
};
#endif
#endif
