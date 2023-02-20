// RCountedLocked.h

#ifndef INCLUDED_RCOUNTEDLOCKED_H
#define INCLUDED_RCOUNTEDLOCKED_H

#include "Debug1.hpp"
#include "RecordHere.hpp"

template<class T>
class RCountedLocked {
  int * d_refcnt_p;
  T * d_data_p;
public:
  RCountedLocked() : d_refcnt_p(0), d_data_p(0) {};
    RECORDHERE(d_refcnt_p=new int(1);)
    RECORDHERE(d_data_p=new T();)
  };
  explicit RCountedLocked(const T & x) : d_refcnt_p(0), d_data_p(0) {
    RECORDHERE(d_refcnt_p=new int(1);)
    RECORDHERE(d_data_p=new T(x);)
  };
  RCountedLocked(const RCountedLocked & x) : d_refcnt_p(0), d_data_p(0) {
    RECORDHERE(d_refcnt_p=new int(1);)
    RECORDHERE(d_data_p=new T(*x.d_data_p);)
  };
  void operator =(const RCountedLocked & x) {
    if(d_data_p!=x.d_data_p) {
      if(--(*d_refcnt_p)==0) {
        RECORDHERE(delete d_refcnt_p;)
        RECORDHERE(delete d_data_p;)
      };
      d_data_p = x.d_data_p;
      d_refcnt_p = x.d_refcnt_p;
      ++(*d_refcnt_p);
    }
  };
  ~RCountedLocked() {
    if(--(*d_refcnt_p)==0) {
      RECORDHERE(delete d_refcnt_p;)
      RECORDHERE(delete d_data_p;)
    };
  }; 

  const T & operator()() const { return * (const T *)d_data_p;};
  T & access() { 
    if((*d_refcnt_p)> 1) {
      // stop looking at the multiply viewed T
      --(*d_refcnt_p);
      // construct only-i-am-looking-at-T
      RECORDHERE(d_refcnt_p = new int(1);)
      RECORDHERE(d_data_p = new T(*d_data_p);)
    } else if ((*d_refcnt_p)<1) DBG();
    return * d_data_p;
  };

  bool simpleEqual(const RCountedLocked & x) const {
    return d_data_p==x.d_data_p;
  };
  bool operator ==(const RCountedLocked & x) const {
    return (this==&x) || (*d_data_p)==(*x.d_data_p);
  };
  bool operator !=(const RCountedLocked & x) const { 
    return !((this==&x) || (*d_data_p)==(*x.d_data_p));
  };
};

#endif
