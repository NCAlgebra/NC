// Polynomial.h

#ifndef INCLUDED_POLYNOMIAL_H
#define INCLUDED_POLYNOMIAL_H

#include "version.hpp"
#ifndef INCLUDED_TERM_H
#include "Term.hpp"
#endif
#include "GBList.hpp"
class VariableSet;
#include "AdmissibleOrder.hpp"

typedef GBList<Term>::const_iterator PolynomialIterator;

class Polynomial {
  static void errorh(int);
  static void errorc(int);
public:
  typedef GBList<Term> InternalContainerType;

  inline Polynomial();
  Polynomial(const Polynomial & RightSide);
  ~Polynomial() {};
  void operator = (const Polynomial &);
  void operator = (const Term &);
   
  void setToZero();
  void setToOne();
  bool zero() const;
  bool one() const;
  inline int numberOfTerms() const;
  void makeMonic() {
    Field f(tipCoefficient());
    if(!f.one()) {
      f.invert();
      operator *=(f);
    };
  };
  void variablesIn(VariableSet & result) const;

  inline PolynomialIterator begin() const;

  const Term & tip() const { return * begin();};
  const Monomial & tipMonomial() const { return (* begin()).MonomialPart();};
  const Field & tipCoefficient() const { return (* begin()).CoefficientPart();};
  void removetip(const Term & t);
  Term removetip(); 
  void Removetip(); 
  const Term & lastTerm() const { 
    PolynomialIterator w(begin());
    const int sz = numberOfTerms();
    for(int i=1;i<sz;++i,++w) {};
    return *w;
  };
  void addNewLastTerm(const Term & t);

  // basic math functions
public:
  void CoefficientAdd(const Field & f,const Polynomial &p) {
    Polynomial q(p);
    q *= f;
    operator +=(q);
  };
  void operator += (const Polynomial &);
  void operator -= (const Polynomial &);
  void operator *= (const Field &);
  void setWithList(const list<Term> &);
  void doubleProduct(const Field & f,const Monomial &,
        const Polynomial &,const Monomial &);
  void doubleProduct(const Monomial &,
        const Polynomial &,const Monomial &);

  inline bool operator !=(const Polynomial &) const;
  bool operator ==(const Polynomial &) const;

  int totalDegree() const;
  inline void reOrderPolynomial() const;
  void printNegative(MyOstream &);
private:
  GBList<Term> _terms;
#ifdef CAREFUL
  void check(int index) const;
#endif
  int _numberOfTerms;
  mutable int _totalDegree;
  void reOrderPolynomialPrivate() const;
  inline void addTermToEnd(const Term & t);
  int compareTwoMonomials(const Monomial &,const Monomial &) const;
  void recomputeTotalDegree();
  void error1(int) const;
  void error2(int) const;
};

MyOstream & operator << (MyOstream &,const Polynomial &);

#ifdef CAREFUL
inline void Polynomial::check(int index) const {
  if(index<=0) error1(index);
  int num = numberOfTerms();
  if(index > num) error2(index);
};
#endif

inline bool Polynomial::zero() const {
   return numberOfTerms() == 0;
};

inline bool Polynomial::one() const {
  bool result = numberOfTerms() == 1;
  if(result) {
    // Bypass the checking on ordering
    PolynomialIterator j = _terms.begin();
    result = (*j).MonomialPart().numberOfFactors()==0 &&
             (*j).CoefficientPart().one();
  }
  return result;
};

inline void Polynomial::setToZero() {
  if(_numberOfTerms>0) {
     _terms.clear();
     _numberOfTerms = 0;
     _totalDegree = 0;
  }
  else if(_numberOfTerms<0) errorh(__LINE__); 
};

inline int Polynomial::numberOfTerms() const {
    return(_numberOfTerms);
};

#if 0
// 2/21/99
inline void Polynomial::operator += (const Field & aNumber) {
   Term t(aNumber);
   this->operator += (t);
};
#endif

#if 0
// 2/21/99
inline void Polynomial::operator -= (const Field & aNumber) {
   Term t(aNumber);
   this->operator -= (t);
};
#endif

inline void Polynomial::operator = (const Polynomial & RightSide) {
   _terms = RightSide._terms;
   _numberOfTerms = RightSide._numberOfTerms;
   _totalDegree = RightSide._totalDegree;
};
   
inline void Polynomial::operator = (const Term & RightSide) {
  setToZero();
  if(!RightSide.CoefficientPart().zero())
  {
    addTermToEnd(RightSide);
  }
  // The list is now properly ordered.
};
   
#if 0
// 2/21/99
#ifndef USEGnuGCode
inline Polynomial Polynomial::operator + (const Polynomial & x) const {
   Polynomial newPoly = (*this);
   newPoly += x;
   return newPoly;
};

inline Polynomial Polynomial::operator - (const Polynomial & x) const {
   Polynomial newPoly = (*this);
   newPoly -= x;
   return newPoly;
};

inline Polynomial Polynomial::operator * (const Polynomial & x) const {
   Polynomial newPoly = (*this);
   newPoly *= x;
   return newPoly;
};

inline Polynomial Polynomial::operator - () const {
  Polynomial z;
  z.setToZero();
  z-= (*this);
  return z;
};

#else
inline Polynomial Polynomial::operator + (const Polynomial & x) const
  return newPoly;
{
   newPoly = (*this);
   newPoly += x;
};

inline Polynomial Polynomial::operator - (const Polynomial & x) const
  return newPoly;
{
   newPoly = (*this);
   newPoly -= x;
};

inline Polynomial Polynomial::operator * (const Polynomial & x) const
  return newPoly;
{
   newPoly = (*this);
   newPoly *= x;
};
                
inline Polynomial Polynomial::operator - () const 
  return z;
{ 
   z.setToZero(); 
   z-= (*this);
};
#endif
#endif

inline
Polynomial::Polynomial()   : _numberOfTerms(0), _totalDegree(0)
  // The list is now properly ordered.
{
};

inline bool Polynomial::operator !=(const Polynomial & x) const {
  return !operator==(x);
};

inline PolynomialIterator
Polynomial::begin() const {
  // check that the terms are ordered with the current ordering
  reOrderPolynomial();
  return _terms.begin();
};

inline void Polynomial::reOrderPolynomial() const {};

//#define CHECK_FOR_ZERO_COEFFICIENTS

inline void Polynomial::addTermToEnd(const Term & t) {
  if(_totalDegree<t.MonomialPart().numberOfFactors()) {
    _totalDegree = t.MonomialPart().numberOfFactors();
  };
#ifdef CHECK_FOR_ZERO_COEFFICIENTS
if(t.CoefficientPart().zero()) errorh(__LINE__);
#endif
  _terms.push_back(t);
  ++_numberOfTerms;
};
#endif 
