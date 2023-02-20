// Member.h

#ifndef INCLUDED_MEMBER_H
#define INCLUDED_MEMBER_H

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#include "GBList.hpp"
#include "GBVector.hpp"

template<class T>
inline pair<bool,int> Member(const GBList<T> & L,const T & a) {
  int result = -1;
  typename GBList<T>::const_iterator w = L.begin();
  const int sz = L.size();
  int i=1;
  for(;i<=sz;++i,++w) {
    if(*w==a) {
      result = i;
      break;
    };
  };
  return make_pair(i!=1,i);
};

template<class T>
inline bool IsMember(const GBList<T> & L,const T & a) {
  bool result = false;
  typename GBList<T>::const_iterator w = L.begin();
  const int sz = L.size();
  for(int i=1;i<=sz&&(!result);++i,++w) {
    result = (*w==a);
  };
  return result;
};

template<class T>
inline bool IsMember(const GBVector<T> & L,const T & a) {
  bool result = false;
  typename GBVector<T>::const_iterator w = L.begin();
  const int sz = L.size();
  for(int i=1;i<=sz&&(!result);++i,++w) {
    result = (*w==a);
  };
  return result;
};

template<class T>
inline void insertIfNotMember(GBList<T> & L,const T &a) {
  if(!IsMember(L,a)) L.push_back(a);
};
#endif
