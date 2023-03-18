// GBVectorIterator.h

#ifndef INCLUDED_GBVECTORITERATOR_H
#define INCLUDED_GBVECTORITERATOR_H

#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif

template<class U>
class GBVectorIterator {
public:
   GBVector<U> & _vec;
   int _n;
private:
  GBVectorIterator(); 
    // not implemented
  void operator = (const GBVectorIterator &); 
    // not implemented
public:
  GBVectorIterator(GBVector<U> & vec) : _vec(vec), _n(1) {};
  GBVectorIterator(GBVector<U> & vec,int n);
  GBVectorIterator(const GBVectorIterator<U> & vI) : _vec(vI._vec), _n(vI._n){};
  virtual ~GBVectorIterator(){};

  GBVectorIterator & operator ++();
  GBVectorIterator & operator --();
  U & operator *() const;
  bool operator ==(const GBVectorIterator<U> & aGBVector) const
    { return _n==aGBVector._n && aGBVector._vec==_vec;};
  bool operator !=(const GBVectorIterator<U> & aGBVector) const
    { return !(_n==aGBVector._n && aGBVector._vec==_vec);};
  void error1() const;
  void error2() const;
  void error3() const;
};

template<class U>
inline U & GBVectorIterator<U>::operator *()  const { 
  if(_n>_vec.size()) error1();
  return _vec[_n];
};

template<class U>
inline GBVectorIterator<U> & GBVectorIterator<U>::operator ++() { 
  ++_n;
  if(_n>_vec.size()+1) error2();
  return * this;
};

template<class U>
inline GBVectorIterator<U> & GBVectorIterator<U>::operator --() { 
  --_n; 
  if(_n<=0) error3();
  return * this;
};
#endif
