// VectorWithHoles.h

#ifndef INCLUDED_VECTORWITHHOLE_H
#define INCLUDED_VECTORWITHHOLE_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include <algorithm>
#include "vcpp.hpp"

template<class T>
class VectorWithHoles {
  VectorWithHoles(const VectorWithHoles &);
    // not implemented
  void operator=(const VectorWithHoles &);
    // not implemented
public:
  VectorWithHoles() {};
  ~VectorWithHoles() {};
  const T & const_reference(int n) const {
    check(n);  
    return d_items[n];
  };
  T & reference(int n) {
    check(n);  
    return d_items[n];
  }; 
  int push(const T & t);
  void makeHole(int n);
private:
  vector<T> d_items;
  vector<int> d_holes;
  void check(int n) const;
};

template<class T>
inline int VectorWithHoles<T>::push(const T & t) {
  int position;
  if(d_holes.size()>0) {
    position = d_holes.back();
    d_items[position] = t;
    d_holes.pop_back();
  } else {
    position = d_items.size();
    d_items.push_back(t);
  };
  return position;
};

template<class T>
inline void VectorWithHoles<T>::makeHole(int n) {
  check(n);
  vector<int>::iterator w = d_holes.begin();
  vector<int>::iterator e = d_holes.end();
  if(find(w,e,n)==e) {
    d_holes.push_back(n);
  };
};
#endif
