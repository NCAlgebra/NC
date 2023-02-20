// Mark Stankus 1999 (c)
// SFSGRules.h

#ifndef INCLUDED_SFSGRULES_H
#define INCLUDED_SFSGRULES_H

#include "Monomial.hpp"
#include "GeneralMora.hpp"
#include "Polynomial.hpp"
#include "AdmissibleOrder.hpp"
#include "MatcherMonomial.hpp"
#include "GBMatch.hpp"
#include "GBStream.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#include <set>
#else
#include <list.h>
#include <set.h>
#endif

//#define SLOW
//#define NO_CLEANUP

struct SFSGEntry {
  SFSGEntry(const Monomial & m,const Polynomial & p)  :
        d_tip(m), d_rest(p), d_next_same_tip(false) {};
  Monomial d_tip;
  Polynomial d_rest;
  bool d_next_same_tip;
  void print(MyOstream & os) {
    os << d_tip << " + " << d_rest  << ' '
       << (d_next_same_tip ? "true" : "false") << '\n';

  };
};

struct SFSGHelper {
  bool operator()(const list<SFSGEntry*>::iterator & x,
                  const list<SFSGEntry*>::iterator & y) const {
    return (*x) < (*y);
  };
};

class SFSGRules {
  static void errorh(int);
  static void errorc(int);
  typedef list<SFSGEntry *> LIST;
  typedef list<SFSGEntry *>::const_iterator LCI;
  typedef list<SFSGEntry *>::iterator LI;
  typedef set<LI,SFSGHelper> SET;
  typedef set<LI,SFSGHelper>::const_iterator SCI;
  typedef set<LI,SFSGHelper>::iterator SI;
  SET d_recent;
  LIST d_L;
  LI insert(SFSGEntry * ptr) {
    LI w = d_L.begin(), e = d_L.end();
    const Monomial & m = ptr->d_tip;
    while(w!=e) {
      const Monomial & x = (*w)->d_tip;
      if(AdmissibleOrder::s_getCurrent().monomialLess(m,x))  break;
      ++w;
    };
    if(w!=e) {
      const Monomial & x = (*w)->d_tip;
      if(x==m) {
        ptr->d_next_same_tip = true;
        GBStream << "Same:" << *w << ptr << '\n';
        (*w)->print(GBStream);
        ptr->print(GBStream);
      };
    };
    return d_L.insert(w,ptr);
  };
  bool erase(list<SFSGEntry*>::iterator x) { 
    SI w = d_recent.find(x);
    bool result = w!=d_recent.end();
    if(result) d_recent.erase(w);
    d_L.erase(x);
    checkRecent();
    return result;
  };
  LI d_current;
  bool d_current_valid;
public:
  SFSGRules() : d_current(), d_current_valid(false) {};
  ~SFSGRules(){};
  int size() const { return d_L.size();};
  bool isend(LI w) const { 
    inList(w);
    return d_L.end()==w;
  };
  void clearRecent() {
    d_recent.erase(d_recent.begin(),d_recent.end());
    checkRecent();
  };
  void markRecent(LI & w) {
    inList(w);
GBStream << "Marking recent: ";(*w)->print(GBStream);
    d_recent.insert(w);
    checkRecent();
  };
  LI current() { 
    LI result = d_current;
    if(!d_current_valid) d_current = d_L.end();
    return result;
  };
  void markAllRecent() {
    LI w = d_L.begin(), e = d_L.end();
    while(w!=e) {
      d_recent.insert(w);
      ++w;
    };
    checkRecent();
    d_current = d_L.begin();
    d_current_valid = true;
  };
  bool prepareSafeReduce() {
    d_current_valid = false;
    LI w = d_L.begin();
    if(w!=d_L.end()) {
      ++w; // the first element automatically reduced
      if(w!=d_L.end()) {
        d_current = w;
        d_current_valid = true;
      };
    };
    return d_current_valid;
  };
  void goforit(const LI & x,const LI & y,list<Polynomial> & POLYS) {
    SFSGEntry * p1 = *x;
    SFSGEntry * p2 = *y;
    MatcherMonomial matcher;
    list<Match> L;
    if(UserOptions::s_UseSubMatch) {
      matcher.subMatch(p1->d_tip,777,p2->d_tip,777,L);
    };
    matcher.overlapMatch(p1->d_tip,888,p2->d_tip,888,L);
    typedef list<Match>::const_iterator MLI;
    MLI w2 = L.begin(), e2 = L.end();
    if(w2!=e2) {
      ++s_number_of_spolynomials;
      Polynomial result,temp;
      while(w2!=e2) { 
        const Match & aMatch = *w2;
#ifdef SFSG_DEBUG
        GBStream << "MXS: MatchL1 " << aMatch.const_left1() 
                 << " Middle:" << p1->rest
                 << " MatchR1: " << aMatch.const_right1() << '\n';
#endif
        result.doubleProduct(aMatch.const_left1(),
                             p1->d_rest,
                             aMatch.const_right1());
#ifdef SFSG_DEBUG
        GBStream << "MXS:result " << result << '\n';
        GBStream << "MXS: MatchL2 " << aMatch.const_left2() 
                 << " Middle " << p2->d_rest
                 << " MatchR2: " << aMatch.const_right2() << '\n';
#endif
        temp.doubleProduct(aMatch.const_left2(),
                            p2->d_rest,
                            aMatch.const_right2());
#ifdef SFSG_DEBUG
        GBStream << "MXS:temp " << temp << '\n';
#endif
        result -= temp;
#ifdef SFSG_DEBUG
        GBStream << "MXS:final result " << result << '\n';
#endif
        POLYS.push_back(result);
        ++w2;
      }; //while(w2!=e2) 
    }; // if(w2!=e2) 
  }; 
  bool fill() {
    d_current_valid = false;
#ifdef SFSG_DEBUG
    GBStream << "Fill:\n";
    printRecent(GBStream);
#endif
    list<Polynomial> L;
    d_current_valid = false;
#ifdef SFSG_DEBUG
    GBStream << "Processing " << d_recent.size() << " entries\n";
#endif
    if(!d_recent.empty()) {
      bool recent2;
      SFSGEntry * curr2 =0;
      SFSGEntry * curr3 =0;
      LI w2 = d_L.begin(), e2 = d_L.end();
      while(w2!=e2) {
        curr2 = *w2;
        recent2 = d_recent.find(w2)!=d_recent.end();
#ifdef SFSG_DEBUG
        if(recent2) {
          GBStream << "MXS: The following is recent:";
          curr2->print(GBStream);
          GBStream << '\n';
        };
#endif
        LI w3 = d_L.begin(), e3 = w2;
        while(w3!=e3) {
          curr3 = *w3;
          if(recent2 || d_recent.find(w3)!=d_recent.end()) {
            goforit(w2,w3,L);
            goforit(w3,w2,L);
          };
          ++w3;
        }; // loop handles nondiagonal elements
        if(recent2) goforit(w2,w2,L); // handle diagonal element
        ++w2;
      }; // while(w2!=e2) 
    }; 
    clearRecent();
    list<Polynomial>::const_iterator inw = L.begin(), ine = L.end();
    while(inw!=ine) {
      LI ww = insert(*inw);
      inList(ww);
      if(d_current_valid) {
        const Monomial & m = (*d_current)->d_tip;
        const Monomial & n = (*ww)->d_tip;
        if(!AdmissibleOrder::s_getCurrent().monomialGreater(n,m)) {
          d_current = ww; 
        };
      } else {
        d_current = ww;
        d_current_valid = true;
      };
      ++inw;
    };
    return d_current_valid;
  };
  LI insert(const Monomial & m,const Polynomial & p) {
    SFSGEntry * ptr = new SFSGEntry(m,p);
    return insert(ptr);
  };
  LI insert(const Polynomial & p) {
    LI result = d_L.end();
    if(!p.zero()) {
      Polynomial q(p);
      q.makeMonic();
      Monomial m(q.tipMonomial());
      q.Removetip();
      result = insert(m,q);
      inList(result);
    };
    return result;
  };
  bool dumbReduction(list<SFSGEntry *>::iterator & x,bool markit) {
#ifdef SFSG_DEBUG
    print(GBStream);
#endif
    ++s_number_of_reductionstar;
    list<SFSGEntry *>::iterator xxx(x);++xxx;
    SFSGEntry * curr = *x;
#ifdef DEBUG_SFSG_EASY
GBStream << "Reducing "; curr->print(GBStream); GBStream << '\n';
#endif
    bool wasMarked = erase(x);
    bool isZero = false, isReduced = false;
    okReduction(xxx,curr,isReduced,isZero);
    if(!isReduced) {
      x = d_L.insert(xxx,curr);
      if(wasMarked) d_recent.insert(x);
      ++x;
      // points past curr
    } else if(!isZero) {
      // it is reduced, but not to zero.
      x = insert(curr); 
      if(markit) d_recent.insert(x);
#ifdef NO_CLEANUP
      x = xxx;
#else
      ++x;
#endif
      // points past curr
    } else {
      // it is reduced to zero.
      delete curr;
      x = xxx;
      // points PAST where curr was
    }; 
#ifdef SFSG_DEBUG
    GBStream << "Finally:\n";
    GBStream << "Final results:\n";
    GBStream << "isZero:" << isZero << '\n';
    GBStream << "isReduced:" << isReduced << '\n';
    GBStream << "current:"; curr->print(GBStream);GBStream << '\n';
#endif
    return !isZero;
  };
  // xxx points one after where the iterator should be inserted
  void okReduction(list<SFSGEntry *>::iterator & xxx,SFSGEntry * curr,
                   bool &isReduced,bool & isZero) {
    d_current_valid = false;
    Polynomial change;
    MatcherMonomial matcher;
    bool todo = true;
    while(todo) {
#ifdef SFSG_DEBUG
      GBStream << "Start:\n";
#endif
      todo = false;
      if(0 /*curr->d_next_same_tip*/) {
#if 0
#ifdef SFSG_DEBUG
        GBStream << "MXS:Same Tip!" << curr->d_tip << "\n";
#endif
        SFSGEntry * next = (*y);
        curr->d_rest -= next->d_rest;
        erase(x);
        if(curr->d_rest.zero()) {
          isReduced = true;
          isZero = true;
          delete curr;
          x = xxx;
          inList(x);
          todo = false;
        } else {
          x = insert(curr);
          markRecent(x); 
          inList(x);
        };
#endif
      } else {
        LI w = d_L.begin(), e = d_L.end();
        if(w!=e) {
          SFSGEntry * q = *w;
          while(AdmissibleOrder::s_getCurrent().monomialLessEqual(
                  q->d_tip,curr->d_tip)) {
#ifdef SFSG_DEBUG
            GBStream << "MXS:Loop\n";
#endif
            if(matcher.matchExists(q->d_tip,curr->d_tip)) {
#ifdef DEBUG_SFSG_EASY
GBStream << "using "; q->print(GBStream); GBStream << '\n';
#endif
              isReduced = true;
              ++s_number_of_reduction_didreduce;
              change.doubleProduct(matcher.matchIs().const_left1(),
                                   q->d_rest,
                                   matcher.matchIs().const_right1());
              curr->d_rest -= change; 
              todo = !curr->d_rest.zero();
              if(curr->d_rest.zero()) {
#ifdef SFSG_DEBUG
GBStream << "have zero\n";
#endif
                isZero = true;
              } else {
                curr->d_rest.makeMonic();
                curr->d_tip = curr->d_rest.tipMonomial();
                curr->d_rest.Removetip();
#ifdef DEBUG_SFSG_EASY
GBStream << "more Reducing "; curr->print(GBStream); GBStream << '\n';
#endif
#ifdef SFSG_DEBUG
GBStream << "have ";curr->print(GBStream);GBStream << " \n";
#endif
              };
              break;
            };
            ++w;
            if(w==e) break;
            q = *w;
          }; // while(AdmissibleOrder:: etc.
        }; // if(w!=e)
      };
    } // while(todo) 
#ifdef SFSG_DEBUG
    GBStream << "Final results:\n";
    GBStream << "isZero:" << isZero << '\n';
    GBStream << "isReduced:" << isReduced << '\n';
    GBStream << "current:"; curr->print(GBStream);GBStream << '\n';
#endif
    if(!isZero) ++s_number_of_reduction_didnotreduce;
  };
  void print(MyOstream & os) {
    LI w = d_L.begin(), e = d_L.end();
    GBStream << d_L.size() << " elements.\n";
    while(w!=e) {
      (*w)->print(GBStream);
      ++w;
    };
    GBStream << "current_valid " 
             << (d_current_valid ? "true" : "false") << '\n';
    if(d_current_valid) {
      (*d_current)->print(GBStream);
    };
    GBStream << "\nMarked(" << d_recent.size() << "):\n";
    SI w2 = d_recent.begin(), e2 = d_recent.end();
    while(w2!=e2) {
      LI t = *w2;
      GBStream << *t << ' ';(*t)->print(GBStream);
      ++w2;
    };
    GBStream << "Done\n";
  };
#ifdef SLOW
  void inList(list<SFSGEntry*>::iterator x) const {
    SFSGRules * alias = const_cast<SFSGRules*>(this);
    list<SFSGEntry*>::iterator w = alias->d_L.begin(), e = alias->d_L.end();
    while(w!=e) {
      if(w==x) break;
      ++w;
    };
    if(w!=x) {
      if(x==e) {
        GBStream << "You have the iterator at the end of the list\n";
      } else {
        GBStream << "You have an iterator which is not on the list\n";
        errorh(__LINE__);
      };
    }; 
  }; 
#else
  void inList(list<SFSGEntry*>::iterator) const {};
#endif
#ifdef SLOW
  void ptrInList(SFSGEntry* x) const {
    SFSGRules * alias = const_cast<SFSGRules*>(this);
    list<SFSGEntry*>::iterator w = alias->d_L.begin(), e = alias->d_L.end();
    while(w!=e) {
      if(*w==x) break;
      ++w;
    };
    if(w==e) {
      GBStream << "You have an invalid pointer.\n";
      errorh(__LINE__);
    };
  }; 
#else
  void ptrInList(SFSGEntry*) const {};
#endif
  void checkRecent() {
#ifdef SLOW
    SI w = d_recent.begin(), e = d_recent.end();
    while(w!=e) {
      inList(*w);
      ++w;
    };
#endif
  };
  void printRecent(MyOstream &os) {
    SI w = d_recent.begin(), e = d_recent.end();
    while(w!=e) {
      LI ww = *w;
      os << *ww << ' ';(*ww)->print(os);
      inList(*w);
      ++w;
    };
  };
  void copyToList(list<Polynomial> & L) {
    Polynomial p,q;
    Term t;
    SFSGEntry * temp = 0;
    LI w = d_L.begin(), e = d_L.end();
    while(w!=e) {
      temp = *w;
      p = temp->d_rest;
      t.assign(temp->d_tip);
      q = t;
      p += q;
      L.push_back(p);
      ++w;
    };
  };
};
#endif
