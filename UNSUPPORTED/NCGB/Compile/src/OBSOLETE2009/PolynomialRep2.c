// (c) Mark Stankus 1999
// PolynomialRep2.cpp

#include "PolynomialRep2.hpp"
#ifdef USE_POLYNOMIAL_NN

PolynomialRep2::~PolynomialRep2() {};

bool PolynomialRep2::vRemoveTip() {
  bool result = false;
  if(d_p.zero()) {
    d_term = Copy<Term>();
  } else {
    result = true;
    d_term.access().assign(d_f,d_L);
    d_term.access() *= d_p.tip();
    d_term.access().MonomialPart() *= d_R;
    if(d_negate) d_term.access().Coefficient() *= -1; 
    d_p.Removetip();
  }
  return result;
};

PolynomialRep * PolynomialRep2::clone() const {
  PolynomialRep * p = new PolynomialRep2(d_term,d_f,d_L,d_p,d_R);
  if(d_negate) p->negate();
  return p;
};

void PolynomialRep2::print() const {
  printLead();
  GBStream << "PolynomialRep2 polynomial:" << d_p << '\n';
};
#endif
