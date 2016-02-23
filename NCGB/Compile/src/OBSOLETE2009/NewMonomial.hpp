// Mark Stankus 1999 (c)
// NewMonomial.h

#ifndef INCLUDED_NEWMONOMIAL_H
#define INCLUDED_NEWMONOMIAL_H

#include "Copy.hpp"
#include "MyOstream.hpp"
#include "ListManager.hpp"
#include "Variable.hpp"
#include "VariableSet.hpp"
#include "Debug1.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"
#include "AdmissibleOrder.hpp"

#define NEWMONOMIAL

class MonomialHelper {
  const AdmissibleOrder & d_order;
  list<Variable> d_list;
  vector<int> d_v;
  int d_mult;
  int d_sz;
  void commonMultiply(const MonomialHelper & help) {
    typedef vector<int>::const_iterator LCI;
    typedef vector<int>::iterator LI;
    LCI w = help.d_v.begin(), e = help.d_v.end();
    LI ww = d_v.begin();
    while(w!=e) {
      *ww += *w;
      ++w;++ww;
    };
  };
  void commonMultiply(const Variable & x);
public:
  MonomialHelper(const AdmissibleOrder & x);
  void premultiply(const MonomialHelper & help) {
    d_sz += help.d_sz;
    commonMultiply(help);
    ListManager<Variable>::s_prejoin(d_list,help.d_list);
  };
  void postmultiply(const MonomialHelper & help) {
    d_sz += help.d_sz;
    commonMultiply(help);
    ListManager<Variable>::s_postjoin(d_list,help.d_list);
  };
  void premultiply(const Variable & x) {
    d_sz += 1;
    commonMultiply(x);
    d_list.push_front(x);
  };
  void postmultiply(const Variable & x) {
    d_sz += 1;
    commonMultiply(x);
    d_list.push_back(x);
  };
  bool mightBeDivisibleBy(const MonomialHelper & x) const {
    bool result = d_sz >= x.d_sz;
    if(result) {
      int big,small;
      typedef vector<int>::const_iterator VI;
      VI w1 = d_v.begin(),e1 = d_v.end();
      VI w2 = x.d_v.begin();
      while(w1!=e1) {
        big = *w1;
        small = *w2;
        if(big<small) {
          result = false;
          break;
        };
        ++w1;++w2;
      };
    };
    return result;
  };
  void setVariables(VariableSet & x) const {
    x.clear();
    typedef list<Variable>::const_iterator  LI;
    LI w = d_list.begin(), e = d_list.end();
    while(w!=e) {
      x.insert(*w);
      ++w;
    };
  };
  const AdmissibleOrder &  ORDER() const { return d_order;};
  const list<Variable> &  LIST() const { return d_list;};
  int                   NUMBER() const { return d_sz;};
  const vector<int> & FORORDER() const { return d_v;};
  int             MULTIPLICITY() const { return d_mult;};
};

class Monomial {
  static Copy<MonomialHelper> s_one;
  static const AdmissibleOrder * s_order_p; 
  Copy<MonomialHelper> d_data;
public:
  Monomial() : d_data(AdmissibleOrder::s_getCurrent()) {
    if(s_order_p!=(const AdmissibleOrder *)AdmissibleOrder::s_getCurrentP()) {
      s_order_p = AdmissibleOrder::s_getCurrentP();
      s_one.assign(new MonomialHelper(*s_order_p),Adopt::s_dummy);
    };
  };
  Monomial(const Monomial & x) : d_data(x.d_data) {};
  ~Monomial() {};
  void  operator = (const Monomial & x) {
    d_data=x.d_data;
  };
  void variablesIn(VariableSet & result) const {
    d_data().setVariables(result);
  };
  void setToOne() {
    if(&AdmissibleOrder::s_getCurrent()!=(AdmissibleOrder*)&d_data().ORDER()) DBG();
    d_data = s_one;
  };
  bool one() const {
    return d_data().NUMBER()==0;
  };
  inline int numberOfFactors() const {
    return d_data().NUMBER();
  };
  int degreeOfMonomial() const {
    return d_data().NUMBER();
  };

  // basic math functions
  void operator *= (const Monomial & x) {
    d_data.access().postmultiply(x.d_data());
  };
  void operator *= (const Variable & x) {
    d_data.access().postmultiply(x);
  };
  void premultiply(const Monomial & x) {
    d_data.access().postmultiply(x.d_data());
  };
  void postmultiply(const Monomial & x) {
    operator *=(x);
  };
  void prepostmultiply(const Monomial & pre,const Monomial & post) {
    premultiply(pre);
    postmultiply(post);
  };
  bool operator != (const Monomial & x) const {
    return !operator==(x);
  };
  bool operator == (const Monomial &) const;
  list<Variable>::const_iterator begin() const {
    return d_data().LIST().begin(); 
  };
  list<Variable>::const_iterator end() const {
    return d_data().LIST().end(); 
  };
  int numberMatch(const Monomial &,int start) const;
  const vector<int> & FORORDER() const { 
    return d_data().FORORDER();
  };
  bool mightBeDivisibleBy(const Monomial & x) const { 
    return  d_data().mightBeDivisibleBy(x.d_data());
  };
};

MyOstream & operator <<(MyOstream &,const Monomial &);

typedef list<Variable>::const_iterator MonomialIterator;
#endif 
