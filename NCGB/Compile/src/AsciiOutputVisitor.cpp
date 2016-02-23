// AsciiOutputVisitor.c

#include "AsciiOutputVisitor.hpp"
#ifdef USE_VIRT_FIELD
#include "MyOstream.hpp"
#include "Zp.hpp"

AsciiOutputVisitor::~AsciiOutputVisitor() {};

AsciiOutputVisitor::AsciiOutputVisitor(MyOstream & os) : OutputVisitor(os),
    d_showOne(false) {};

void AsciiOutputVisitor::go(const Zp & x) {
  d_os << x.value() << " (" << Zp::s_Characteristic() << ") ";
};

void AsciiOutputVisitor::go(const tRational<LINTEGER> & x) {
  int sg = x.sgn();
  const LINTEGER & I = x.numerator();
  const LINTEGER & J = x.denominator();
  const bool flag =  I.needsParenthesis();
  if(flag) d_os << '(';
  if(sg==1) {
    d_os << " + ";
    d_os << I.internal();
  } else if(sg==-1) {
    d_os << " - ";
    d_os << -(I.internal());
  };
  if(flag) d_os << ')';
  if(!J.one()) {
    d_os << "/(";
    d_os << J.internal();
    d_os << ')';
  }
};           

void AsciiOutputVisitor::go(const tRational<INTEGER> & x) {
  int sg = x.sgn();
  const INTEGER & I = x.numerator();
  const INTEGER & J = x.denominator();
  const bool flag =  I.needsParenthesis();
  if(flag) d_os << '(';
  if(sg==1) {
    d_os << " + ";
    d_os << I.internal();
  } else if(sg==-1) {
    d_os << " - ";
    d_os << -(I.internal());
  };
  if(flag) d_os << ')';
  if(!J.one()) {
    d_os << "/(";
    d_os << J.internal();
    d_os << ')';
  }
};           

#ifdef USE_MyInteger
void AsciiOutputVisitor::go(const tRational<MyInteger> & x) { 
  int sg = x.sgn();
  const MyInteger & I = x.numerator();
  const MyInteger & J = x.denominator();
  const bool flag =  I.needsParenthesis();
  if(flag) d_os << '(';
  if(sg==1) {
    d_os << " + ";
    d_os << lg(I.internal());
  } else if(sg==-1) {
    d_os << " - ";
    d_os << -lg(I.internal());
  };
  if(flag) d_os << ')';
  if(!J.one()) {
    d_os << "/(";
    d_os << lg(J.internal());
    d_os << ')';
  }
};
#endif
#endif
