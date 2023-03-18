// Mark Stankus 1999 (c)
// AlgExpr.hpp

#include "AlgExpr.hpp"


AlgExpr::~AlgExpr() {};

AlgExpr * AlgExpr::clone() const {
  return new AlgExpr;
};

void AlgExpr::tryToFillList() const {};
