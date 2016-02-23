// (c) Mark Stankus 1999
// ForGdb.c

#include "GroebnerRule.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"
#include "Field.hpp"

void printRule(const GroebnerRule & x) {
  GBStream << x << '\n';
};

void printPoly(const Polynomial & x) {
  GBStream << x << '\n';
};

void printTerm(const Term & x) {
  GBStream << x << '\n';
};

void printMono(const Monomial & x) {
  GBStream << x << '\n';
};

void printVar(const Variable & x) {
  GBStream << x << '\n';
};

void printNum(const Field & x) {
  GBStream << x << '\n';
};
