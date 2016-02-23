// Mark Stankus 1999 (c)
// UnionSource.c 

#include "UnionSource.hpp" 

#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif

using namespace std;

template<class T>
UnionSource<T>::~UnionSource(){};

template<class T>
bool UnionSource<T>::getNext(T & x) {
  bool todo = true;
  bool result = false;
  while(todo) {
    todo = false;
    result = false;
    if(d_L.empty()) {
      // nothing
    } else if(d_L.front().access().getNext(x)) {
      result = true;
    } else {
      d_L.erase(d_L.begin());
      todo = true;
    };
  };
  return result;
};
 
template<class T> 
SetSource<T> * UnionSource<T>::clone() const {
  return new UnionSource<T>(d_L);
};

template<class T> 
void UnionSource<T>::fillForUnknownReason() {};

template class UnionSource<pair<int,int> >;
#ifdef OLD_GCC
#include <list.h>
#include <pair.h>
#include "ICopy.hpp"
template class list<ICopy<SetSource<pair<int,int> > > >;
#endif
