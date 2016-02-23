// (c) Mark Stankus 1999
// MidMonomial.h

#ifndef INCLUDED_MONOMIAL_H
#define INCLUDED_MONOMIAL_H

#define NO_DATA
#define MID_MONOMIAL

#ifndef NO_DATA
class AuxilaryData;
#endif

#ifndef INCLUDED_VARIABLE_H
#include "Variable.hpp"
#endif
#include "VariableSet.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "ICopy.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"
#include "ListManager.hpp"

typedef list<Variable>::const_iterator MonomialIterator;

class Monomial {
  friend class OKFriend;
public:
  Monomial();
  Monomial(const Monomial &);
  ~Monomial();
  void  operator = (const Monomial & RightSide);

  void reserve(int){};

  void variablesIn(VariableSet & result) const;
  void setToOne();
  inline int numberOfFactors() const;
  int degreeOfMonomial() const;
  void setPart(Monomial & m,int start,int end) const;

  // basic math functions
  void operator *= (const Monomial &);
  void operator *= (const Variable &);
  void premultiply(const Monomial & pre);
  void postmultiply(const Monomial & post) {
    operator *=(post);
  };
  void prepostmultiply(const Monomial & pre,const Monomial & post);
  bool operator != (const Monomial &) const;
  inline bool operator == (const Monomial &) const;
  MonomialIterator begin() const;
  MonomialIterator end() const;
  int numberMatch(const Monomial &,int start) const;
#ifndef NO_DATA
  AuxilaryData * auxilaryData() const {
    return d_monomialData;
  };
  void auxilaryData(AuxilaryData * p) const;
#endif 
  bool mightBeDivisibleBy(const Monomial & x) const {
    return _numberOfFactors>=x._numberOfFactors;
  };
private:
  inline int compareMonomials(const Monomial &) const;
  void error() const;
#ifndef NO_DATA
  mutable AuxilaryData  * d_monomialData;
#endif
#ifdef CAREFUL
  static const char * theString;
  static const char * thFactor;
  static const char * ThereAre;
  static const char * factorsString;
  void error1(int) const;
  void error2(int) const;
#endif
  list<Variable> _factors;
  int compareMonomialsAux(const Monomial & aMonomial) const;
  inline void addFactor(const Variable & aTree);
  int _numberOfFactors;
};

MyOstream & operator <<(MyOstream &,const Monomial &);

inline void Monomial::operator *= (const Variable & aTree) { 
  addFactor(aTree);
};

inline MonomialIterator Monomial::begin() const { 
  return _factors.begin();
};

inline MonomialIterator Monomial::end() const {
  return _factors.end();
};

inline int Monomial::numberOfFactors() const {
  return _numberOfFactors;
};

inline void Monomial::addFactor(const Variable & aTree) {
   _factors.push_back(aTree);
   _numberOfFactors++;
// mxs
   if(numberOfFactors()>1000) DBG();
};

inline bool Monomial::operator!= (const Monomial & aMonomial) const { 
  return !(numberOfFactors()==aMonomial.numberOfFactors() &&
           compareMonomials(aMonomial)==0);
};

inline bool Monomial::operator == (const Monomial & aMonomial) const {
  return numberOfFactors()==aMonomial.numberOfFactors() &&
         compareMonomials(aMonomial)==0;
};

inline int Monomial::compareMonomials(const Monomial & Right) const {
  int Result = 0;
  if (this!=&Right) {
    Result = _numberOfFactors - Right._numberOfFactors;
    if(Result==0&&_numberOfFactors>0) Result = compareMonomialsAux(Right);
  }
  return Result;
};
#endif
