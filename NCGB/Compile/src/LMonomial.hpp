// LMonomial.h

#ifndef INCLUDED_MONOMIAL_H
#define INCLUDED_MONOMIAL_H

#define NO_DATA
//#define DEBUG_MONOMIAL

#ifndef NO_DATA
class AuxilaryData;
#endif

#ifndef INCLUDED_VARIABLE_H
#include "Variable.hpp"
#endif
#include "VariableSet.hpp"
#include "ICopy.hpp"
#ifndef INCLUDED_GBLIST_H
#include "GBList.hpp"
#endif
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"

#define USE_MONOMIAL_ONE

typedef GBList<Variable>::const_iterator MonomialIterator;

#ifdef USE_MONOMIAL_ONE
struct DoMonomialOne;
#endif

class Monomial {
  static void errorh(int);
  static void errorc(int);
  friend class OKFriend;
public:
  Monomial();
  Monomial(const Monomial &);
  ~Monomial();
  void  operator = (const Monomial &);

  void reserve(int){};

  void variablesIn(VariableSet &) const;
  void setToOne();
  bool one() const { return _numberOfFactors==0;}
  inline int numberOfFactors() const;
  void setPart(Monomial & m,int start,int end) const;

  // basic math functions
  void operator *= (const Monomial &);
  void operator *= (const Variable &);
  void premultiply(const Monomial & pre);
  void postmultiply(const Monomial & post) {
    operator *=(post);
  };
  void copyFirst(const Monomial &,int);
  void copyLast(const Monomial &,int);
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
  GBList<Variable> _factors;
  int compareMonomialsAux(const Monomial & aMonomial) const;
  inline void addFactor(const Variable & aTree);
#ifdef CAREFUL
  void check(int index) const;
#endif
  int _numberOfFactors;
#ifdef USE_MONOMIAL_ONE
  static GBList<Variable> * s_one_p;
  friend struct DoMonomialOne;
#endif
};

MyOstream & operator <<(MyOstream &,const Monomial &);

#ifdef USE_MONOMIAL_ONE
inline void Monomial::setToOne() {
  if(_numberOfFactors != 0) {
    _factors = * s_one_p;
    _numberOfFactors = 0;
  };
#ifndef NO_DATA
  if(d_monomialData) d_monomialData->vClearData(1);
#endif
#ifdef DEBUG_MONOMIAL
  if(_numberOfFactors!=_factors.size()) errorh(__LINE__);
#endif
};
#endif


inline void Monomial::operator *= (const Variable & aTree) { 
#ifdef DEBUG_MONOMIAL
  if(_numberOfFactors!=_factors.size()) errorh(__LINE__);
#endif
  addFactor(aTree);
#ifdef DEBUG_MONOMIAL
  if(_numberOfFactors!=_factors.size()) errorh(__LINE__);
#endif
};

inline MonomialIterator Monomial::begin() const { 
#ifdef DEBUG_MONOMIAL
  if(_numberOfFactors!=_factors.size()) errorh(__LINE__);
#endif
  return _factors.begin();
};

inline MonomialIterator Monomial::end() const { 
#ifdef DEBUG_MONOMIAL
  if(_numberOfFactors!=_factors.size()) errorh(__LINE__);
#endif
  return _factors.end();
};

inline int Monomial::numberOfFactors() const {
#ifdef DEBUG_MONOMIAL
  if(_numberOfFactors!=_factors.size()) errorh(__LINE__);
#endif
  return _numberOfFactors;
};

inline void Monomial::addFactor(const Variable & aTree) {
   _factors.push_back(aTree);
   _numberOfFactors++;
#ifdef DEBUG_MONOMIAL
  if(_numberOfFactors!=_factors.size()) errorh(__LINE__);
// mxs
   if(numberOfFactors()>1000) errorh(__LINE__);
#endif
};

inline bool Monomial::operator!= (const Monomial & aMonomial) const { 
#ifdef DEBUG_MONOMIAL
   if(_numberOfFactors!=_factors.size()) errorh(__LINE__);
#endif
  return !(numberOfFactors()==aMonomial.numberOfFactors() &&
           compareMonomials(aMonomial)==0);
};

inline bool Monomial::operator == (const Monomial & aMonomial) const {
#ifdef DEBUG_MONOMIAL
  if(_numberOfFactors!=_factors.size()) errorh(__LINE__);
#endif
  return numberOfFactors()==aMonomial.numberOfFactors() &&
         compareMonomials(aMonomial)==0;
};

inline int Monomial::compareMonomials(const Monomial & Right) const {
  int Result;
  if (this == &Right) {
    Result = 0;
  } else {
    Result = _numberOfFactors - Right._numberOfFactors;
    if(Result==0) Result = compareMonomialsAux(Right);
  }
#ifdef DEBUG_MONOMIAL
  if(_numberOfFactors!=_factors.size()) errorh(__LINE__);
#endif
  return Result;
};
#endif
