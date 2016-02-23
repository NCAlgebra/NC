// GrabVariables.h

#ifndef INCLUDED_GRABVARIABLES_H
#define INCLUDED_GRABVARIABLES_H
#include "VariableSet.hpp"
class Variable;
class Monomial;
class Term;
class Polynomial;
class GroebnerRule;

void GrabVariables(const Variable & t,VariableSet &);
void GrabVariables(const Monomial & t,VariableSet &);
void GrabVariables(const Term & t,VariableSet &);
void GrabVariables(const Polynomial & t,VariableSet &);
void GrabVariables(const GroebnerRule & t,VariableSet &);
#endif
