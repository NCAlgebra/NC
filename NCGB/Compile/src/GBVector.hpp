// GBVector.h

#ifndef INCLUDED_GBVECTOR_H
#define INCLUDED_GBVECTOR_H

#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "RecordHere.hpp"
//#define NEW_CONSTRUCTOR
#ifdef NEW_CONSTRUCTOR
#ifndef INCLUDED_NEW_H
#define INCLUDED_NEW_H
#include <new.h>
#endif
#endif

template<class T> class iter_GBVector;
template<class T> class const_iter_GBVector;

class GBVectorBase {
  GBVectorBase(const GBVectorBase &);
    // not implemented
  void operator =(const GBVectorBase &);
    // not implemented
protected:
  GBVectorBase();
public: 
  virtual ~GBVectorBase() = 0; 
  int size() const;
  int capacity() const;
  void reserve(int s);
protected:
  virtual void vadjustAllocation(int s) = 0;
  int _size;
  int _capacity;
  int _jumpSize;
};

inline GBVectorBase::GBVectorBase() : _size(0),_capacity(0), _jumpSize(10) {};

inline GBVectorBase::~GBVectorBase(){};

inline int GBVectorBase::size() const { return _size;};

inline int GBVectorBase::capacity() const { return _capacity;};

inline void GBVectorBase::reserve(int s) {
  if (s > _capacity) {
    vadjustAllocation(s);
  }
};

template<class T>
class GBVector : public GBVectorBase {
public:
  GBVector();
  GBVector(int s);
  GBVector(const GBVector & x);
  virtual ~GBVector();
  void operator = (const GBVector<T> & aGBVector); 

  const T & front() const { return _v[0];};
  const T & back() const { return _v[_size-1];};

  typedef const_iter_GBVector<T> const_iterator;
  typedef iter_GBVector<T> iterator;

  bool operator == (const GBVector<T> & aGBVector) const; 
  bool operator != (const GBVector<T> & aGBVector) const; 
  void clear();

  // accessing elements of the vector
  T & operator[](int);
  const T & operator[](int) const;

  // size control
  void empty(int n);
  void empty();
  virtual void vadjustAllocation(int s);

  void insertIfNotMember(const T & t);
  void removeElement(int index);
  void push_back(const T & t);

// STL compliant
  iter_GBVector<T> begin();
  iter_GBVector<T> end();
  const_iter_GBVector<T> begin() const;

// psuedo-STL compliant
private:
  T * _v;
#ifdef CAREFUL
  void check(int i) const;
#endif
};

template <class T>
inline GBVector<T>::GBVector() : GBVectorBase(),  _v(0) { }

template <class T>
inline GBVector<T>::GBVector(int s) : GBVectorBase(),  _v(0) {
  empty(s);
}

template <class T>
inline void GBVector<T>::clear() {
  if (_size != 0) {
    _size = 0;
    _capacity = 0;
#ifdef NEW_CONSTRUCTOR
    RECORDHERE(delete [] (char *) _v;)
#else
    RECORDHERE(delete [] _v;)
#endif
    _v = 0;
  }
}

template<class T>
inline bool GBVector<T>::operator !=(const GBVector<T> & aGBVector) const {
  return !((*this) == aGBVector);
}

template <class T>
inline void GBVector<T>::empty() { empty(0); }

// STL compliant
template <class T>
inline iter_GBVector<T> GBVector<T>::begin() { return iter_GBVector<T>(*this); }

template <class T>
inline iter_GBVector<T> GBVector<T>::end() { return iter_GBVector<T>(*this, _size + 1); }

template<class T>
inline const_iter_GBVector<T> GBVector<T>::begin() const { 
  return const_iter_GBVector<T>(*this);
}

template <class T>
inline void GBVector<T>::push_back(const T & t) {
  int sz = _size;
  reserve(sz + 1);
  _size = sz + 1;

#ifdef NEW_CONSTRUCTOR
  (void) new(&_v[sz]) T(t);
#else
  _v[sz] = t;
#endif
}

#ifndef INCLUDED_ITER_GBVECTOR_H
#include "iterGBVector.hpp"
#endif

#ifndef INCLUDED_CONST_ITER_GBVECTOR_H
#include "constiterGBVector.hpp"
#endif

#endif
