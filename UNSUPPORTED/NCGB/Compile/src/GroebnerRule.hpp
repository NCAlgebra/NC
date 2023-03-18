// GroebnerRule.h

#ifndef INCLUDED_GROEBNERRULE_H
#define INCLUDED_GROEBNERRULE_H

#ifndef INCLUDED_POLYNOMIAL_H
#include "Polynomial.hpp"
#endif
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "VariableSet.hpp"
#include "vcpp.hpp"

struct DoGroebnerRule;

class GroebnerRule {
public:
   GroebnerRule() {};
   ~GroebnerRule() {};
   GroebnerRule(const Monomial & mono, const Polynomial & aPolynomial);
   GroebnerRule(const GroebnerRule & aGRule);
   void convertAssign(const Polynomial & p);
   void operator = (const GroebnerRule &);
   const Monomial & LHS() const;
   Monomial & LHS();
   void LHS(const Monomial & newLHS);
   const Polynomial & RHS() const;
   Polynomial & RHS();
   void RHS(const Polynomial & newRHS);
   Polynomial toPolynomial() const;
   inline void toPolynomial(Polynomial & p) const;
  
   bool operator != (const GroebnerRule & aRule) const;
   bool operator == (const GroebnerRule & aRule) const;

   void variablesIn(VariableSet & result) const;
private:
   Monomial _monomial;
   Polynomial _polynomial;
   static INTEGER s_NegOne;
   static Term * s_term_p;
   friend struct DoGroebnerRule;
};

MyOstream & operator <<(MyOstream & os,const GroebnerRule & aRule);

inline GroebnerRule::GroebnerRule(const Monomial & mono, 
                           const Polynomial & aPolynomial) :
     _monomial(mono), _polynomial(aPolynomial) {
};

inline GroebnerRule::GroebnerRule(const GroebnerRule & aGRule) :
  _monomial(aGRule._monomial), _polynomial(aGRule._polynomial) { };

inline const Monomial & GroebnerRule::LHS() const {
   return _monomial;
};

inline Monomial & GroebnerRule::LHS() {
   return _monomial;
};

inline void GroebnerRule::LHS(const Monomial & newLHS) {
   _monomial = newLHS;
};

inline void GroebnerRule::RHS(const Polynomial & newRHS) {
   _polynomial = newRHS;
};  

inline const Polynomial & GroebnerRule::RHS() const {
   return _polynomial;
};

inline Polynomial & GroebnerRule::RHS() {
   return _polynomial;
};

#ifndef USEGnuGCode
inline Polynomial GroebnerRule::toPolynomial() const {
  Polynomial poly;
  toPolynomial(poly);
  return poly;
};
#else
inline Polynomial GroebnerRule::toPolynomial() const  
   return poly; {
  toPolynomial(poly);
};
#endif

inline void GroebnerRule::toPolynomial(Polynomial & poly) const {
   poly.setToZero();
   s_term_p->assign(_monomial);
   poly = *s_term_p; 
   poly -= RHS();
};

inline void GroebnerRule::operator = (const GroebnerRule & RightSide) {
  _monomial = RightSide._monomial;
  _polynomial = RightSide._polynomial;
};

inline void GroebnerRule::variablesIn(VariableSet & result) const {
  _monomial.variablesIn(result); 
  _polynomial.variablesIn(result);
};

inline bool GroebnerRule::operator == (const GroebnerRule & aRule) const { 
  return _monomial == aRule._monomial && _polynomial == aRule._polynomial;
};

inline bool GroebnerRule::operator != (const GroebnerRule & aRule) const { 
  return !(_monomial == aRule._monomial && _polynomial == aRule._polynomial);
};
#endif 
