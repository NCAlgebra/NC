// TeXOutputVisitor.c

#include "TeXOutputVisitor.hpp"
#ifdef USE_VIRT_FIELD
#include "MyInteger.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"

TeXOutputVisitor::~TeXOutputVisitor() {};

void TeXOutputVisitor::go(const Zp & x) {
  d_os << x.value();
};


TeXOutputVisitor::TeXOutputVisitor(MyOstream & os) : OutputVisitor(os),
    d_showOne(false), d_showPlusWithNumbers(true) {};

void TeXOutputVisitor::go(const tRational<INTEGER> & x) {
  int sg = x.sgn();
  const INTEGER & I = x.numerator();
  const INTEGER & J = x.denominator();
  if(sg==1) {
    if(d_showPlusWithNumbers) {
      d_os << " + ";
    } else {
      d_os << "  ";
    };
  } else if(sg==-1) {
    d_os << " - ";
  };
  if(J.one()) {
    d_os << sg*I.internal();
  } else {
    d_os << "\\frac{";
    d_os << sg*I.internal();
    d_os << "}{";
    d_os << J.internal();
    d_os << "}";
  };                
};

void TeXOutputVisitor::go(const tRational<LINTEGER> & x) {
  int sg = x.sgn();
  const LINTEGER & I = x.numerator();
  const LINTEGER & J = x.denominator();
  if(sg==1) {
    if(d_showPlusWithNumbers) {
      d_os << " + ";
    } else {
      d_os << "  ";
    };
  } else if(sg==-1) {
    d_os << " - ";
  };
  if(J.one()) {
    d_os << sg*I.internal();
  } else {
    d_os << "\\frac{";
    d_os << sg*I.internal();
    d_os << "}{";
    d_os << J.internal();
    d_os << "}";
  };                
};

#ifdef USE_MyInteger
void TeXOutputVisitor::go(const tRational<MyInteger> & x) { 
  int sg = x.sgn();
  const MyInteger & I = x.numerator();
  const MyInteger & J = x.denominator();
  if(sg==1) {
    if(d_showPlusWithNumbers) {
      d_os << " + ";
    } else {
      d_os << "  ";
    };
  } else if(sg==-1) {
    d_os << " - ";
  };
  if(J.one()) {
    d_os << sg*lg(I.internal());
  } else {
    d_os << "\\frac{";
    d_os << sg*lg(I.internal());
    d_os << "}{";
    d_os << lg(J.internal());
    d_os << "}";
  };                
};
#endif
#endif
