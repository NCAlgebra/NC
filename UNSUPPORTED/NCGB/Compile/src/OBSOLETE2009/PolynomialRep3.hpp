// (c) Mark Stankus 1999
// PolynomialRep3.hpp

#ifndef INCLUDED_POLYNOMIALREP3_H
#define INCLUDED_POLYNOMIALREP3_H

#include "PolynomialRep.hpp"
#ifdef USE_POLYNOMIAL_NN
#include "Polynomial.hpp"

class PolynomialRep3 : public PolynomialRep {
  virtual bool vRemoveTip();
  Polynomial d_p;
public:
  PolynomialRep3(const Copy<Term> & term, const Polynomial & p) : 
         PolynomialRep(term), d_p(p) {};
  virtual ~PolynomialRep3();
  virtual PolynomialRep * clone() const;
  virtual void print() const;
};
#endif
#endif
