// (c) Mark Stankus 1999
// SFSGPolySource.c

#include "SFSGPolySource.hpp"
#include "RuleID.hpp"
#include "PolynomialData.hpp"
#include "GBMatch.hpp"
#include "MatcherMonomial.hpp"
#include "PrintSet.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "PrintSet.hpp"
//#define SFSG_DEBUG
//#define SFSG_DEBUG_EASY

SFSGPolySource::~SFSGPolySource() {};

bool SFSGPolySource::getNext(Polynomial & p,ReductionHint & h,Tag *,Tag &) {
  bool result = !d_M.second_empty();
  Polynomial q;
  if(result) {
    BIMAP::const_iterator w = d_M.second_begin();
    p = d_M.item(w);
GBStream << "polynomials:" << p << '\n';
    Term t(d_M.key(w));
    q = t;
GBStream << "polynomials:" << q << '\n';
    p += q;
GBStream << "polynomials:" << p << '\n';
    h = d_M.extra(w);
#ifdef SFSG_DEBUG
    GBStream << "Giving back the polynomial " << p << '\n';
#endif
  };
  return result;
};

void SFSGPolySource::insert(const RuleID & x) {
  insert(x.poly());
};

void SFSGPolySource::insert(const PolynomialData & x) {
  insert(x.d_p);
};


void SFSGPolySource::insert(const Polynomial & x) {
  bool todo = true;
  Field f;
  ReductionHint hint;
  Polynomial p(x);
#ifdef SFSG_DEBUG
  int iter = 0;
#endif
  while(todo&&!p.zero()) {
    todo = false;
    f.setToOne();
    f /= x.tipCoefficient();
    p *= f;
#ifdef SFSG_DEBUG
    ++iter;
    GBStream << "Trying to add " << p 
             << " the " << iter << "-th time through the loop.\n";
#endif
    const Monomial & m = p.tipMonomial();
    BIMAP::iterator w = d_M.find(m);
    if(w==d_M.second_end()) {
      p.Removetip();
      pair<Polynomial,ReductionHint> pr(p,hint);
      BIMAP::PAIR pr2(m,pr);
      BIMAP::iterator w= d_M.insert(pr2).first;
      d_M.extra(w).iter() = w.d_w;
      d_M.forceIntoSecond(w);
    } else {
      p.Removetip();
      p -= (*w).second.first;
      todo = true;
    };
  }; // while(todo&&!p.zero()) 
};

void SFSGPolySource::remove(const RuleID &) {
 DBG();
};

void SFSGPolySource::goforit(const BIMAP::PAIR  & r1,
    const BIMAP::PAIR & r2,list<Polynomial> & polys) {
  MatcherMonomial matcher;
  list<Match> L;
  if(UserOptions::s_UseSubMatch) {
     matcher.subMatch(r1.first,777,r2.first,777,L);
   };
   matcher.overlapMatch(r1.first,888,r2.first,888,L);
   typedef list<Match>::const_iterator LI;
   LI w2 = L.begin(), e2 = L.end();
   if(w2!=e2) {
     Polynomial result,temp;
     while(w2!=e2) { 
       const Match & aMatch = *w2;
#ifdef SFSG_DEBUG
       GBStream << "MXS: MatchL1 " << aMatch.const_left1() 
                << " Middle:" << r1.second.first 
                << " MatchR1: " << aMatch.const_right1() << '\n';
#endif
       result.doubleProduct(aMatch.const_left1(),
                            r1.second.first,
                            aMatch.const_right1());
#ifdef SFSG_DEBUG
       GBStream << "MXS:result " << result << '\n';
       GBStream << "MXS: MatchL2 " << aMatch.const_left2() 
                << " Middle " << r2.second.first 
                << " MatchR2: " << aMatch.const_right2() << '\n';
#endif
       temp.doubleProduct(aMatch.const_left2(),
                           r2.second.first,
                           aMatch.const_right2());
#ifdef SFSG_DEBUG
       GBStream << "MXS:temp " << temp << '\n';
#endif
       result -= temp;
#ifdef SFSG_DEBUG
       GBStream << "MXS:final result " << result << '\n';
#endif
       if(!result.zero()) { polys.push_back(result);};
       ++w2;
     }; //while(w2!=e2) 
   }; // if(w2!=e2) 
};

void SFSGPolySource::fillForUnknownReason() {
  list<Polynomial> polys;
  bool firstmarked;
  if(d_M.second_begin()!=d_M.second_end()) {
    GBStream << "SFSGPolySource::fillForUnknownReason() called with "
             << "nonempty set\n\n";
    d_M.print(GBStream);
    DBG();
  };
  BIMAP::const_iterator w1 = d_M.first_begin(), e1 = d_M.first_end();
  while(w1!=e1) {
    const BIMAP::PAIR & pr1 = *w1;
    firstmarked = pr1.second.second.touched();
    BIMAP::const_iterator w2 = d_M.first_begin(), e2 = d_M.first_end();
    while(w2!=e2) {
      const BIMAP::PAIR & pr2 = *w2;
      if(firstmarked || pr2.second.second.touched()) goforit(pr1,pr2,polys);
      ++w2;
    };
    ++w1;
  };
  list<Polynomial>::const_iterator w3 =  polys.begin(), e3 =  polys.end();
  Monomial m;
  while(w3!=e3) {
#ifdef SFSG_DEBUG_EASY
    GBStream << "Adding fact " << *w3 << '\n';
#endif
    SFSGPolySource::insert(*w3);
    ++w3;
  };
#ifdef SFSG_DEBUG_EASY
  GBStream << "At the end of fill:\n";
  d_M.print(GBStream);
#endif
};

void SFSGPolySource::print(MyOstream & os) const {
  d_M.print(os);
};

void SFSGPolySource::setPerm(int) {};

void SFSGPolySource::setNotPerm(int) {
 DBG();
};

#include "idValue.hpp"
#include "StartEnd.hpp"
const int SFSGPolySource::s_ID = idValue("SFSGPolySource::s_ID");
