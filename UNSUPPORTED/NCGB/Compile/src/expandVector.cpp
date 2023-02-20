// expandVector.c

#include "expandVector.hpp"

template<class T>
void expandVector(vector<T> & vec,int n,const T & t) {
  const int sz = vec.size();
  vec.reserve(n);
  for(int i=sz;i<n;++i) {
    vec.push_back(t);
  };
};

#include "GroebnerRule.hpp"
template void expandVector(vector<bool>&,int,const bool &);
template void expandVector(vector<int>&,int,const int&);
template void expandVector(vector<vector<int> >&,int,const vector<int>&);
