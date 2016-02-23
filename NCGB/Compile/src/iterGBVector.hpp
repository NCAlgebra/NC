// iter_GBVector.h

#ifndef INCLUDED_ITER_GBVECTOR_H
#define INCLUDED_ITER_GBVECTOR_H

#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif

template<class U>
class iter_GBVector {
public:
  GBVector<U> & _vec;
  int _n;
private:
  iter_GBVector();
  void operator=(const iter_GBVector &);
public:
  explicit iter_GBVector(GBVector<U> & vec) : _vec(vec), _n(1) {};
  iter_GBVector(GBVector<U> & vec,int n);
  iter_GBVector(const iter_GBVector<U> & vI) : _vec(vI._vec), _n(vI._n){};
  iter_GBVector & operator ++();
  iter_GBVector & operator --();
  U & operator *() const;
  bool operator ==(const iter_GBVector<U> & aGBVector) const
    { return _n==aGBVector._n && aGBVector._vec==_vec;};
  bool operator !=(const iter_GBVector<U> & aGBVector) const
    { return !(_n==aGBVector._n && aGBVector._vec==_vec);};
  void error1() const;
  void error2() const;
  void error3() const;
};

template<class U>
inline U & iter_GBVector<U>::operator *()  const { 
  if(_n>_vec.size()) error1();
  return _vec[_n];
};

template<class U>
inline iter_GBVector<U> & iter_GBVector<U>::operator ++() { 
  ++_n;
  if(_n>_vec.size()+1) error2();
  return * this;
};

template<class U>
inline iter_GBVector<U> & iter_GBVector<U>::operator --() { 
  --_n; 
  if(_n<=0) error3();
  return * this;
};
#endif
