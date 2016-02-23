// (c) Mark Stankus 1999
// ListManager.h

#ifndef INCLUDED_LISTMANAGER_H
#define INCLUDED_LISTMANAGER_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

template<class T>
class ListManager {
public:
  ListManager(){};
  ~ListManager(){};
  static void s_get(list<T> & x,int n);
  static void s_copy(list<T> & sink,const list<T> & source);
  static void s_prejoin(list<T> &result ,const list<T> & add);
  static void s_postjoin(list<T> &result ,const list<T> & add);
  static void s_release(list<T> & L);
  static list<T> s_storage;
  static int s_sz;
};
#endif
