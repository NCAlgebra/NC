// ConstTempArray.h

#ifndef INCLUDED_CONSTTEMPARRAY_H
#define INCLUDED_CONSTTEMPARRAY_H

template<class T>
class ConstTempArray {
  int d_sz;
  const T * * d_pp;
public:
  ConstTempArray(int n) : d_sz(n), d_pp(new (T*)[n]) {};
  virtual ~ConstTempArray() = 0;
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
  int size() const { 
    return d_sz;
  };
};
#endif
