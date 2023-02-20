// Term.c

#include "Term.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"
#ifndef INCLUDED_OUTERM_H
#include "OuTerm.hpp"
#endif

#if 0
// Moved to the header file inline
Term::Term()  : d_monomial(s_MONOMIAL_ONE), d_number(1) {
};

Term::Term(const COEFFICIENT & aCOEFFICIENT) :
    d_monomial(s_MONOMIAL_ONE), d_number(aCOEFFICIENT) {};

void Term::assign(const COEFFICIENT & aCOEFFICIENT) {
  d_monomial.access().setToOne();
  d_number = aCOEFFICIENT;
};

Term::Term(const MONOMIAL & x)  : d_monomial(x), d_number(1) {};

void Term::assign(const MONOMIAL & x)  {
  d_monomial = x;
  d_number.setToOne();
};

Term::Term(const COEFFICIENT & aCOEFFICIENT,const MONOMIAL & aMono) :
    d_monomial(aMono), d_number(aCOEFFICIENT) {};

void Term::assign(const COEFFICIENT & aCOEFFICIENT,const MONOMIAL & aMono) {
 d_monomial=aMono;
 d_number=aCOEFFICIENT;
};

Term::Term(const Term & x)  : d_monomial(x.d_monomial), d_number(x.d_number){};

void Term::assign(const Term & x)  {
  d_monomial=x.d_monomial;
  d_number=x.d_number;
};
#endif

void  Term::operator /= (const COEFFICIENT & x) {
   if(x.zero()) {
     GBStream << "Trying to divide by zero in Term::operator /=\n";
     DBG();
   }
   d_number /= x;
};

void  Term::operator *= (const Term & x) {
   d_number *= x.d_number;
   d_monomial.access() *= x.d_monomial();
};

void  Term::operator *= (const Monomial & x) {
   d_monomial.access() *= x;
};

void  Term::operator *= (const Field & x) {
   d_number *= x;
};

void Term::premultiply(const Term & x) {
  d_number *= x.d_number;
  premultiply(x.d_monomial());
};

void Term::premultiply(const Monomial & x) {
  Monomial y(x);
  y *= d_monomial();
  d_monomial = y;
};

#ifndef USEGnuGCode
Term Term::operator * (const Term &anotherTerm) const {
  Term newTerm(*this);
  newTerm.Coefficient() *= anotherTerm.CoefficientPart();
  newTerm.MonomialPart() *= anotherTerm.MonomialPart();
  return newTerm;
};
#else
Term Term::operator * (const Term &anotherTerm) const
   return newTerm; {
  newTerm.Coefficient() *= anotherTerm.CoefficientPart();
  newTerm.MonomialPart() *= anotherTerm.MonomialPart();
  return newTerm;
};
#endif

MyOstream & operator <<(MyOstream & os,const Term & x) {
  OuTerm::NicePrint(os,x);
  return os;
};

const INTEGER Term::s_ONE(1L);
const Term Term::s_TERM_ONE;
const Monomial Term::s_MONOMIAL_ONE;
