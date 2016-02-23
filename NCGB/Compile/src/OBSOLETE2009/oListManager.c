// (c) Mark Stankus 1999
// ListManager.c

#include "ListManager.hpp"
#include "RecordHere.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

template<class T>
void ListManager<T>::s_get(list<T> & x,int n) {
  x.erase(x.begin(),x.end());
  T t;
  while(n) { x.push_back(t);--n;};
};

template<class T>
void ListManager<T>::s_copy(list<T> & sink,const list<T> & source) {
  sink = source;
};

template<class T>
void ListManager<T>::s_postjoin(list<T> & result,const list<T> & add) {
  list<T>::const_iterator w = add.begin(), e = add.end();
  while(w!=e) { result.push_back(*w);++w;};
};

template<class T>
void ListManager<T>::s_prejoin(list<T> & result,const list<T> & add) {
  list<T> L(add);
  list<T>::const_iterator w = result.begin(), e = result.end();
  while(w!=e) { L.push_back(*w);++w;};
  result = L;
};

template<class T>
void ListManager<T>::s_release(list<T> & L) {
  L.erase(L.begin(),L.end());
};

#include "Variable.hpp"
template class ListManager<Variable>;

list<Variable> ListManager<Variable>::s_storage;
int ListManager<Variable>::s_sz = 0;
