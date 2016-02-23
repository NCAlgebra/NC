// SizeList.h

#ifndef INCLUDED_SIZELIST_H
#define INCLUDED_SIZELIST_H

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

template<class T>
class SizeList {
  int d_size;
  list<T> d_L;
public:
  SizeList() : d_size(0), d_L() {};
  SizeList(const SizeList & x) : d_size(x.d_size), d_L(x.d_L) {};
  explicit SizeList(const list<T> & x) : d_size(x.size()), d_L(x) {};
  ~SizeList() {};
  void operator =(const SizeList & x) {
    d_size = x.d_size; d_L = x.d_L;
  };
  void push_back(const T & t) {
    ++d_size;
    d_L.push_back(t);
  };
  bool empty() const { return d_size==0;};
  int size() const { return d_size;};
  typename list<T>::const_iterator begin() const { return d_L.begin();};
  typename list<T>::const_iterator end() const { return d_L.end();};
  void pop_front() { d_L.pop_front();--d_size;};
  const list<T> & LIST() const { return d_L;};
  void clear() { d_L.erase(d_L.begin(),d_L.end()); d_size = 0;};
};
#endif
