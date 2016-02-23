// adjoint.h

#ifndef INCLUDED_ADJOINT_H
#define INCLUDED_ADJOINT_H

#include "Polynomial.hpp"
class GroebnerRule;

Variable adjoint(const Variable & v,const char * s);
Monomial adjoint(const Monomial & v,const char * s);

inline Term adjoint(const Term & v,const char * s) {
  return Term(v.CoefficientPart(),adjoint(v.MonomialPart(),s));
};

Polynomial adjoint(const Polynomial & v,const char * s);
Polynomial adjoint(const GroebnerRule & v,const char * s);
#endif
