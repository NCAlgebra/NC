// (c) Mark Stankus 19999
// Poly.h

#ifndef INCLUDED_POLY_H
#define INCLUDED_POLY_H

#include "version.hpp"
#ifndef INCLUDED_TERM_H
#include "Term.hpp"
#endif
class VariableSet;
#include "AdmissibleOrder.hpp"
#include "PolynomialRep.hpp"
#include "Copy.hpp"
#include <list>
#include <set>

class PolynomialIterator {
  list<Copy<Term> >::const_iterator d_w;
  PolynomialIterator();
    // not implemented
public:
  PolynomialIterator(const list<Copy<Term> >::const_iterator & w) : d_w(w) {};
  PolynomialIterator(const PolynomialIterator & x) : d_w(x.d_w) {};
  void operator=(const PolynomialIterator & x) {
    d_w = x.d_w;
  };
  void operator=(const list<Copy<Term> >::const_iterator & w) {
    d_w = w;
  };
  bool operator==(const list<Copy<Term> >::const_iterator & x) const {
    return d_w==x;
  };
  bool operator!=(const list<Copy<Term> >::const_iterator & x) const {
    return d_w!=x;
  };
  bool operator==(const PolynomialIterator & x) const {
    return d_w==x.d_w;
  };
  bool operator!=(const PolynomialIterator & x) const {
    return d_w!=x.d_w;
  };
  void operator++() { ++d_w;};
  void operator--() { --d_w;};
  const Term & operator*() const { 
    return (*d_w)();
  };
};

class Polynomial {
  list<Copy<Term> > d_terms;
  set<PolynomialRep *,PolynomialRepCompare> d_set;

  void privateadd(const Polynomial &,bool);
  void clearSet() {
    while(!d_set.empty()) {
      set<PolynomialRep *,PolynomialRepCompare>::iterator w = d_set.begin(); 
      PolynomialRep * p = *w; 
      d_set.erase(w);
      delete p;
    };
  };
  void putAllInList() {
    bool cont = !d_set.empty();
    while(cont) {
      cont = oneFromSetToList(false);
    };
  };
  void copySet(const set<PolynomialRep *,PolynomialRepCompare> & S) {
    clearSet();
    typedef set<PolynomialRep *,PolynomialRepCompare>::const_iterator SI;
    SI w = S.begin(), e = S.end(); 
    while(w!=e) {
      d_set.insert((*w)->clone());
      ++w;
    };
  };
  bool oneFromSetToList(bool empty_error);
  void addIntoSet(PolynomialRep * p);
  int d_numberOfTerms;
public:
  typedef list<Copy<Term> > InternalContainerType;
  Polynomial();
  Polynomial(const Polynomial & x);
  ~Polynomial() {};
  void operator = (const Polynomial & x) {
    if(this!=&x) {
      clearSet();
      copySet(x.d_set);
// HERE
      putAllInList();
      d_terms = x.d_terms;
      d_numberOfTerms = x.d_numberOfTerms;
    };
  };
  void operator = (const Term & x) {
    setToZero();
    if(!x.CoefficientPart().zero()) {
      Term * p = new Term(x);
      Copy<Term> yy(p,Adopt::s_dummy);
      addTermToEnd(yy);
    }
  };
  void operator = (const Copy<Term> & x) {
    setToZero();
    if(!x().CoefficientPart().zero()) {
      addTermToEnd(x);
    }
  };
  void setToZero() {
    d_terms.erase(d_terms.begin(),d_terms.end());
    d_numberOfTerms = 0;
    clearSet(); 
  };
  void setToOne();
  bool zero() const {
    return d_terms.empty() && d_set.empty();
  };
  bool one() const {
    Copy<Term> t;
    if(d_terms.empty()) {
      if(!d_set.empty()) {
        Polynomial * p = const_cast<Polynomial*>(this);
        p->oneFromSetToList(true);
        t = * d_terms.begin();
      };
    } else {
      t = * d_terms.begin();
    };
    return t.isValid() && t().MonomialPart().one()==0 && 
           t().CoefficientPart().one();
  };
  int numberOfTerms() const {
    Polynomial * p = const_cast<Polynomial*>(this);
    p->putAllInList();
    return d_numberOfTerms;
  };

  void variablesIn(VariableSet & result) const;

  inline PolynomialIterator begin() const;

  const Term & tip() const { return * begin();};
  const Monomial & tipMonomial() const { return (* begin()).MonomialPart();};
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
  void operator += (const Polynomial & p) {
    privateadd(p,false);
  };
  void operator -= (const Polynomial & p) {
    privateadd(p,true);
  };
  void operator *= (const Field &);
  void setWithList(const list<Term> &);
  void doubleProduct(const Field & f,const Monomial &,
        const Polynomial &,const Monomial &);
  void doubleProduct(const Monomial &,
        const Polynomial &,const Monomial &);

  inline bool operator !=(const Polynomial &) const;
  bool operator ==(const Polynomial &) const;

  void printNegative(MyOstream &);
private:
  void addTermToEnd(const Copy<Term> & t);
  int compareTwoMonomials(const Monomial &,const Monomial &) const;
};

MyOstream & operator << (MyOstream &,const Polynomial &);

inline Polynomial::Polynomial() : d_set(AdmissibleOrder::s_getCurrent()),
      d_numberOfTerms(0) { };

inline bool Polynomial::operator !=(const Polynomial & x) const {
  return !operator==(x);
};

inline PolynomialIterator Polynomial::begin() const {
  // check that the terms are ordered with the current ordering
  if(!d_set.empty()) {
    Polynomial * p = const_cast<Polynomial *> (this);
    p->putAllInList();
  };
  PolynomialIterator result(d_terms.begin());
  return result;
};

//#define CHECK_FOR_ZERO_COEFFICIENTS

inline void Polynomial::addTermToEnd(const Copy<Term> & t) {
#ifdef CHECK_FOR_ZERO_COEFFICIENTS
  if(t().CoefficientPart().zero()) DBG();
#endif
  putAllInList();
  d_terms.push_back(t);
  ++d_numberOfTerms;
};
#endif 
