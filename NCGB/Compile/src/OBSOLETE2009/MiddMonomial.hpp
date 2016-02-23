// (c) Mark Stankus 1999
// MidMonomial.h

#ifndef INCLUDED_MONOMIAL_H
#define INCLUDED_MONOMIAL_H

#define NO_DATA
#define MID_MONOMIAL
#define DEBUG__MID_MONOMIAL

#ifndef INCLUDED_VARIABLE_H
#include "Variable.hpp"
#endif
#include "VariableSet.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "ICopy.hpp"
#include "Copy.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"
#include "ListManager.hpp"

class MonomialIterator;

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
  bool operator == (const Monomial &) const;
  MonomialIterator begin() const;
  MonomialIterator end() const;
  int numberMatch(const Monomial &,int start) const;
  bool mightBeDivisibleBy(const Monomial & x) const {
    return d_numberOfFactors>=x.d_numberOfFactors;
  };
private:
  void error() const;
  Copy<list<Variable> > d_factors;
  int d_numberOfFactors;
  static const list<Variable> s_one;
};

class MonomialIterator {
  const Copy<list<Variable> > * d_x_p;
  list<Variable>::const_iterator d_w;
public:
  MonomialIterator() : d_x_p(0), d_w() {};
  MonomialIterator(const Copy<list<Variable> > & x,
       list<Variable>::const_iterator w) : d_x_p(&x), d_w(w) {
    if(d_x_p->isValid()) d_x_p->freezeIt(); 
  };
  MonomialIterator(const MonomialIterator & x) : d_x_p(x.d_x_p), d_w(x.d_w) {
    if(d_x_p->isValid()) d_x_p->freezeIt(); 
  };
  ~MonomialIterator() { 
    if(d_x_p->isValid()) d_x_p->unfreezeIt(); 
  };
  void operator=(const MonomialIterator & x) { 
    d_x_p=x.d_x_p; 
    d_w=x.d_w;
    if(d_x_p->isValid()) d_x_p->freezeIt(); 
  };
  const Variable & operator *() const {
    if(d_x_p->isFrozen()) DBG();
    return *d_w;
  };
  void operator++() { ++d_w; };
  void operator--() { --d_w; };
};

MyOstream & operator <<(MyOstream &,const Monomial &);

inline void Monomial::operator *= (const Variable & x) { 
  d_factors.access().push_back(x);
  d_numberOfFactors++;
  if(d_numberOfFactors>1000) DBG();
};

inline MonomialIterator Monomial::begin() const { 
  d_factors.makeUnique();
  return MonomialIterator(d_factors,d_factors().begin());
};

inline MonomialIterator Monomial::end() const { 
  d_factors.makeUnique();
  return MonomialIterator(d_factors,d_factors().end());
};

inline int Monomial::numberOfFactors() const {
  return d_numberOfFactors;
};

inline bool Monomial::operator!= (const Monomial & x) const { 
  return !operator==(x);
};
#endif
