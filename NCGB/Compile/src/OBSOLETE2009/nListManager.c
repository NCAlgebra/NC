// (c) Mark Stankus 1999
// ListManager.c

#include "ListManager.hpp"
#include "PrintList.hpp"
#include "RecordHere.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

template<class T>
inline void reportit(T *) {
#if 0  
  ListManager<T>::s_sz = ListManager<T>::s_storage.size();
  GBStream << "s_sz:" << ListManager<T>::s_sz << '\n';
#endif
};

//#define DEBUGLISTMANAGER

template<class T>
void ListManager<T>::s_get(list<T> & x,int n) {
#ifdef DEBUGLISTMANAGER
  int m = n;
#endif
  typedef list<T>::iterator LI;
  int xsz = x.size();
  if(n<xsz) {
    int skip = xsz-n;
    LI w = x.begin(); LI e = w;
    while(skip>0) { ++e;--skip;};
    s_storage.splice(s_storage.end(),x,w,e);
  } else if(xsz<n) {
    n -= xsz;
    LI w = s_storage.begin(), e = s_storage.begin(); 
    LI w1 = w;
    while(n>0 && w!=e) { ++w;--n;};
    x.splice(x.end(),s_storage,w1,w);
    T t;
    while(n>0) {
      x.push_back(t);
      --n;
    };
  };
#ifdef DEBUGLISTMANAGER
  if((int)x.size()!=m) {
    GBStream << "\nOriginal size:" << xsz;
    GBStream << "\nNew size:" << x.size();
    GBStream << "\nWanted size:" << m << '\n';
    DBG();
  };
#endif
  reportit((T *)0);
};

template<class T>
void ListManager<T>::s_copy(list<T> & sink,const list<T> & source) {
  if(&sink!=&source) {
    typedef list<T>::iterator LI;
    typedef list<T>::const_iterator LCI;
    LI w1 = sink.begin(), e1 = sink.end();
    LCI w2 = source.begin(), e2 = source.end();
    for ( ; w1 != e1 && w2 != e2 ; ++w1, ++w2) {
      *w1= *w2;
    };
    if(w1==e1) {
      LI w3 = s_storage.begin(), e3 = s_storage.end(); 
      LI save = w3;
      while(w2!=e2 && w3!=e3) {
        *w3 = *w2;
        ++w3;++w2;
      };
      sink.splice(sink.end(),s_storage,save,w3);
      while(w2!=e2) {
        sink.push_back(*w2);
        ++w2;
      };
    } else if(w2==e2) {
      // at the end of source. put the other elements on s_storage.
      s_storage.splice(s_storage.end(),sink,w1,e1);
    };
  };
#ifdef DEBUGLISTMANAGER
  if(sink!=source) {
    PrintList("sink:",sink);
    PrintList("source:",source);
    DBG();
  };
#endif
  reportit((T *)0);
};

template<class T>
void ListManager<T>::s_postjoin(list<T> & result,const list<T> & add) {
#ifdef DEBUGLISTMANAGER
  list<T> M; 
  copy(result.begin(),result.end(),back_inserter(M));
  copy(add.begin(),add.end(),back_inserter(M));
#endif
  list<T> L;
  s_copy(L,add);
  result.splice(result.end(),L,L.begin(),L.end());
#ifdef DEBUGLISTMANAGER
  if(result!=M) DBG();
#endif
  reportit((T *)0);
};

template<class T>
void ListManager<T>::s_prejoin(list<T> & result,const list<T> & add) {
#ifdef DEBUGLISTMANAGER
  list<T> M; 
  copy(add.begin(),add.end(),back_inserter(M));
  copy(result.begin(),result.end(),back_inserter(M));
#endif
  list<T> L;
  s_copy(L,add);
  result.splice(result.begin(),L,L.begin(),L.end());
#ifdef DEBUGLISTMANAGER
  if(result!=M) DBG();
#endif
  reportit((T *)0);
};

template<class T>
void ListManager<T>::s_release(list<T> & L) {
  s_storage.splice(s_storage.end(),L,L.begin(),L.end());
#ifdef DEBUGLISTMANAGER
  if(!L.empty()) DBG();
#endif
  reportit((T *)0);
};

#include "Variable.hpp"
template class ListManager<Variable>;

list<Variable> ListManager<Variable>::s_storage;
int ListManager<Variable>::s_sz = 0;
