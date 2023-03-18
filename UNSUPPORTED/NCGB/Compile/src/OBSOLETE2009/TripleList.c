// Mark Stankus 1999 (c)
// TripleList.cpp

#include "TripleList.hpp"
#include "CartesianSource.hpp"
#include "UnionSource.hpp"
#include "ICopy.hpp"
#include <list>
#include "Ownership.hpp"

template<class T>
void TripleList<T>::blankit() {
  typedef vector<T>::iterator LI;
  LI w = d_second.begin(), e = d_second.end();
  while(w!=e) {
    transfer(d_first,*w);
    ++w;
  };
  d_second.erase(d_second.begin(),d_second.end());
  w = d_new.begin(); e = d_new.end();
  while(w!=e) {
    transfer(d_second,*w);
    ++w;
  };
  d_new.erase(d_new.begin(),d_new.end());
}; 

template<class T>
void TripleList<T>::transfer(vector<T> & putin,const T & t) { 
  typedef vector<T>::const_iterator LI;
  LI w = d_first.begin(), e = d_first.end();
   bool found = false;
   while(w!=e) {
    if(*w==t) {
      found = true;
      break;
    };
    ++w;
  };
  if(!found) {
    putin.push_back(t);
  };
};

template<class T>
ICopy<SetSource<pair<T,T> > > TripleList<T>::operator()() {
  blankit();
  bool use_first  = !d_first.empty();
  bool use_second = !d_second.empty();
  list<ICopy<SetSource<pair<T,T> > > > LL;
  SetSource<pair<T,T> > * p = 0;
  if(use_first && use_second) {
    p = new CartesianSource<T,T>(d_first,d_second);
    ICopy<SetSource<pair<T,T> > > ic1(p,Adopt::s_dummy);
    LL.push_back(ic1);
    p = new CartesianSource<T,T>(d_second,d_first);
    ICopy<SetSource<pair<T,T> > > ic2(p,Adopt::s_dummy);
    LL.push_back(ic2);
  };
  if(use_second) {
    p = new CartesianSource<T,T>(d_second,d_second);
    ICopy<SetSource<pair<T,T> > > ic3(p,Adopt::s_dummy);
    LL.push_back(ic3);
  };
  ICopy<SetSource<pair<T,T> > > ic(new UnionSource<pair<T,T> >(LL),
                                 Adopt::s_dummy);
  return ic;
};

template class TripleList<int>;
#include "Choice.hpp"
#ifdef USE_UNIX
#include "CntSource.c"
#else
#include "CntSource.cpp"
#endif
template class CntSource<pair<int,int>,TripleList<int> >;
