// Mark Stankus 1999 (c)
// TripleList.hpp

#ifndef INCLUDED_TRIPLELIST_H
#define INCLUDED_TRIPLELIST_H

#include "SetSource.hpp"
#include "ICopy.hpp"
#include <vector>

template<class T>
class TripleList {
  vector<T> d_first;
  vector<T> d_second;
  vector<T> d_new;
  void transfer(vector<T> & putin,const T & t);
  void blankit();
public:
  TripleList(){};
  ~TripleList(){};
  ICopy<SetSource<pair<T,T> > > operator()(); 
  void addItem(const T & t) {
    d_new.push_back(t);
  };
};
#endif
