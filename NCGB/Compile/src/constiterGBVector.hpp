// const_iter_GBVector.h

#ifndef INCLUDED_CONST_ITER_GBVECTOR_H
#define INCLUDED_CONST_ITER_GBVECTOR_H

#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif

template<class U>
class const_iter_GBVector {
public:
   const GBVector<U> * _vec;
   int _n;
public:
  const_iter_GBVector();
  explicit const_iter_GBVector(const GBVector<U> & vec);
  const_iter_GBVector(const GBVector<U> & vec,int n);
  const_iter_GBVector(const const_iter_GBVector<U> & vI); 
  void operator=(const const_iter_GBVector<U> &); 
  const_iter_GBVector & operator ++();
  const_iter_GBVector & operator --();
  const U & operator *() const;
  bool operator ==(const const_iter_GBVector<U> &  iter) const;
  bool operator !=(const const_iter_GBVector<U> &  iter) const;
  void error1() const;
  void error2() const;
};

template<class U>
inline  bool const_iter_GBVector<U>::operator !=(const 
    const_iter_GBVector<U> & aGBVector) const { 
  return !((*this)==aGBVector);
};

template<class U>
inline const_iter_GBVector<U> & const_iter_GBVector<U>::operator ++() { 
  ++_n;
  if(_n>_vec->size()+1) error1();
  return * this;
};

template<class U>
inline const_iter_GBVector<U> & const_iter_GBVector<U>::operator --() { 
  --_n; 
  if(_n<=0) error2();
  return * this;
};
#endif
