// Polynomial.c

#include "Polynomial.hpp"
#include "PolynomialRep1.hpp"
#include "PolynomialRep2.hpp"
#include "PolynomialRep3.hpp"
#include "PolynomialRep4.hpp"
#include "PolynomialRep5.hpp"
#include "RecordHere.hpp"
#include "AdmissibleOrder.hpp"
#include "VariableSet.hpp"
#ifndef INCLUDED_LOAD_FLAGS_H
#include "load_flags.hpp"
#endif
#include "MyOstream.hpp"
#ifndef INCLUDED_OUTERM_H
#include "OuTerm.hpp"
#endif
#define POLYNOMIAL_USE_LIST

//#define CHECK_FOR_ZERO_COEFFICIENTS

#ifndef INCLUDED_ADMISSIBLEORDER_H
#include "AdmissibleOrder.hpp"
#endif

MyOstream & operator << (MyOstream & os,const Polynomial & x) { 
  PolynomialIterator i = x.begin();
  const int len = x.numberOfTerms();
  if(len==0) {
    os << '0';
  } else {
    OuTerm::NicePrint(os,*i);
    ++i;
    for(int k=2;k<=len;++k,++i) {
      const Term & t = *i;
      if(t.CoefficientPart().sgn()<=0) {
        os << " - ";
        OuTerm::NicePrint(os,- t);
      } else {
        os << " + ";
        OuTerm::NicePrint(os,t);
      }
    }
  }
  return os;
};

void Polynomial::printNegative(MyOstream & os) {
  PolynomialIterator i(begin());
  const int len = numberOfTerms();
  if(len==0) {
    os << '0';
  } else {
    OuTerm::NicePrint(os,-(*i));
    ++i;
    for(int k=2;k<=len;++k,++i) {
      const Term & t = (*i);
      if(t.CoefficientPart().sgn()<=0) {
        os << " + ";
        OuTerm::NicePrint(os,- t);
      } else {
        os << " - ";
        OuTerm::NicePrint(os,-t);
      }
    }
  }
};

Polynomial::Polynomial(const Polynomial & x) : d_terms(x.d_terms), 
   d_set(AdmissibleOrder::s_getCurrent()),d_numberOfTerms(x.d_numberOfTerms) {
  copySet(x.d_set);
};

void Polynomial::setToOne() {
  setToZero();
  operator =(Term::s_TERM_ONE);
  if(AdmissibleOrder::s_getCurrentP()==0) {
    GBStream << "Invalid order pointer.\n";
    DBG();
  }
};

void Polynomial::privateadd(const Polynomial & p,bool negate) {
  if(&p==this) DBG();
  if(!d_terms.empty()) {
    PolynomialRep1 * q1 = new PolynomialRep1(d_terms); 
    d_terms.erase(d_terms.begin(),d_terms.end());
    d_numberOfTerms = 0;
    addIntoSet(q1);
  };
  if(!p.d_terms.empty()) {
    PolynomialRep1 * q2 = new PolynomialRep1(p.d_terms); 
    if(negate) q2->negate();
    addIntoSet(q2);
  };
  typedef set<PolynomialRep*,PolynomialRepCompare>::iterator SI;
  SI w = p.d_set.begin(), e = p.d_set.end();
  while(w!=e) {
    PolynomialRep * q3 = (*w)->clone();
    if(negate) q3->negate();
    addIntoSet(q3);
    ++w;
  };
#ifdef POLYNOMIAL_USE_LIST
    putAllInList();
#endif
};

void Polynomial::variablesIn(VariableSet & result) const {
  const int len = numberOfTerms();
  // Bypass the reordering of the polynomial
  PolynomialIterator j = d_terms.begin();
  for(int i=1;i<=len&&!result.full();++i,++j) {
    (*j).MonomialPart().variablesIn(result);
  }
};

bool Polynomial::operator==(const Polynomial & x) const {
  bool result = true;
  if(this!=&x) {
    const int num = numberOfTerms();
    if(num!=x.numberOfTerms()) {
      result = false;
    } else {
      PolynomialIterator j = begin();
      PolynomialIterator k = x.begin();
      for (int i=1;i<=num;++i,++j,++k) {
        if((*j)!=(*k)) {
          result = false;
          break;
        };
      };
    };
  };
  return result;
};

void Polynomial::doubleProduct(const Field & f,const Monomial & x,
        const Polynomial &  poly,const Monomial & y) {
  if(&poly==this) DBG();
  setToZero();
  if(!f.zero()&& !poly.zero())  {
    Polynomial temp(poly);
    Term aterm(f,x);
    aterm *= temp.tip();
    aterm.MonomialPart() *= y;
    Copy<Term> copyterm(aterm);
    temp.Removetip();
    PolynomialRep2 * p = new PolynomialRep2(copyterm,f,x,temp,y); 
    d_set.insert(p);
#ifdef POLYNOMIAL_USE_LIST
    putAllInList();
#endif
  };
};  

