// (c) Mark Stankus 1999
// PolynomialRep4.cpp

#include "PolynomialRep4.hpp"
#ifdef USE_POLYNOMIAL_NN

PolynomialRep4::~PolynomialRep4() {};

bool PolynomialRep4::vRemoveTip() {
  bool result = false;
  if(d_p.zero()) {
    d_term = Copy<Term>();
  } else {
    result = true;
    d_term.access().assign(d_L);
    d_term.access() *= d_p.tip();
    d_term.access().MonomialPart() *= d_R;
    if(d_negate) d_term.access().Coefficient() *= -1; 
    d_p.Removetip();
  }
  return result;
};

PolynomialRep * PolynomialRep4::clone() const {
  PolynomialRep * p = new PolynomialRep4(d_term,d_L,d_p,d_R);
  if(d_negate) p->negate();
  return p;
};

void PolynomialRep4::print() const {
  printLead();
  GBStream << "PolynomialRep2 polynomial:" << d_L << ' ' 
           << d_p << ' ' << d_R << '\n';
};
#endif
