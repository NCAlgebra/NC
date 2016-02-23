// iterGBVector.c

#ifndef INCLUDED_ITER_GBVECTOR_H
#include "iterGBVector.hpp"
#endif
#include "MyOstream.hpp"
#include "GBStream.hpp"
//#pragma warning(disable:4660)

#if 0
template<class U>
iter_GBVector<U>::iter_GBVector() : _vec(*(GBVector<U>*)0), _n(-999) { DBG();};

template<class U>
void iter_GBVector<U>::operator=(const iter_GBVector &) { DBG();};
#endif

template<class U>
iter_GBVector<U>::iter_GBVector(GBVector<U> & vec,int n) : _vec(vec), _n(n) {
  if(n>vec.size()+1) { 
    GBStream << "Tried to initialize a vector iterator with value "
             << n << " on a container with size " << vec.size() 
             << '\n';
    DBG();
  };
};

template<class U>
void iter_GBVector<U>::error1() const {
  GBStream << "Tried to dereference a vector iterator at or past end\n";
};

template<class U>
void iter_GBVector<U>::error2() const{
  GBStream << "Tried to ++ a vector iterator with value "
             << _n << " on a container with size " << _vec.size()
             << '\n';
  DBG();
};

template<class U>
void iter_GBVector<U>::error3() const {
    GBStream << "Tried to -- a vector iterator with value "
             << _n+1 << " on a container with size " << _vec.size()
             << '\n';
    DBG();
};
