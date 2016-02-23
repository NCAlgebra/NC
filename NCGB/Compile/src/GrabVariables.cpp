// GrabVariables.c

#include "GrabVariables.hpp"
#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
#ifndef INCLUDED_MONOMIAL_H
#include "Monomial.hpp"
#endif
#ifndef INCLUDED_POLYNOMIAL_H
#include "Polynomial.hpp"
#endif

void GrabVariables(const Variable & t,VariableSet & v) {
  v.insert(t);
};

void GrabVariables(const Monomial & t,VariableSet & v) {
  const int sz = t.numberOfFactors();
  MonomialIterator w = t.begin();
  for(int i=1;i<=sz;++i,++w) {
    v.insert(*w);
  };
};

void GrabVariables(const Term & t,VariableSet & v) {
  GrabVariables(t.MonomialPart(),v);
};

void GrabVariables(const Polynomial & p,VariableSet & v) {
  const int sz = p.numberOfTerms();
  PolynomialIterator w = p.begin();
  for(int i=1;i<=sz&&v.size()!=Variable::s_largestStringNumber();++i,++w) {
    GrabVariables((*w).MonomialPart(),v);
  };
};

void GrabVariables(const GroebnerRule & p,VariableSet & v) {
  GrabVariables(p.LHS(),v);
  GrabVariables(p.RHS(),v);
};
