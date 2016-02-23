// RCountLock.h

#ifndef INCLUDED_RCOUNTLOCK_H
#define INCLUDED_RCOUNTLOCK_H

#include "Debug1.hpp"
#include "RecordHere.hpp"

template<class T>
class RCountLock {
  static bool s_CanShare;
  int * d_refcnt_p;
  T * d_data_p;
public:
  RCountLock() : d_refcnt_p(0), d_data_p(0) {
    RECORDHERE(d_refcnt_p = new int(1);)
    RECORDHERE(d_data_p = new T();)
  };
  explicit RCountLock(const T & x) : d_refcnt_p(0), d_data_p(0) {
    RECORDHERE(d_refcnt_p = new int(1);)
    RECORDHERE(d_data_p = new T(x);)
  };
  RCountLock(const RCountLock & x) : d_refcnt_p(0), d_data_p(0) {
    RECORDHERE(d_refcnt_p = new int(1);)
    RECORDHERE(d_data_p = new T(*x.d_data_p);)
  };
    // THE ABOVE IS INEFFICIENT
  void operator =(const RCountLock & x) {
    if(s_CanShare) {
      if(d_data_p!=x.d_data_p) {
        if(--(*d_refcnt_p)==0) {
          RECORDHERE(delete d_refcnt_p;)
          RECORDHERE(delete d_data_p;)
        };
        d_data_p = x.d_data_p;
        d_refcnt_p = x.d_refcnt_p;
        ++(*d_refcnt_p);
      }
    } else {
      RECORDHERE(d_data_p = new T(*x.d_data_p);)
      RECORDHERE(d_refcnt_p = new int(1);)
    };
  };
  ~RCountLock() {
    if(--(*d_refcnt_p)==0) {
      RECORDHERE(delete d_refcnt_p;)
      RECORDHERE(delete d_data_p;)
    };
  }; 

  const T & operator()() const { return * (const T *)d_data_p;};
  T & access() { 
    makeUnique();
    return * d_data_p;
  };
  void makeUnique() { 
    if((*d_refcnt_p)> 1) {
      // stop looking at the multiply viewed T
      --(*d_refcnt_p);
      // construct only-i-am-looking-at-T
      RECORDHERE(d_refcnt_p = new int(1);)
      RECORDHERE(d_data_p = new T(*d_data_p);)
    } else if ((*d_refcnt_p)<1) DBG();
  };

  bool simpleEqual(const RCountLock & x) const {
    return d_data_p==x.d_data_p;
  };
  bool operator ==(const RCountLock & x) const {
    return (this==&x) || (*d_data_p)==(*x.d_data_p);
  };
  bool operator !=(const RCountLock & x) const { 
    return !((this==&x) || (*d_data_p)==(*x.d_data_p));
  };
};

#endif
