// (c) Mark Stankus 1999
// PolynomialRep2.hpp

#ifndef INCLUDED_POLYNOMIALREP2_H
#define INCLUDED_POLYNOMIALREP2_H

#include "PolynomialRep.hpp"
#ifdef USE_POLYNOMIAL_NN
#include "Term.hpp"
#include "Polynomial.hpp"

class PolynomialRep2 : public PolynomialRep {
  virtual bool vRemoveTip();
  Field d_f;
  Monomial d_L;
  Polynomial d_p;
  Monomial d_R;
public:
  PolynomialRep2(const Copy<Term> & term, const Field & f,
      const Monomial & L, const Polynomial & p,const Monomial & R) 
       : PolynomialRep(term), d_f(f), d_L(L), d_p(p), d_R(R) {};
  virtual ~PolynomialRep2();
  virtual PolynomialRep * clone() const;
  virtual void print() const;
};
#endif
#endif
