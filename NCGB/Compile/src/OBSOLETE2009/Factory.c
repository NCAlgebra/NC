// Factory.c

#include "Factory.hpp"
#pragma warning(disable:4786)
#pragma warning(disable:4661)
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif

template<class T> Factory<T>::Factory() : d_ID(-999) { DBG();};

template<class T> Factory<T>::~Factory(){};

template<class T>
void Factory<T>::s_setCurrent() {
  DBG();
};

template<class T>
void Factory<T>::s_setCurrent(Factory<T> * p) {
  s_Current_p = p;
};

template<class T>
Factory<T> & Factory<T>::s_getCurrent() {
  if(!s_Current_p) s_setCurrent();
  return * s_Current_p;
};

template<class T>
bool Factory<T>::s_currentValid() {
  return !! s_Current_p;
};


#ifndef INCLUDED_MNGRSTART_H
#include "MngrStart.hpp"
#endif
#include "RemoveRedundent.hpp"

template class Factory<MngrStart>;
template class Factory<RemoveRedundent>;

Factory<MngrStart> * Factory<MngrStart>::s_Current_p = 0;
Factory<RemoveRedundent> * Factory<RemoveRedundent>::s_Current_p = 0;
