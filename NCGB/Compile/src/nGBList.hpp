// (c) Mark Stankus 1999
// GBList.h

#ifndef INCLUDED_GBLIST_H
#define INCLUDED_GBLIST_H

#include "intpair.hpp"
#include "GBListError.hpp"

#include "RecordHere.hpp"
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
using namespace std;
#include <algorithm>
#include "Copy.hpp"
#include "Newing.hpp"

template<class T>
class GBList {
  Copy<list<T> > d_L;
  int d_sz, d_num_iterator, d_num_const_iterator;
public:
  class const_iterator;
  class iterator;
  GBList() : d_L(), d_sz(0), d_num_iterator(0), d_num_const_iterator(0) {
    list<T> L;
    d_L = L;
  };
  GBList(const GBList<T> & x) : d_L(x.d_L), d_sz(x.d_sz), d_num_iterator(0), d_num_const_iterator(0) {};
  ~GBList() {};
  // Delayed copying
  bool operator == (const GBList<T> & x) const {
    return d_sz==x.d_sz && d_L()==x.d_L();
  };
  void operator = (const GBList<T> & x) {
    d_L = x.d_L;
    d_sz = x.d_sz;
  };
  bool operator != (const GBList<T> & x) const {
    return !operator==(x);
  };
  int size() const {
    return d_sz;
  };
  bool empty() const {
    return d_sz==0;
  };
  intpair Member(const T & x) const {
    intpair result;
    result.first(false);
    result.second(-1);
    typename list<T>::const_iterator w = d_L().begin();
    const int sz = d_L().size();
    for(int i=1;i<=sz;++i,++w) {
      if(*w==x) {
	result.first(true);
	result.second(i);
	break;
      };
    };
    return result;
  };
  void DeepCopy() {
    d_L.makeUnique();
  };
  void push_back(const T & x) {
    d_L.access().push_back(x);
    ++d_sz;
  };
  void addElement(const T & x, int index) {
    d_L.access();
    typename list<T>::iterator w = d_L.mustBeAlone().begin();
    for(int i=2;i<=index;++i,++w) {};
    d_L.mustBeAlone().insert(w,x);
    ++d_sz;
  };
  void removeElement(int index) {
    d_L.access();
    typename list<T>::iterator w = d_L.mustBeAlone().begin();
    for(int i=2;i<=index;++i,++w) {};
    d_L.mustBeAlone().erase(w);
    --d_sz;
  };
  void pop_front() {
    d_L.access();
    d_L.mustBeAlone().erase(d_L.mustBeAlone().begin());
    --d_sz;
  };
  void joinTo(const GBList<T> & x) {
    if(this==&x) GBListError::errorh(__LINE__);
    GBList<T> * alias = const_cast<GBList<T> *>(&x);
    d_L.makeUnique();
    alias->d_L.makeUnique();
    typedef typename list<T>::const_iterator LI;
    LI w = alias->d_L().begin(), e = alias->d_L().end();
    while(w!=e) {
      d_L.mustBeAlone().push_back(*w);
      ++w; ++d_sz;
    };
  };
  void insertIfNotMember(const T & x) {
    d_L.access();
    typename list<T>::iterator f = find( d_L.mustBeAlone().begin(),d_L.mustBeAlone().end(),x);
    if(f==d_L.mustBeAlone().end()) {
      d_L.mustBeAlone().push_back(x); 
      ++d_sz;
    };
  };
  void clear() {
    d_L.access();
    d_L.mustBeAlone().erase(d_L.mustBeAlone().begin(),d_L.mustBeAlone().end());
    d_sz = 0;
  };
  void removeDuplicates() {
    list<T> temp(d_L());
    d_L.access();
    d_L.mustBeAlone().erase(d_L.mustBeAlone().begin(),d_L.mustBeAlone().end());
    d_sz = 0;
    typename list<T>::iterator f,Beg,End;
    typedef typename list<T>::const_iterator LI;
    LI w  = temp.begin(), e = temp.end();
    while(w!=e) {
      Beg = d_L.mustBeAlone().begin();
      End = d_L.mustBeAlone().end();
      f = find(Beg,End,*w);
      if(f==End) {
	d_L.mustBeAlone().push_back(*w);
	++d_sz;
      };      
      ++w;
    };
    d_L.mustBeAlone() = temp;
  };
  void addConstIterator(const const_iterator *) {
    ++d_num_const_iterator;
  };
  void removeConstIterator(const const_iterator *) {
    --d_num_const_iterator;
  };
  void addIterator(const iterator *) {
    ++d_num_iterator;
  };
  void removeIterator(const iterator *) {
    --d_num_iterator;
  };
  class const_iterator {
    friend class iterator;
    const GBList<T> * d_owner;
    typename list<T>::const_iterator d_w;
  public:
    const_iterator() : d_owner(0), d_w() {
#ifdef USE_UNIX2
      d_w.node = 0;
#endif
    };
    const_iterator(const GBList<T> * owner,
		   typename list<T>::const_iterator w) :
      d_owner(owner), d_w(w) {
      GBList<T> *  alias = const_cast<GBList<T> *>(d_owner);
      alias->addConstIterator(this);
    };
    const_iterator(const const_iterator & x) : d_owner(x.d_owner), 
					       d_w(x.d_w) {
      if(d_owner)  {
        GBList<T> *  alias = const_cast<GBList<T> *>(d_owner);
        alias->addConstIterator(this);
      };
    };
    ~const_iterator() {
      if(d_owner) {
	GBList<T> *  alias = const_cast<GBList<T> *>(d_owner);
	alias->removeConstIterator(this);
      };
    };
    void operator=(const const_iterator & x){ 
      d_owner = x.d_owner;
      d_w = x.d_w;
      if(d_owner)  {
        GBList<T> *  alias = const_cast<GBList<T> *>(d_owner);
        alias->removeConstIterator(this);
        alias->addConstIterator(this);
      };
    };
    const_iterator(iterator x) : d_owner(x.owner()),
				 d_w(x.place()) {
      if(d_owner) {
        GBList<T> *  alias = const_cast<GBList<T> *>(d_owner);
        alias->addConstIterator(this);
      };
    };
    void operator++() {
      if(!d_owner) GBListError::errorh(__LINE__);
      ++d_w;
    };
    void operator--() {
      if(!d_owner) GBListError::errorh(__LINE__);
      --d_w;
    };
    const T & operator *() const {
      if(!d_owner) GBListError::errorh(__LINE__);
      return *d_w;
    };
    void advance(int i) {
      if(!d_owner) GBListError::errorh(__LINE__);
      for(int j=1;j<=i;++j,++d_w) {};
    };
    bool operator==(const const_iterator & x) const {
      return d_owner==x.d_owner && d_w==x.d_w;
    };
    bool operator!=(const const_iterator & x) const {
      return !operator==(x);
    };
  };
  class iterator {
    GBList<T> * d_owner;
    typename list<T>::iterator d_w;
  public:
    iterator() : d_owner(0),d_w() { 
#ifdef USE_UNIX2
      d_w.node = 0;
#endif
    };
    iterator(GBList<T> * owner,typename list<T>::iterator w) :
      d_owner(owner), d_w(w) {
      GBList<T> *  alias = const_cast<GBList<T> *>(d_owner);
      alias->addIterator(this);
    };
    ~iterator() {
      if(d_owner) {
        GBList<T> *  alias = const_cast<GBList<T> *>(d_owner);
        alias->removeIterator(this);
      };
    };
    void operator=(const iterator & x) {
      d_owner = x.d_owner;
      d_w = x.d_w;
      if(d_owner)  {
        GBList<T> *  alias = const_cast<GBList<T> *>(d_owner);
        alias->removeIterator(this);
        alias->addIterator(this);
      };
    };
    void operator++() {
      if(!d_owner) GBListError::errorh(__LINE__);
      ++d_w;
    };
    void operator--() {
      if(!d_owner) GBListError::errorh(__LINE__);
      --d_w;
    };
    const T & operator *() const {
      if(!d_owner) GBListError::errorh(__LINE__);
      return *d_w;
    };
    T & operator *() {
      if(!d_owner) GBListError::errorh(__LINE__);
      return *d_w;
    };
    void advance(int i) {
      if(!d_owner) GBListError::errorh(__LINE__);
      for(int j=1;j<=i;++j,++d_w) {};
    };
    bool operator==(const iterator & x) const {
       return d_owner==x.d_owner && d_w==x.d_w;
    };
    bool operator!=(const iterator & x) const {
      return !operator==(x);
    };
    const GBList<T> * owner() const { return d_owner;};
    typename list<T>::iterator place() const { return d_w;};
  };
  const_iterator begin() const {
    typename list<T>::const_iterator w = d_L().begin();
    const_iterator result(this,w);
    return result;
  };
  const_iterator end() const {
    typename list<T>::const_iterator w = d_L().end();
    const_iterator result(this,w);
    return result;
  };
  iterator begin() {
    typename list<T>::iterator w = d_L.access().begin();
    iterator result(this,w);
    return result;
  };
  iterator end() {
    typename list<T>::iterator w = d_L.access().end();
    iterator result(this,w);
    return result;
  };
}; 
#endif
