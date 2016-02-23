// (c) Mark Stankus 1999
// ByAdmissible.cpp

#include "ByAdmissible.hpp"
#include "Debug1.hpp"
#include "MLex.hpp"


bool ByAdmissible::operator()(const GroebnerRule & m,
      const GroebnerRule & n) const {
  if(m.LHS()==n.LHS()) {
    if(m.RHS()!=n.RHS()) errorc(__LINE__);
    return false;
  };
  return d_order ? d_order->monomialLess(m.LHS(),n.LHS()) 
                 : AdmissibleOrder::s_getCurrent().monomialLess(
                      m.LHS(),n.LHS());
};

bool ByAdmissible::operator()(const Polynomial & m,
      const Polynomial & n) const {
  if(m.zero() || n.zero()) errorc(__LINE__);
  if(m.tipMonomial()==n.tipMonomial()) {
    if(m!=n) errorc(__LINE__);
    return false;
  };
  return d_order ? d_order->monomialLess(m.tipMonomial(),n.tipMonomial()) 
                 : AdmissibleOrder::s_getCurrent().monomialLess(
                      m.tipMonomial(),n.tipMonomial());
};

void ByAdmissible::errorh(int n) {
  DBGH(n);
};

void ByAdmissible::errorc(int n) {
  DBGC(n);
};
