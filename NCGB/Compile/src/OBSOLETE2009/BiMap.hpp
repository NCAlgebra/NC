// Mark Stankus 1999 (c)
// BiMap.hpp

#ifndef INCLUDED_BIMAP_H
#define INCLUDED_BIMAP_H

#include <assert.h>
#include "MyOstream.hpp"
#include "Debug1.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

template<class K,class T,class Extra>
struct BiTriple {
  K d_k;
  T d_t;
  Extra d_e;
  Triple(const K& k,const T & t,const Extra & e) :
         d_k(k), d_t(t), d_e(e) {};
  ~Triple(){};
};

template<class K,class T,class Extra,class Compare>
class BiMap {
  static void errorh(int);
  static void errorc(int);
  typedef list<BiTriple> LIST;
  LIST d_FIRST;
  LIST d_LAST;
public:
  BiMap() : d_FIRST(),d_LAST(){};
  ~BiMap(){};
  class iterator {
  public:
    list<BiTriple<K,T,Extra> >::iterator d_w;
    iterator() : d_w() {};
    iterator(list<BiTriple<K,T,Extra>::iterator w) : d_w(w) {};
    iterator(const iterator & x) : d_w(x.d_w) {};
    bool operator==(const iterator & w) const { return d_w==w.d_w;}
    bool operator!=(const iterator & w) const { return d_w!=w.d_w;}
    void operator++() { ++d_w;};
    const K & key() const { return (*w).d_k;};
    const T & item() const { return (*w).d_t;};
    const Extra & extra() const { return (*w).d_t;};
    pair<const K,pair<T,Extra> > & operator *() {
      return *d_w;
    };
  };
  class const_iterator {
  public:
    map<K,pair<T,Extra>,Compare>::const_iterator d_w;
    const_iterator() : d_w() {};
    const_iterator(map<K,pair<T,Extra>,Compare>::const_iterator w) : d_w(w) {};
    const_iterator(map<K,pair<T,Extra>,Compare>::iterator w) : d_w(w) {};
    const_iterator(iterator w) : d_w(w.d_w) {};
    const_iterator(const const_iterator & x) : d_w(x.d_w) {};
    bool operator==(const const_iterator & w) const { return d_w==w.d_w;}
    bool operator!=(const const_iterator & w) const { return d_w!=w.d_w;}
    void operator++() { ++d_w;};
    const pair<const K,pair<T,Extra> > & operator *() const {
      return *d_w;
    };
  };
  const_iterator first_begin() const {
    return  const_iterator(d_S.begin());
  };
  iterator first_begin() {
    return  iterator(d_S.begin());
  };
  const_iterator first_end() const {
    if(d_S.begin()!=d_S.end() && !checkIter(d_iter)) errorh(__LINE__);
    return  const_iterator(d_iter);
  };
  iterator first_end() {
    if(d_S.begin()!=d_S.end() && !checkIter(d_iter)) errorh(__LINE__);
    return  iterator(d_iter);
  };
  const_iterator second_begin() const {
    if(!checkIter(d_iter)) errorh(__LINE__);
    return  const_iterator(d_iter);
  };
  iterator second_begin() {
    if(!checkIter(d_iter)) errorh(__LINE__);
    return  iterator(d_iter);
  };
  const_iterator second_end() const {
    return  const_iterator(d_S.end());
  };
  iterator second_end() {
    return  iterator(d_S.end());
  };
  const_iterator begin(int i) const {
    if(i==1) return first_begin();
    assert(i==2);
    return second_begin();
  };
  iterator begin(int i) {
    if(i==1) return first_begin();
    assert(i==2);
    return second_begin();
  };
  const_iterator end(int i) const {
    if(i==1) return first_begin();
    assert(i==2);
    return second_begin();
  };
  iterator end(int i) {
    if(i==1) return first_begin();
    assert(i==2);
    return second_begin();
  };
  iterator  ITER() {
    if(!checkIter(d_iter)) errorh(__LINE__);
    return iterator(d_iter);
  };
  void ITER(iterator& x) {
    if(!checkIter(x.d_w)) errorh(__LINE__);
    d_iter = x.d_w;
  };
  const K & key(const_iterator & w) const { 
    if(!checkIter(w.d_w)) errorh(__LINE__);
    return (*w).first;
  };
  const T & item(const_iterator & w) const { 
    if(!checkIter(w.d_w)) errorh(__LINE__);
    return (*w).second.first;
  };
  const T & item(iterator & w) const { 
    if(!checkIter(w.d_w)) errorh(__LINE__);
    return (*w).second.first;
  };
  T & item(iterator & w) { 
    if(!checkIter(w.d_w)) errorh(__LINE__);
    return (*w).second.first;
  };
  const Extra & extra(const_iterator & w) const { 
    if(!checkIter(w.d_w)) errorh(__LINE__);
    return (*w).second.second;
  };
  Extra & extra(iterator & w) { 
    if(!checkIter(w.d_w)) errorh(__LINE__);
    return (*w).second.second;
  };
  void forceIntoFirst(iterator & w) {
    if(!checkIter(d_iter)) errorh(__LINE__);
    if(!checkIter(w.d_w)) errorh(__LINE__);
    if(d_iter==d_S.begin()) {
      // The first map is empty
      d_iter = w.d_w;
    } else if(d_iter==d_S.end()) {
      // The second map is empty -- do nothing
    } else if(d_S.key_comp()((*d_iter).first,(*w).first)) {
      d_iter = w.d_w;
    };
    if(!checkIter(d_iter)) errorh(__LINE__);
  };
  void forceIntoSecond(iterator & w) {
    if(!checkIter(w.d_w)) errorh(__LINE__);
    if(d_iter==d_S.end()) {
      // The second map is empty
      d_iter = w.d_w;
    } else if(d_iter==d_S.begin()) {
      // The first map is empty -- do nothing
    } else if(d_S.key_comp()((*w).first,(*d_iter).first)) {
      d_iter = w.d_w;
    };
    if(!checkIter(d_iter)) errorh(__LINE__);
  };
  bool first_empty() const {
    if(!checkIter(d_iter)) errorh(__LINE__);
    return d_S.begin()==d_iter;
  };
  bool second_empty() const {
    if(!checkIter(d_iter)) errorh(__LINE__);
    return d_S.end()==d_iter;
  };
  void flip_first_second() { 
    if(!checkIter(d_iter)) errorh(__LINE__);
    --d_iter;
    if(!checkIter(d_iter)) errorh(__LINE__);
  }
  void flip_second_first() { 
    if(!checkIter(d_iter)) errorh(__LINE__);
    ++d_iter;
    if(!checkIter(d_iter)) errorh(__LINE__);
  }
  void print(MyOstream & os) const {
    if(d_S.begin()!=d_S.end() && !checkIter(d_iter)) errorh(__LINE__);
    MAPTYPE::const_iterator w = d_S.begin(), e = d_S.end();
    if(w==d_iter) {
      os << "First map empty\n";
    } else {
      os << "First map:\n";
      while(w!=d_iter) {
        const PAIR & pr = *w;
        os << "Key: " << pr.first 
           << " primary-value: " << pr.second.first
           << " secondary-value: " << pr.second.second << '\n';
        ++w;
      };
    };
    if(e==d_iter) {
      os << "Second map empty\n";
    } else {
      os << "Secondmap:\n";
      while(w!=e) {
       const PAIR & pr = *w;
        os << "Key: " << pr.first 
           << " primary-value: " << pr.second.first
           << " secondary-value: " << pr.second.second << '\n';
        ++w;
      };
    };
  };
  iterator find(const K & k) {
    if(d_S.begin()!=d_S.end() && !checkIter(d_iter)) errorh(__LINE__);
    return iterator(d_S.find(k));
  };
  pair<iterator,bool> insert(const PAIR & x) {
    if(d_S.begin()!=d_S.end() && !checkIter(d_iter)) errorh(__LINE__);
    pair<iterator,bool> result;
    pair<MAPTYPE::iterator,MAPTYPE::iterator> pr = d_S.equal_range(x.first);
    if(pr.first==pr.second) {
      // Already there?
      errorh(__LINE__);
    } else {
      if(d_iter==d_S.begin()) {
        // first set is empty 
        pair<MAPTYPE::iterator,bool> pr2(d_S.insert(x));
        result.first = iterator(pr.first);
        result.second = pr2.second;
        d_iter = pr.first;
      } else if(d_iter==d_S.end()) {
        // second set is empty 
        pair<MAPTYPE::iterator,bool> pr2(d_S.insert(x));
        result.first = iterator(pr.first);
        result.second = pr2.second;
        d_iter = d_S.end();
      } else {
        pair<MAPTYPE::iterator,bool> pr2(d_S.insert(x));
        result.first = iterator(pr.first);
        result.second = pr2.second;
      };
      checkIter(d_iter);
      checkIter(result.first.d_w);
    };
    print(GBStream);
    if(d_S.begin()!=d_S.end() && !checkIter(d_iter)) errorh(__LINE__);
    return result;
  };
  void erase(const iterator & w) {
    if(d_S.begin()!=d_S.end() && !checkIter(d_iter)) errorh(__LINE__);
    if(!checkIter(w.d_w)) errorh(__LINE__);
    if(w.d_w==d_iter) ++d_iter;
    d_S.erase(w.d_w);
    if(d_S.begin()!=d_S.end() && !checkIter(d_iter)) errorh(__LINE__);
    print(GBStream);
  };
  pair<iterator,iterator> equal_range(const K & x) {
    return d_S.equal_range(x);
  };
  bool checkIter(const MAPTYPE::iterator & x) const {
    BiMap * alias = const_cast<BiMap *>(this);
    MAPTYPE::iterator w = alias->d_S.begin(), e = alias->d_S.end();
    bool found = false;
    while(w!=e && !found) {
      found = w==x;
    };
    return found;
  };
  bool checkIter(const MAPTYPE::const_iterator & x) const {
    MAPTYPE::const_iterator w = d_S.begin(), e = d_S.end();
    bool found = false;
    while(w!=e && !found) {
      found = w==x;
    };
    return found;
  };
};
#endif
