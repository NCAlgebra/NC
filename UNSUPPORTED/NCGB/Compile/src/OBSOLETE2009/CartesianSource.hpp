// Mark Stankus 1999 (c)
// CartesianSetSource.hpp

#ifndef INCLUDED_CARTESIANSETSOURCE_H
#define INCLUDED_CARTESIANSETSOURCE_H

#include "SetSource.hpp"
#include "MyOstream.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif

#pragma warning(disable:4661)

using namespace std;

template<class T,class U>
class CartesianSource : public SetSource<pair<T,U> > {
  vector<T> d_first;
  vector<U> d_second;
  int d_place1,d_place2;
  int d_sz1, d_sz2;
  void advance();
  CartesianSource(const CartesianSource<T,U> &);
public:
  CartesianSource(const vector<T> & first,
      const vector<T> & second) : d_first(first), d_second(second),
      d_place1(0), d_place2(0), d_sz1(first.size()),
      d_sz2(second.size())  {
    if(d_sz1==0) {
      d_place1=-1;
      d_place2=-1;
    } else if(d_sz2==0) {
      d_place1=-1;
      d_place2=-1;
    };
  };
  virtual ~CartesianSource();
  virtual bool getNext(pair<T,U> &);
  virtual SetSource<pair<T,U> > * clone() const;
  virtual void fillForUnknownReason();
};
#endif
