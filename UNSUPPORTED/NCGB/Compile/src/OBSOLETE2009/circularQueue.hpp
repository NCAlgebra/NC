// Mark Stankus (c) 1999 
// circularQueue.hpp

#ifndef INCLUDED_CIRCULARQUEUE_H
#define INCLUDED_CIRCULARQUEUE_H

#include "Debug1.hpp"

template<class T>
class circularQueue {
  int d_begin, d_len, d_sz;
  vector<T> d_vec;
  circularQueue() {};
public:
  circularQueue(int n) : d_begin(0),d_len(0), d_sz(0), d_vec(n) {};
  T pop() {
    if(d_len==0) DBG();
    --d_len;
    return d_vec[(d_begin+d_len)% d_sz];
  };
  void push(const T & t) {
    if(d_len==d_sz) {
      grow();
    };
    d_vec[(d_begin+d_len)%d_sz] = t;
    ++d_len;
  };
  void multipush(const vector<T> & x) {
    int newsz = x.size();
  };
  void grow() {
    d_sz *= 2;
    d_vec.reserve(d_sz);
  };
};
#endif
