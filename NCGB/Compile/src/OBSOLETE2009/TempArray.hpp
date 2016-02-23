// TempArray.h

#ifndef INCLUDED_TEMPARRAY_H
#define INCLUDED_TEMPARRAY_H

template<class T>
class TempArray {
  int d_sz;
  T * * d_pp;
public:
  TempArray(int n) : d_sz(n), d_pp(new (T*)[n]) {};
  virtual ~TempArray() = 0;
  class const_iterator {
    T * * d_q;
  public:
    const_iterator(T * * q) : d_q(q) {};
    void operator++() {  ++q;}
    void operator--() {  --q;}
    const T & operator*() {  return * *q;}
  };
  const_iterator begin() const { 
    return const_iterator(d_pp);
  };
  const_iterator end() const { 
    return const_iterator(d_pp+d_sz);
  };
  class iterator {
    T * * d_q;
  public:
    iterator(T * * q) : d_q(q) {};
    void operator++() {  ++q;}
    void operator--() {  --q;}
    T & operator*() {  return * *q;}
  };
  iterator begin() { 
    return iterator(d_pp);
  };
  iterator end() { 
    return iterator(d_pp+d_sz);
  };
  int size() const { 
    return d_sz;
  };
};
#endif
