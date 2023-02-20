// Mark Stankus 1999 (c)
// BiSet.hpp

#ifndef INCLUDED_BISET_H
#define INCLUDED_BISET_H

#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif

template<class T,class Compare>
class BiSet {
  set<T,Compare> d_S;
  set<T,Compare>::iterator  d_iter;
public:
  BiSet(set<T,Compare> & S) : d_S(S),d_iter(S.end()) {};
  BiSet(set<T,Compare> & S,set<T,Compare>::iterator w) : d_S(S),d_iter(w) {};
  ~BiSet(){};
  set<T,Compare>::const_iterator first_begin() const {
    return  d_S.begin();
  };
  set<T,Compare>::iterator first_begin() {
    return  d_S.begin();
  };
  set<T,Compare>::const_iterator first_end() const {
    return  d_iter;
  };
  set<T,Compare>::iterator first_end() {
    return  d_iter;
  };
  set<T,Compare>::const_iterator second_begin() const {
    return  d_iter;
  };
  set<T,Compare>::iterator second_begin() {
    return  d_iter;
  };
  set<T,Compare>::const_iterator second_end() const {
    return  d_S.end();
  };
  set<T,Compare>::iterator second_end() {
    return  d_S.end();
  };
  set<T,Compare>::const_iterator  & ITER() const {
    return d_iter;
  };
  set<T,Compare>::iterator  & ITER() {
    return d_iter;
  };
  const set<T,Compare> & SET() const {
    return d_S;
  };
  set<T,Compare> & SET() {
    return d_S;
  };
};
#endif
