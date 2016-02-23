// (c) Mark Stankus 1999
// PolynomialRep5.hpp

#ifndef INCLUDED_POLYNOMIALREP5_H
#define INCLUDED_POLYNOMIALREP5_H

#include "PolynomialRep.hpp"
#ifdef USE_POLYNOMIAL_NN
#include "Field.hpp"
#include "Polynomial.hpp"

class PolynomialRep5 : public PolynomialRep {
  virtual bool vRemoveTip();
  Field d_f;
  Polynomial d_p;
public:
  PolynomialRep5(const Copy<Term> & term,
      const Field & f, const Polynomial & p) : PolynomialRep(term), 
         d_f(f), d_p(p) {};
  virtual ~PolynomialRep5();
  virtual PolynomialRep * clone() const;
  virtual void print() const;
};
#endif
#endif
