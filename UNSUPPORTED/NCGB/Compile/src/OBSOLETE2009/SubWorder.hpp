// Mark Stankus 1999 (c)
// SubWorder.hpp

#ifndef INCLUDED_SUBWORDER_H
#define INCLUDED_SUBWORDER_H

#include <pair.h>
#include <list.h>
#include <map.h>
#include "Monomial.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"
#include "SPI.hpp"

class JumpData {
public:
  int d_n;
  Variable d_v;
  JumpData(int n, Variable v) : d_n(n), d_v(v) {};
  bool operator < (const JumpData & x) const {
    return d_n < x.d_n || 
           (d_n==x.d_n && d_v.stringNumber()<x.d_v.stringNumber());
  };
};

struct JumpTo {
  const list<pair<Monomial,map<JumpData,JumpTo> > >::const_iterator & d_w;
  const int d_n;
  const MonomialIterator & d_mi;
  JumpTo(const 
     list<pair<Monomial,map<JumpData,JumpTo> > >::const_iterator
     & w,int n,const MonomialIterator & mi) : d_w(w), d_n(n), d_mi(mi) {
  };
};

class SubWorder {
  typedef map<JumpData,JumpTo,less<JumpData> > MAP;
  typedef list<pair<Monomial,MAP> >::iterator LI;
  typedef list<pair<Monomial,MAP> >::const_iterator LCI;
  typedef list<pair<Monomial,MAP> > LIST;
  typedef map<Variable,LI,CompareOnStringNumber> VARMAP;
  VARMAP d_first;
  LIST d_L;
  void addMonomialArrows(
      LI & x1,const Variable & v1,const Monomial & m1,
      const LI & x2,const Variable & v2,const Monomial & m2);
public:
  SubWorder(){}; 
  ~SubWorder(){}; 
  void addWord(const Monomial & x) {
    addWord(d_L.end(),x);
  };
  void addWord(LI w,const Monomial & x);
  void grabArrowsFrom(vector<list<pair<Variable,JumpTo> * > > & L) {
    L.erase(L.begin(),L.end());
    L.reserve(d_L.size());
    DBG();
  };
  void removeword(const LI & x);
  void findDivisors(list<SPI> & spi,const Monomial & mono);
  void print(MyOstream &) const;
};
#endif
