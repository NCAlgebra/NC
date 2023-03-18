// Mark Stankus (c) 1999
// TipDistinct.hpp

#ifndef INCLUDE_TIPDISTINCT_H
#define INCLUDE_TIPDISTINCT_H

#include "Polynomial.hpp"
#include "Monomial.hpp"
#include "ByAdmissible.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#include <set>
#else
#include <map.h>
#include <set.h>
#endif

#define DEBUG_TIPDISTINCT

class TipDistinct {
  map<Monomial,Polynomial,ByAdmissible> d_M;
  typedef map<Monomial,Polynomial,ByAdmissible>::iterator MI;
  typedef map<Monomial,Polynomial,ByAdmissible>::const_iterator MCI;
  map<Monomial,int,ByAdmissible> d_A;
  typedef map<Monomial,int,ByAdmissible>::iterator AI;
  typedef map<Monomial,int,ByAdmissible>::const_iterator ACI;
  typedef set<Monomial,ByAdmissible>::iterator SI;
  typedef set<Monomial,ByAdmissible>::const_iterator SCI;
  bool subtractInsert(const Polynomial & p,const MI & mi,Monomial *ptr,int age) {
#ifdef DEBUG_TIPDISTINCT
    GBStream << "MXS:Looking at " << (*mi).first << " plus " << p << '\n';
#endif
    bool result = false;
    Field f;
    Monomial m;
    Polynomial y(p);
    y -= (*mi).second;
    MI result2;
    while(!y.zero()) {
      f.setToOne();
      f /=  y.tipCoefficient();
      y *= f;
      m = y.tipMonomial();
#ifdef DEBUG_TIPDISTINCT
      GBStream << "MXS:tip is " << m << '\n';
#endif
      y.Removetip();
      result2 = d_M.find(m);
      if(result2==d_M.end()) {
#ifdef DEBUG_TIPDISTINCT
       GBStream << "MXS:reduced to " << y << '\n';
#endif
        pair<const Monomial,Polynomial>pr1(m,y);
        d_M.insert(pr1); 
        if(age!=0) {
          pair<const Monomial,int>pr2(m,age);
          d_A.insert(pr2); 
        };
        result = true;
        if(ptr) *ptr = m;
        break;
      };
      f.setToOne();
      f /=  y.tipCoefficient();
      y *= f;
      y -= (*result2).second;
    }; // while(!y.zero())
#ifdef DEBUG_TIPDISTINCT
    if(result) if(ptr) GBStream << *ptr << '\n';
#endif
    return result;
  };
public:
  TipDistinct() : d_M() {};
  ~TipDistinct() {};
  set<Monomial,ByAdmissible> d_notmatched;
  const map<Monomial,Polynomial,ByAdmissible> & MAP() const { return d_M;};
  const map<Monomial,int,ByAdmissible> & AGE() const { return d_A;};
  void erase(MI & w) { d_M.erase(w);};
  void erase(AI & w) { d_A.erase(w);};
  void erase(const Monomial & m) { 
    MI f1 = d_M.find(m);
    if(f1!=d_M.end()) d_M.erase(f1);
    AI f2 = d_A.find(m);
    if(f2!=d_A.end()) d_A.erase(f2);
  };
  MI find(const Monomial & m) { return d_M.find(m);};
  AI findAge(const Monomial & m) { return d_A.find(m);};
  bool subtractInsert(const pair<const Monomial,Polynomial> & pr,Monomial *ptr,int age=-1) {
#ifdef DEBUG_TIPDISTINCT
    GBStream << "MXS:Looking at " << pr.first << " plus " << pr.second << '\n';
#endif
    bool result;
    MI w = d_M.find(pr.first);
    if(w==d_M.end()) {
#ifdef DEBUG_TIPDISTINCT
       GBStream << "MXS:have " << pr.first << " @ " << pr.second << '\n';
#endif
       d_M.insert(pr); 
       if(age!=0) {
         pair<const Monomial,int> pr2(pr.first,age);
         d_A.insert(pr2); 
       };
       if(ptr) *ptr = pr.first;
       result = true;
    } else {
       result = subtractInsert(pr.second,w,ptr,age);
    };
#ifdef DEBUG_TIPDISTINCT
    if(result) if(ptr) GBStream << *ptr << '\n';
#endif
    return result;
  };
  bool subtractInsert(const Monomial & m,const Polynomial & p,Monomial * ptr,int age =0 ) {
#ifdef DEBUG_TIPDISTINCT
    GBStream << "MXS:Looking at " << m << " plus " << p << '\n';
#endif
    bool result;
    MI w= d_M.find(m);
    if(w==d_M.end()) {
#ifdef DEBUG_TIPDISTINCT
       GBStream << "MXS:have " << m << " @@ " << p << '\n';
#endif
       pair<const Monomial,Polynomial> pr(m,p);
       d_M.insert(pr); 
       if(age!=0) {
         pair<const Monomial,int> pr2(m,age);
         d_A.insert(pr2); 
       };
       if(ptr) *ptr = m;
       result = true;
    } else {
       result = subtractInsert(p,w,ptr,age);
    };
#ifdef DEBUG_TIPDISTINCT
    if(result) if(ptr) GBStream << *ptr << '\n';
#endif
    return result;
  };
  bool subtractInsert(const Polynomial & p,Monomial * ptr,int age =0) {
    bool result = false;
    if(!p.zero()) {
      Field f;
      pair<const Monomial,Polynomial> pr(p.tipMonomial(),p);
      f.setToOne();
      f /= p.tipCoefficient();
      pr.second *= f;
      pr.second.Removetip();
      result = subtractInsert(pr,ptr,age);
    };
#ifdef DEBUG_TIPDISTINCT
    if(result) if(ptr) GBStream << *ptr << '\n';
#endif
    return result;
  };
  void print(MyOstream & os) const {
    MCI w = d_M.begin(), e = d_M.end();
    while(w!=e) {
      const pair<const Monomial,Polynomial> & pr = *w;
      os << pr.first << " + " << pr.second << '\n';
      ++w;
    };
  };
  void printSmall(MyOstream & os) const {
    SCI e1 = d_notmatched.end();
    MCI w = d_M.begin(), e = d_M.end();
    while(w!=e) {
      const pair<const Monomial,Polynomial> & pr = *w;
      if(d_notmatched.find(pr.first)==e1) {
        os << pr.first << " + " << pr.second << '\n';
      };
      ++w;
    };
  };
};
#endif
