// Mark Stankus (c) 1999
// tPool.cpp

#include "tPool.hpp"

template<class T>
tPool<T>::~tPool() {
  delete d_p;
};

template<class T>
const char * tPool<T>::poolname() const {
  return s_poolname;
};

template<class T>
Names * tPool<T>::prototype() const {
  DBG();
  return (Names *) 0;
};

template<class T>
Names::PoolVoid tPool<T>::getPointer() {
  Names::PoolVoid p;
  p.ptr(d_p);
  return p;
};

template<class T>
Names * tPool<T>::create(Source &) const {
  DBG();
  return (Names *) 0;
};
