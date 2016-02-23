// (c) Mark Stankus 1999
// History.h

#ifndef INCLUDED_HISTORY_H
#define INCLUDED_HISTORY_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
class MyOstream;

using namespace std;
#include "vcpp.hpp"

class History {
  int d_first,d_second,d_index;
  set<int,less<int> > d_numbers;
public:
  History() : d_first(-999), d_second(-999), d_index(-999) {};
  History(int a,int b) : d_first(a), d_second(b), d_index(-999) {};
  History(int a,int b,const set<int,less<int> > & x) : d_first(a), d_second(b), 
          d_index(-999), d_numbers(x) {};
  void assign(int a,int b,const set<int,less<int> > & x) {
    d_first=a;
    d_second=b; 
    d_index=-999;
    d_numbers=x;
  };
  History(const History & x) : d_first(x.d_first), d_second(x.d_second), 
          d_index(x.d_index), d_numbers(x.d_numbers) {};
  ~History(){};
  void operator = (const History & x) {
    d_first=x.d_first;
    d_second=x.d_second;
    d_index=x.d_index;
    d_numbers=x.d_numbers;
  };
  friend MyOstream & operator << (MyOstream & os,const History &);
  bool operator == (const History & x) const {
    return this==&x || (d_first==x.d_first &&  
                 d_second==x.d_second && d_index==x.d_index 
                 &&  d_numbers==x.d_numbers);
  };
  bool operator != (const History & x) const {
    return  !operator==(x);
  };
  int first() const {
    return d_first;
  }
  int second() const {
    return d_second;
  };
  int index() const {
    return d_index;
  };
  void index(int n) {
    d_index = n;
  };
  const set<int,less<int> > & reductions() const {
    return d_numbers;
  };
  void setHistory(const set<int,less<int> > & x) {
    d_numbers= x;
  };
};
#endif