void Polynomial::doubleProduct(const Monomial & x,
        const Polynomial &  poly,const Monomial & y) {
  if(&poly==this) DBG();
  setToZero();
  if(!poly.zero())  {
    Polynomial temp(poly);
    Term aterm(x);
    aterm *= temp.tip();
    aterm.MonomialPart() *= y;
    Copy<Term> copyterm(aterm);
    temp.Removetip();
    PolynomialRep4 * p = new PolynomialRep4(copyterm,x,temp,y); 
    d_set.insert(p);
#ifdef POLYNOMIAL_USE_LIST
    putAllInList();
#endif
  };
};  

int Polynomial::compareTwoMonomials(const Monomial & m1,
                                const Monomial & m2) const {
  int cmp;
  if(m1==m2) {
    cmp = 0;
  } else {
    bool flag = false; // false to prevent warnings from the compiler
    if(false) {
    } else if(isPD()) {
      if(AdmissibleOrder::s_getCurrentP()==0) {
        GBStream << "Invalid order pointer." << '\n';
        DBG();
      }
      flag = AdmissibleOrder::s_getCurrent().monomialGreater(m1,m2);
    } else DBG();
    cmp = flag ? 1 : -1;
  }
  return cmp;
};

void Polynomial::operator *= (const Field & x) {
  if(!x.zero() && !zero()) {
    Polynomial temp(*this);
    Term aterm(temp.tip());
    aterm.Coefficient() *= x;
    Copy<Term> copyterm(aterm);
    temp.Removetip();
    setToZero();
    PolynomialRep5 * q = new PolynomialRep5(copyterm,x,temp);
    addIntoSet(q);
  };
#ifdef POLYNOMIAL_USE_LIST
    putAllInList();
#endif
};

void Polynomial::addNewLastTerm(const Term & t) {
  const int sz = numberOfTerms();
  PolynomialIterator w(begin());
  if(sz>0) {
    for(int i=1;i<sz;++i,++w) {};
    const Monomial & m = (*w).MonomialPart();
    if(AdmissibleOrder::s_getCurrent().monomialGreater(t.MonomialPart(),m)) {
      DBG();
    };
    if(t.MonomialPart()==m) {
      DBG();
    };
  };
  Copy<Term> temp(t);
  addTermToEnd(temp);
#ifdef POLYNOMIAL_USE_LIST
    putAllInList();
#endif
};

void Polynomial::removetip(const Term & t) {
  if(t!=*begin()) DBG();
  d_terms.pop_front();
  d_numberOfTerms--;
};

Term Polynomial::removetip() {
  Term t(*begin());
  d_terms.pop_front();
  d_numberOfTerms--;
  return t;
};

void Polynomial::Removetip() {
  if(d_numberOfTerms==0) oneFromSetToList(false);
  d_terms.pop_front();
  d_numberOfTerms--;
};

void Polynomial::setWithList(const list<Term> & x) {
  setToZero();
  typedef list<Term>::const_iterator LI;
  LI w(x.begin()), e(x.end());
  Polynomial p;
  while(w!=e) {
    p = *w;
    operator +=(p);
#ifdef POLYNOMIAL_USE_LIST
    putAllInList();
#endif
    ++w;
  };
};

bool Polynomial::oneFromSetToList(bool empty_error) {
    if(d_set.empty()) {
      if(empty_error) DBG();
    } else {
      set<PolynomialRep*,PolynomialRepCompare>::iterator w = d_set.begin();
      PolynomialRep * p = *w;
GBStream << "Considering the polynomial rep:";
p->print();
GBStream << '\n';
      d_set.erase(w);
      d_terms.push_back(p->copyterm());
      ++d_numberOfTerms;
      bool b = p->removeTip();
GBStream << "New polynomial rep:";
p->print();
GBStream << "with boolean " << b << '\n';
      if(b) {
        addIntoSet(p);
      } else {
        delete p;
      };
    };
    return !d_set.empty();
};

void Polynomial::addIntoSet(PolynomialRep * p) {
  vector<PolynomialRep *> vec;
  vec.reserve(10);
  vec.push_back(p);
  while(!vec.empty()) {
    PolynomialRep * p = vec.back();
GBStream << "Considering:";
p->print();
GBStream << '\n';
    if(!p->valid()) DBG();
    vec.pop_back();
    set<PolynomialRep*,PolynomialRepCompare>::iterator w = d_set.find(p);
    if(w==d_set.end()) {
GBStream << "Inserting :";
p->print();
GBStream << '\n';
      d_set.insert(p);
    } else {
      PolynomialRep * q = (*w);
GBStream << "Comparing :";
p->print();
GBStream << " to ";
q->print();
GBStream << '\n';
      d_set.erase(w);
      bool b = q->addCoefficient(p->term().CoefficientPart());
      bool c = p->removeTip();
GBStream << "New polynomials: ";
p->print();
GBStream << " to ";
q->print();
GBStream << '\n';
      if(c) {
        vec.push_back(p);
      };
      if(b || (q->removeTip())){
        vec.push_back(q);
      } else {
        delete q;
      };
    };
  };
};
