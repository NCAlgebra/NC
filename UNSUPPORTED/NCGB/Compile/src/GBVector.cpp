// GBVector.c

#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif
#include "RecordHere.hpp"
#include "MyOstream.hpp"

// CAN'T INLINE :-(
template <class T>
GBVector<T>::GBVector(const GBVector<T> & x) : GBVectorBase(), _v(0) {
  operator = (x);
};

// CAN'T INLINE :-(
template <class T>
const T & GBVector<T>::operator[](int i) const {
  return _v[i - 1];
}

// CAN'T INLINE :-(
template <class T>
T & GBVector<T>::operator[](int i) {
  return _v[i - 1];
}

template <class T>
GBVector<T>::~GBVector() {
#ifdef NEW_CONSTRUCTOR
  for (int i = 0; i < _size; ++i)
    _v[i].~T();
  RECORDHERE(delete [] (char *) _v;)
#else
  RECORDHERE(delete [] _v;)
#endif
}

template <class T>
void GBVector<T>::empty(int n) {
  RECORDHERE(delete [] (char *) _v;)
  if (n == 0) {
    _v = 0;
  } else {
#ifdef NEW_CONSTRUCTOR
    RECORDHERE(_v = (T *) new char[sizeof(T) * n];)
#else
    RECORDHERE(_v = new T[n];)
#endif
    if (_v == 0) DBG();
  }
  _capacity = n;
  _size = 0;
  _jumpSize = 10;
}

template <class T>
void GBVector<T>::vadjustAllocation(int s) {
  if (s > _capacity) {
    _capacity = s + _jumpSize;
#ifdef NEW_CONSTRUCTOR
    RECORDHERE(T * ptr = (T *) new char[sizeof(T) * _capacity];)
#else
    RECORDHERE(T * ptr = new T[_capacity];)
#endif
    if (ptr == 0) DBG();
    for (int i = 0; i < _size; ++i) {
#ifdef NEW_CONSTRUCTOR
      (void) new(&ptr[i]) T(_v[i]);
      _v[i].~T();
#else
      ptr[i] = _v[i];
#endif
    }

/*
    for (i = _size; i < _capacity; ++i) {
      (void) new(&ptr[i]) T;
    };
*/

#ifdef NEW_CONSTRUCTOR
    RECORDHERE(delete [] (char *) _v;)
#else
    RECORDHERE(delete [] _v;)
#endif
    _v = ptr;
  }
}

template <class T>
void GBVector<T>::insertIfNotMember(const T & t) { 
  int result = -1;
  typename GBVector<T>::const_iterator w= ((const GBVector<T> *)this)->begin();
  for(int i = 1; i <= _size && result == -1; ++i,++w) {
    if (t == *w) {
      result = i;
    }
  }  
 if (result == -1) push_back(t); 
}

template<class T>
void GBVector<T>::operator = (const GBVector<T> & aGBVector) {
  if (this != &aGBVector) {
    const int RSize = aGBVector._size;
    if (RSize > 0) {
      empty(RSize); 
      T * p = _v;
      for (int i = 1; i <= RSize; ++i,++p) {
        push_back(*p);
      }
    } else {
      empty();
    }
  }
}

template<class T>
bool  GBVector<T>::operator == (const GBVector<T> & aGBVector) const {
  bool result = (_size == aGBVector._size);
  if (result) {
    T * p  = _v;
    T * q = aGBVector._v;
    for (int i = 1; i <= _size && result; ++i,++p,++q) {
      result = (*p)== (*q);
    }
  }
  return result;
}

template <class T>
void GBVector<T>::removeElement(int index) {
  const int sz = _size;
  for(int i = index + 1; i <= sz; ++i) {
    (*this)[i-1] = (*this)[i];
  }

#ifdef NEW_CONSTRUCTOR
  _v[_size].~T();
#endif

  _size = sz - 1;
};
