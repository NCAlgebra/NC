// Mark Stankus (c) 1999
// tdPool.cpp

#include "tdPool.hpp"

template<class T>
tdPool<T>::~tdPool() {
  delete d_p;
};

template<class T>
const char * tdPool<T>::poolname() const {
  return s_poolname;
};

template<class T>
Names * tdPool<T>::prototype() const {
  return new tdPool<T>(new T);
};

template<class T>
Names::PoolVoid tdPool<T>::getPointer() {
  Names::PoolVoid p;
  p.ptr(d_p);
  return p;
};

template<class T>
Names * tdPool<T>::create(Source &) const {
  DBG();
  return (Names *) 0;
};
