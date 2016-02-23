// (c) Mark Stankus 1999
// PolynomialRep5.cpp

#include "PolynomialRep5.hpp"
#ifdef USE_POLYNOMIAL_NN

PolynomialRep5::~PolynomialRep5() {};

bool PolynomialRep5::vRemoveTip() {
  bool result = false;
  if(d_p.zero()) {
    d_term = Copy<Term>();
  } else {
    result = true;
    d_term = d_p.tip();
    d_term.access().Coefficient() *= d_f;
    if(d_negate) d_term.access().Coefficient() *= -1; 
    d_p.Removetip();
  }
  return result;
};
PolynomialRep * PolynomialRep5::clone() const {
  PolynomialRep * p = new PolynomialRep5(d_term,d_f,d_p);
  if(d_negate) p->negate();
  return p;
};

void PolynomialRep5::print() const {
  printLead();
  GBStream << "PolynomialRep5 polynomial:" << d_f << ' ' << d_p << '\n';
};
#endif
