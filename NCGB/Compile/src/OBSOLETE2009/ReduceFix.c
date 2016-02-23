// (c) Mark Stankus 1999
// ReduceFix.c

#include "ReduceFix.hpp"

ReduceFix::ReduceFix(Reduce & x,const list<Polynomial> & L) : Reduce(false),
       d_x(x), d_original(L), d_current(L) {
  int d_num_zero = 0;
  typedef list<Polynomial>::iterator LI;
  LI w = d_current.begin(), e = d_current.end();
  while(w!=e) {
    Polynomial & ts = *w;
    if(ts.zero()) ++d_num_zero;
    ++w;
  };
};

ReduceFix::~ReduceFix(){};

bool ReduceFix::reduce(Polynomial & p) const {
  return d_x.reduce(p);
};

void ReduceFix::reducefix() {
  typedef list<Polynomial>::iterator LI;
  LI w = d_current.begin(), e = d_current.end();
  while(w!=e) {
    Polynomial & ts = *w;
    if(!ts.zero()) {
      d_x.reduce(ts);
      if(ts.zero()) ++d_num_zero;
    };
    ++w;
  };
};
