// RAList.h

// A list with random access. When push_back is called
// either the element is put in the first hole of 
// is added at the end of the list

#ifndef INCLUDED_RALIST_H
#define INCLUDED_RALIST_H

#pragma warning(disable:4661)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

template<class T>
class RAList {
  RAList(const RAList &);
    // not implemented
  void operator=(const RAList &);
    // not implemented
public:
  RAList();
  ~RAList();
  const T & const_reference(int n) const; 
  T & reference(int n); 
  int push_back(const T & t);
  void makeHole(int n);
private:
  list<T> d_items;
  void check(int n) const;
};

template<class T>
inline RAList<T>::RAList(){};

template<class T>
inline RAList<T>::~RAList(){};

template<class T>
inline const T & RAList<T>::const_reference(int n) const {
  list<T>::const_iterator w = d_items.begin();
  for(int i=2;i<=n;++i,++w) {};
  return * w;
};

template<class T>
inline T & RAList<T>::reference(int n) {
  list<T>::iterator w = d_items.begin();
  for(int i=2;i<=n;++i,++w) {};
  return * w;
};

template<class T>
inline int RAList<T>::push_back(const T & t) {
  int position;
  if(_holes.size()>0) {
    position = * _holes.begin();
    reference(position) = t;
    d_holes.pop_front();
  } else {
    d_items.push_back(t);
    position = d_items.size();
  };
  return position;
};

template<class T>
inline void RAList<T>::makeHole(int n) {
  check(n);
  _holes.insertIfNotMember(n);
};
#endif
