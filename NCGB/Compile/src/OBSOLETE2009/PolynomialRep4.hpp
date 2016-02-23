// (c) Mark Stankus 1999
// PolynomialRep4.hpp

#ifndef INCLUDED_POLYNOMIALREP4_H
#define INCLUDED_POLYNOMIALREP4_H

#include "PolynomialRep.hpp"
#ifdef USE_POLYNOMIAL_NN
#include "Polynomial.hpp"

class PolynomialRep4 : public PolynomialRep {
  virtual bool vRemoveTip();
  Monomial d_L;
  Polynomial d_p;
  Monomial d_R;
public:
  PolynomialRep4(const Copy<Term> & term,
      const Monomial & L, const Polynomial & p,const Monomial & R) 
       : PolynomialRep(term), d_L(L), d_p(p), d_R(R) {};
  virtual ~PolynomialRep4();
  virtual PolynomialRep * clone() const;
  virtual void print() const;
};
#endif
#endif
