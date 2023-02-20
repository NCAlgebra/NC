// Mark Stankus 1999 (c)
// Counted.h

#ifndef INCLUDED_COUNTED_H
#define INCLUDED_COUNTED_H

#include "RecordHere.hpp"
#include "Ownership.hpp"
#include "CountedError.hpp"

template<class T>
class Counted {
  Counted(const Counted &);
    // not implemented
  Counted(const T &);
    // not implemented
  void operator =(const Counted & x);
    // not implemented
  void operator =(const T & x);
    // not implemented
protected:
  int * d_refcnt_p;
  T *   d_data_p;
  inline void destroyit() {
    --(*d_refcnt_p);
    if((*d_refcnt_p)==0) {
      RECORDHERE(delete d_refcnt_p;)
      RECORDHERE(delete d_data_p;)
    };// else printMessage();
  }; 
  Counted(T * p,Adopt) : d_refcnt_p(0), d_data_p(p) {
    RECORDHERE(d_refcnt_p=new int(1);)
  };
  void assign(T * p,Adopt) {
    d_data_p=p;
    RECORDHERE(d_refcnt_p=new int(1);)
  };
public:
  Counted() : d_refcnt_p(0), d_data_p(0) {
    RECORDHERE(d_refcnt_p=new int(1);)
  };
  ~Counted() {};
  const T & operator()() const { return * (const T *)d_data_p;};
  T & mustBeAlone() {
    if(!isAlone()) CountedError::errorh(__LINE__);
    return * d_data_p;
  };
  bool simpleEqual(const Counted & x) const {
    return d_data_p==x.d_data_p;
  };
  bool isAlone() const { 
    return * d_refcnt_p==1;
  };
  bool isValid() const { 
    return !!d_data_p;
  };
};
#endif
