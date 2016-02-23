// SetSlot.c

#include "SetSlot.hpp"

template<class T>
void SetSlot(vector<T> & v,const T & t,int i,const T & def) {
  const int sz = v.size();
  if(sz<=i) {
    for(int j=sz;j<=i;++j) {
       v.push_back(def);
    };
  };
  v[i] = t;
};

template void SetSlot(vector<bool> &,const bool &,int,const bool &);
