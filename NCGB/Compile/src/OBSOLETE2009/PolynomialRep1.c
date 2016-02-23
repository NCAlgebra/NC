// (c) Mark Stankus 1999
// PolynomialRep1.cpp

#include "PolynomialRep1.hpp"
#include "ChoicePolynomial.hpp"
#ifdef USE_POLYNOMIAL_NN

PolynomialRep1::~PolynomialRep1() {};

bool PolynomialRep1::vRemoveTip() {
GBStream << "Length of list at the *beginning* of vRemoveTip" 
         <<  d_L.size() << '\n';
  bool result = false;
  if(d_L.empty()) {
    d_term = Copy<Term>();
  } else {
    result = true;
    d_term = d_L.front(); 
    if(d_negate) d_term.access().Coefficient() *= -1;
    d_L.pop_front();
  }
GBStream << "Length of list at the *end* of vRemoveTip" 
         <<  d_L.size() << '\n';
  return result;
};

PolynomialRep * PolynomialRep1::clone() const {
  PolynomialRep * p = new PolynomialRep1(d_term,d_L);
  if(d_negate) p->negate();
  return p;
};

void PolynomialRep1::print() const {
  printLead();
  typedef list<Copy<Term> >::const_iterator LI;
  LI w = d_L.begin(), e = d_L.end();
  GBStream << '{';
  if(w!=e) {
    GBStream << (*w)();
    ++w;
    while(w!=e) {
      GBStream << ',' << (*w)() << '\n';
      ++w;
    };
  };
  GBStream << "}\n";
};
#endif
