// (c) Mark Stankus 1999
// PolynomialRep3.cpp

#include "PolynomialRep3.hpp"
#ifdef USE_POLYNOMIAL_NN

PolynomialRep3::~PolynomialRep3() {};

bool PolynomialRep3::vRemoveTip() {
  bool result = false;
  if(d_p.zero()) {
    d_term = Copy<Term>();
  } else {
    result = true;
    d_term = d_p.tip(); 
    if(d_negate)  d_term.access().Coefficient() *= -1;
    d_p.Removetip();
  }
  return result;
};

PolynomialRep * PolynomialRep3::clone() const {
  PolynomialRep * p = new PolynomialRep3(d_term,d_p);
  if(d_negate) p->negate();
  return p;
};

void PolynomialRep3::print() const {
  printLead();
  GBStream << "PolynomialRep3 polynomial:" << d_p << '\n';
};
#endif
