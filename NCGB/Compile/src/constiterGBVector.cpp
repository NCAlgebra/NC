// const_iter_GBVector.c

#include "constiterGBVector.hpp"
#include "constiterGBVectorError.hpp"

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif

using namespace std;

template<class U>
const_iter_GBVector<U>::const_iter_GBVector() { 
  const_iter_GBVectorError::errorc(__LINE__);
};

template<class U>
const U & const_iter_GBVector<U>::operator *() const { 
  if(_n>_vec->size()) {
#if 0
    GBStream << ConstantStrings::TriedPastEnd;
#endif
    const_iter_GBVectorError::errorc(__LINE__);
  };
  return (*_vec)[_n];
};

template<class U>
const_iter_GBVector<U>::const_iter_GBVector(const GBVector<U> & vec) : 
           _vec(&vec), _n(1) {};

template<class U>
const_iter_GBVector<U>::const_iter_GBVector(
     const const_iter_GBVector<U> & vI) : 
     _vec(vI._vec), _n(vI._n){};

template<class U>
void const_iter_GBVector<U>::operator=(const const_iter_GBVector<U> & vI) {
   _vec =vI._vec;
   _n =vI._n;
};


template<class U>
const_iter_GBVector<U>::const_iter_GBVector(
     const GBVector<U> & vec,int n) : _vec(&vec), _n(n) {
  if(n>vec.size()+1) { 
#if 0
    GBStream << ConstantStrings::TriedInit
             << n << ConstantStrings::withSize << vec.size() 
             << ConstantStrings::newline;
    const_iter_GBVectorError::errorc(__LINE__);
    pair<int,int> pr(make_pair(n,vec.size()));
#endif
    const_iter_GBVectorError::errorc(__LINE__);
  };
};

template<class U>
bool const_iter_GBVector<U>::operator ==(const
     const_iter_GBVector<U> & aGBVector) const {
  return _n==aGBVector._n && (*aGBVector._vec)==(*_vec);
};


template<class U>
inline void const_iter_GBVector<U>::error1() const {
#if 0
  GBStream << ConstantStrings::triedPP << _n
           << ConstantStrings::withSize << _vec->size()
           << '\n';
  const_iter_GBVectorError::errorc(__LINE__);
  pair<int,int> pr(make_pair(_n,_vec->size()));
#endif
  const_iter_GBVectorError::errorc(__LINE__);
};

template<class U>
inline void const_iter_GBVector<U>::error2() const {
#if 0
  GBStream << ConstantStrings::triedMM << _n+1
           << ConstantStrings::withSize << _vec->size()
           << '\n';
  const_iter_GBVectorError::errorc(__LINE__);
  pair<int,int> pr(make_pair(_n+1,_vec->size()));
#endif
  const_iter_GBVectorError::errorc(__LINE__);
};
