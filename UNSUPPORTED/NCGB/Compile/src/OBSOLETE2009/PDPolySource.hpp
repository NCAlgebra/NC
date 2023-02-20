// (c) Mark Stankus 1999
// PDPolySource.h
  // Designed to replicate as in my post-doc work

#ifndef INCLUDED_PDPOLYSOURCE_H
#define INCLUDED_PDPOLYSOURCE_H

#include "PolySource.hpp"
#include "GroebnerRule.hpp"
#include "GiveNumber.hpp"
#include "RuleID.hpp"
#include "ICopy.hpp"
#include "GBMatch.hpp"
#include "SetSource.hpp"
#include "MatcherMonomial.hpp"
#include "Choice.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#include <set>
#include <utility>
#else
#include <list.h>
#include <set.h>
#include <pair.h>
#endif
#include "vcpp.hpp"

class PDPolySource : public PolySource {
  static void errorh(int);
  static void errorc(int);
  void operator=(const PDPolySource &);
    // not implemented
  list<Match> d_list;
  pair<int,int> d_numbers;
  set<RuleID,less<RuleID> > d_active;
  set<RuleID,less<RuleID> > d_inactive;
  ICopy<SetSource<pair<int,int> > > d_ints;
  void fillList();
  void spolynomial(const Match &,Polynomial &) const;
  GiveNumber & d_give;
public:
  PDPolySource(GiveNumber & give,const set<RuleID,less<RuleID> > & active,
      const set<RuleID,less<RuleID> > & inactive, 
      const ICopy<SetSource<pair<int,int> > > & ints) : PolySource(s_ID),
      d_active(active), d_inactive(inactive), d_ints(ints), d_give(give) {};
  PDPolySource(const PDPolySource & x) : PolySource(s_ID),
     d_active(x.d_active), d_inactive(x.d_inactive), d_ints(x.d_ints), 
     d_give(x.d_give) {};
  virtual ~PDPolySource();
  virtual void insert(const RuleID &);
  virtual void insert(const PolynomialData &);
  virtual void remove(const RuleID &);
  virtual void fillForUnknownReason();
  virtual void print(MyOstream &) const;
  virtual void setPerm(int n);
  virtual void setNotPerm(int n);
  virtual bool getNext(Polynomial & p,ReductionHint&,Tag *,Tag &);
  static const int s_ID;
};

inline void PDPolySource::fillList() {
  const GroebnerRule & rule1 = d_give.fact(d_numbers.first);
  const GroebnerRule & rule2 = d_give.fact(d_numbers.second);
#if 0
  if(findRule(id1,d_numbers.first,d_active)) {
    if(findRule(id2,d_numbers.second,d_active)) {
#endif
      MatcherMonomial matcher;
      const Monomial & LHS1 = rule1.LHS(); // id1.poly().mono();
      const Monomial & LHS2 = rule2.LHS(); // id2.poly().mono();
      if(UserOptions::s_UseSubMatch) {
        matcher.subMatch(LHS1,d_numbers.first,LHS2,d_numbers.second,d_list);
      };
      matcher.overlapMatch(LHS1,d_numbers.first,LHS2,d_numbers.second,d_list);
#if 0
    };
  };
#endif
};
#endif
