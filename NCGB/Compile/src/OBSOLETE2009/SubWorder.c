// Mark Stankus 1999 (c)
// SubWorder.c


#include "SubWorder.hpp"

void SubWorder::print(MyOstream & os) const {
  os << "Monomials:\n";
  LCI w1 = d_L.begin(), e1 = d_L.end();
  int i=0;
  while(w1!=e1) {
    os << i << ") " << (*w1).first << '\n';
    ++w1;++i;
  };
  os << "\n\nVARMAP:\n";
  typedef VARMAP::const_iterator VI;
  VI w2 = d_first.begin(), e2 = d_first.end();
  while(w2!=e2) {
    const pair<const Variable,LI> & pr = *w2;
    os << pr.first << ' ' << (*(pr.second)).first << '\n';
    ++w2;
  };
  os << "\n\nARROWS:\n";
  w1 = d_L.begin(), e1 = d_L.end();
  i=0;
  while(w1!=e1) {
    const pair<const Monomial,MAP> & pr = *w1;
    const Monomial & mono = pr.first;
    const MAP & map= pr.second;
    MAP::const_iterator mapi = map.begin(), mape = map.end();
    MonomialIterator mw = mono.begin(), me = mono.end();
    int place = 0;
    while(mw!=me) {
      os << *mw << ' ';
      while(mapi!=mape && (*mapi).first.d_n==place) {
        os << "(var:" << (*mapi).first.d_v 
           << " which:" 
           << " place:" << (*mapi).second.d_n << ") ";
        ++mapi;
      };
      ++mw;++place;
    };
    os << '\n';
    ++w1;++i;
  };
};

void SubWorder::addWord(LI w,const Monomial & x) {
  const Variable & v = *x.begin();
  MAP map;
  pair<const Monomial,MAP> pr(x,map);
  d_L.insert(w,pr);
  LI ww = w;
  --ww;
  bool first_done = false;
  VARMAP::iterator first_iter = d_first.find(v);
  LI where_first;
  if(first_iter==d_first.end()) {
    pair<Variable,LI> pr(v,ww);
    d_first.insert(pr);
    first_done = true;
  } else {
    where_first = (*first_iter).second;
  };
  LI www = d_L.begin();
  while(www!=ww) {
    const Monomial & mono = (*www).first;
    if(!first_done) {
      if(www==where_first) first_done = true;
    };
    addMonomialArrows(www,*mono.begin(),mono,w,v,x);
    ++www;
  };
  if(!first_done) {
    pair<const Variable,LI> pr(v,ww);
    d_first.insert(pr);
  };
  LI e = d_L.end();
  ++www;
  while(www!=e) {
    const Monomial & mono = (*www).first;
    addMonomialArrows(w,v,x,www,*mono.begin(),mono);
    ++www;
  };
};

void SubWorder::removeword(const LI & x) {
  const pair<const Monomial,MAP> & pr = (*x);
  const Monomial & mono = pr.first;
  VARMAP::const_iterator where_first = d_first.find(*mono.begin());
  if(where_first==d_first.end()) DBG();
  if((*where_first).second==x) {
    DBG();
  };
  vector<list<pair<Variable,JumpTo> * > >  L;
  grabArrowsFrom(L);
  LI w = d_L.begin(), e = d_L.end();
  while(w!=x) {
    MAP & map = (*w).second;
    MAP::iterator ww = map.begin(),ee = map.end();
    while(ww!=ee) {
      const pair<JumpData,JumpTo> & pr = (*ww);
      const JumpTo & jt = pr.second;
      if(jt.d_w==x) {
        DBG();
      };
      ++ww;
    };
    ++w;
  };
  w = d_L.begin(), e = d_L.end();
  while(w!=e) {
    MAP & m = (*w).second;
    MAP::iterator ww = m.begin(), ee = m.end();
    bool todo = true;
    while(todo) {
      todo = false;
      while(ww!=ee) {
        const JumpTo & jt = (*ww).second;
        if(jt.d_w==x) { m.erase(ww); todo = true; break;}
        ++ww;
      };
    };
  };
  d_L.erase(x);
};

void SubWorder::findDivisors(list<SPI> & spi,const Monomial & mono)  {
  DBG();
};

void SubWorder::addMonomialArrows(
     LI & x1,const Variable & v1,const Monomial & m1,
     const LI & x2,const Variable & v2,const Monomial & m2) {
   MonomialIterator w1 = m1.begin();
   const MonomialIterator e1 = m1.end(), e2 = m2.end();
   int m = 1;
   while(w1!=e1) {
     if(*w1==v2) {
       int n = m;
       MonomialIterator w11 = w1, w2 = m2.begin();
      while(w11!=e1 && w2!=e2&& (*w11)==(*w2)) { ++w11; ++w2;};
      if(w11==e1) {
        if(w2==e2) {
          GBStream << "Subworder corrupted. One monomial divides another.\n";
          DBG();
        } else {
          JumpTo j(x2,n,w2);
          JumpData jd(n,(*w2));
          pair<JumpData,JumpTo> pr2(jd,j);
          (*x1).second.insert(pr2);
        };
      } else if (w2==e2) {
        // do nothing
      } else if (*w11!=*w2) {
        // have a mismatch
        JumpTo j(x2,n,w2);
        JumpData jd(n,(*w2));
        pair<JumpData,JumpTo> pr2(jd,j);
        (*x1).second.insert(pr2);
      } else DBG();
      ++w1;++n;
    } else {
      ++w1;++m;
    };
  };
};
