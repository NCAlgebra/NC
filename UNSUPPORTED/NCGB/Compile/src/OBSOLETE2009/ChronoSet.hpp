// ChronoSet.h

#ifndef INCLUDED_CHRONOSET_H
#define INCLUDED_CHRONOSET_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "triple.hpp"
#include "SPI.hpp"
#include "SPIID.hpp"
#include "GBHistory.hpp"
#include "SelectionOrder.hpp"

#include "vcpp.hpp"

class ChronoSet {
  static void errorh(int);
  static void errorc(int);
  set<int> d_free;
  list<triple<SPI,SPIID,set<int> > > d_list;
  SelectionOrder & d_sel;
public:
  ChronoSet(SelectionOrder & sel) : d_sel(sel) {};
  class const_iterator {
    list<triple<SPI,SPIID,set<int> > >::const_iterator d_w;
  public:
    const_iterator(const list<triple<SPI,SPIID,set<int> > >::const_iterator & w) : d_w(w) {};
    ~const_iterator() {};
    void operator++() { ++d_w;};
    void operator++(int) { ++d_w;};
    const SPI & operator *() const { return (*d_w).first;};
  };
  class iterator {
    list<triple<SPI,SPIID,set<int> > >::iterator d_w;
  public:
    iterator(const list<triple<SPI,SPIID,set<int> > >::iterator & w) : d_w(w) {};
    ~iterator() {};
    void operator++() { ++d_w;};
    void operator++(int) { ++d_w;};
    SPI & operator *() { return (*d_w).first;};
  };
  void insert(const SPI & s,const SPIID & id,const GBHistory & hist) {
    set<int> need;
    int n = abs(hist.first());
    if(n!=0) {
      need.insert(n);
      need.insert(abs(hist.second()));
    };
    GBList<int>::const_iterator w = hist.reductions().SET().begin();
    int sz = hist.reductions().size();
    while(sz) {
      need.insert(*w); ++w; --sz;
    };
    in_place_set_difference(need,d_free);

    triple<SPI,SPIID,set<int> > pr(s,id,need);
    typedef list<triple<SPI,SPIID,set<int> > >::iterator LI;
    typedef set<int>::const_iterator SI;
    LI ww = d_list.begin(), ee = d_list.end();
    while(ww!=ee && !need.empty()) {
      if((*ww).first==s) errorh(__LINE__);
      in_place_set_difference(need,(*ww).third);
      ++w;
    };
    while(ww!=ee && d_sel((*ww).first,s)) { if((*ww).first==s) errorh(__LINE__); ++ww;};
    d_list.insert(ww,pr);
  };
  void in_place_set_difference(set<int> & x,const set<int> & y) {
    typedef set<int>::const_iterator SCI;
    typedef set<int>::iterator SI;
    SI w1 = x.begin(), e1 = x.end(); 
    SCI w2 = y.begin(), e2 = y.end(); 
    if(w1!=e1 && w2!=e2) {
      int n1 = *w1;
      int n2 = *w2;
      while(w1!=e1 && w2!=e2) {
        while(n1!=n2) {
          if(n1<n2) {
            x.erase(w1); 
          if(w1==e1) break;
            n1 = *w1;
          } else {
            ++w2;  
            if(w2==e2) break;
            n2 = *w2;
          };
      };
      };
    };
  };
  void remove(SPI & s,SPIID & id) {
    if(s!=d_list.front().first) errorh(__LINE__);
    d_list.pop_front();
    d_free.insert(id.d_data);
  };
  const_iterator find(const SPI & x) const {
    typedef list<triple<SPI,SPIID,set<int> > >::const_iterator LI;
    LI w = d_list.begin(), e = d_list.end();
    while(w!=e) {
      const SPI & s = (*w).first;
      if(s==x) {
        break;
      };
      ++w;
    };
    return const_iterator(w);
  };
  bool operator()(const SPI & x,const SPI & y) const {
    typedef list<triple<SPI,SPIID,set<int> > >::const_iterator LI;
    LI w = d_list.begin(), e = d_list.end();
    bool result = true;
    while(w!=e) {
      const SPI & s = (*w).first;
      if(s==x) {
        result = true;
        break; 
      } else if(s==y) {
        result = false;
        break; 
      };
      ++w;
    };
   if(w==e) errorh(__LINE__);
    return result;
  };
};
#endif
