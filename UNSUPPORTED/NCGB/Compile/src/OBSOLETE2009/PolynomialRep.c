// (c) Mark Stankus 1999
// PolynomialRep.c

#include "PolynomialRep.hpp"
#ifdef USE_POLYNOMIAL_NN
#include "Debug1.hpp"
#include "MyOstream.hpp"

PolynomialRep::PolynomialRep(const Copy<Term> & x) : d_term(x), 
       d_negate(false) {};

PolynomialRep::PolynomialRep(const Term & x) : d_term(x), 
       d_negate(false) {};

PolynomialRep::~PolynomialRep() {};

const Term & PolynomialRep::term() const {
  return d_term();
};

const Copy<Term> & PolynomialRep::copyterm() const {
  return d_term;
};

bool PolynomialRep::addCoefficient(const Field & f) {
    Field & g = d_term.access().Coefficient();
    g += f;
    return !g.zero();
};

bool PolynomialRep::valid() const {
  return d_term.isValid();
};

bool PolynomialRep::removeTip() {
  bool result = false;
  if(d_term.isValid()) {
    result = vRemoveTip();
  } else DBG();
  return result;
};

void PolynomialRep::negate() { 
  d_negate = !d_negate;
  if(d_term.isValid()) {
     d_term.access().Coefficient() *= -1;
  };
};

MyOstream & operator<<(MyOstream & os,const PolynomialRep & x) {
  if(x.valid()) {
     os << "valid " << x.term();
  } else {
     os << "invalid!!! ";
  };
  return os;
};

void PolynomialRep::printLead() const {
  if(d_term.isValid()) {
    GBStream << "term:" << d_term() << '\n';
    if (d_negate) GBStream << "with negation\n";
  } else {
    GBStream << "term invalid";
  };
};
#include "Choice.hpp"
#ifdef USE_UNIX
#include "PolynomialRep1.c"
#include "PolynomialRep2.c"
#include "PolynomialRep3.c"
#include "PolynomialRep4.c"
#include "PolynomialRep5.c"
#else
#include "PolynomialRep1.cpp"
#include "PolynomialRep2.cpp"
#include "PolynomialRep3.cpp"
#include "PolynomialRep4.cpp"
#include "PolynomialRep5.cpp"
#endif
#endif
