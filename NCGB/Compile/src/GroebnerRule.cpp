// GroebnerRule.c

#include "GroebnerRule.hpp"
#include "OuMonomial.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"

MyOstream & operator <<(MyOstream & os,const GroebnerRule & x) {
  OuMonomial::NicePrint(os,x.LHS());
  os << " -> ";
  os << x.RHS();
  return os;
};

void GroebnerRule::convertAssign(const Polynomial & p) {
  if(p.zero()) {
    GBStream << "Warning: Converting the polynomial zero to a "
             << "groebner rule.\n";
    GBStream << "Result should be discarded.\n";
  } else {
    const Term & t = p.tip();
      // Do monomial
    _monomial = t.MonomialPart();
      // Do polynomial
    _polynomial = p;
    _polynomial.Removetip();
    Field temp(-1);
    temp /= t.CoefficientPart();
    _polynomial *= temp;
  };
};

#include "StartEnd.hpp"
struct DoGroebnerRule : AnAction {
  DoGroebnerRule() : AnAction("DoGroebnerRule") {};
  void action() {
    GroebnerRule::s_term_p = new Term; 
  };
};

AddingStart temp1GroebnerRule(new DoGroebnerRule);
  

INTEGER  GroebnerRule::s_NegOne(-1L);
Term  *   GroebnerRule::s_term_p = 0;
