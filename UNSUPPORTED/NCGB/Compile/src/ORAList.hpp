// RAList.h

// A list with random access. When push_back is called
// either the element is put in the first hole of 
// is added at the end of the list

#ifndef INCLUDED_RALIST_H
#define INCLUDED_RALIST_H

//#pragma warning(disable:4661)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "GBList.hpp"
#include "MyOstream.hpp"

template<class T>
class RAList {
  RAList(const RAList &);
    // not implemented
  void operator=(const RAList &);
    // not implemented
public:
  RAList();
  ~RAList();
  const T & const_reference(int n,bool check = true) const; 
  T & reference(int n,bool check = true); 
  int push_back(const T & t);
  void makeHole(int n);
private:
  list<T> d_items;
  GBList<int> d_holes;
  void check(int n) const;
};

template<class T>
inline RAList<T>::RAList(){};

template<class T>
inline RAList<T>::~RAList(){};

template<class T>
inline const T & RAList<T>::const_reference(int n,bool checkit) const {
//  return ((DLList<U> *)(void *)_ptr)->operator()(_p);
  if(checkit) check(n);
  typename list<T>::const_iterator w = d_items.begin();
  for(int i=2;i<=n;++i,++w) {};
  return * w;
};

template<class T>
inline T & RAList<T>::reference(int n,bool checkit) {
  if(checkit) check(n);
  typename list<T>::iterator w = d_items.begin();
  for(int i=2;i<=n;++i,++w) {};
  return * w;
};

template<class T>
inline int RAList<T>::push_back(const T & t) {
  int position;
  if(d_holes.size()>0) {
    position = * d_holes.begin();
    reference(position,false) = t;
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
  d_holes.insertIfNotMember(n);
};

void RAListAccessHold(int);
void RAListMarkerOutOfRange(int);

template<class T>
inline void RAList<T>::check(int n) const {
  if(d_holes.Member(n).first()) {
     RAListAccessHold(n);
  }
  if(n<1 || n>(int)d_items.size()) {
    RAListMarkerOutOfRange(n);
  }
};
#endif
