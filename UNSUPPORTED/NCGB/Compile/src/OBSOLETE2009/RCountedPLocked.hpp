// RCountedPLocked.h

#ifndef INCLUDED_RCOUNTEDPLOCKED_H
#define INCLUDED_RCOUNTEDPLOCKED_H

#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "RecordHere.hpp"
#include "Ownership.hpp"

template<class T>
class RCountedPLocked {
  int * d_refcnt_p;
  T * d_data_p;
public:
  RCountedPLocked() : d_refcnt_p(0), d_data_p((T *) 0) {
    RECORDHERE(d_refcnt_p=new int(1);)
  };
  explicit RCountedPLocked(const T & x) : d_refcnt_p(0), 
        d_data_p(x.clone()) {
    RECORDHERE(d_refcnt_p=new int(1);)
  };
  RCountedPLocked(T * p,Adopt) : d_refcnt_p(0), d_data_p(p) {
    RECORDHERE(d_refcnt_p=new int(1);)
  };
  RCountedPLocked(const RCountedPLocked & x) : 
     d_refcnt_p(x.d_refcnt_p), d_data_p(x.d_data_p) {++(*d_refcnt_p);};
#if 0
       d_refcnt_p(0), d_data_p(x.d_data_p->clone()) {
    RECORDHERE(d_refcnt_p=new int(1);)
  };
#endif
  void operator =(const RCountedPLocked & x) {
    if(d_data_p!=x.d_data_p) {
      --(*d_refcnt_p);
      if((*d_refcnt_p)==0) {
        RECORDHERE(delete d_refcnt_p;)
        RECORDHERE(delete d_data_p;)
      };
      d_data_p = x.d_data_p;
      d_refcnt_p = x.d_refcnt_p;
      ++(*d_refcnt_p);
    }
  };
  ~RCountedPLocked() {
    --(*d_refcnt_p);
    if((*d_refcnt_p)==0) {
      RECORDHERE(delete d_refcnt_p;)
      RECORDHERE(delete d_data_p;)
    };// else printMessage();
  }; 
  void printMessage() const;

  const T & operator()() const { return * (const T *)d_data_p;};

  T & access() { 
    if((*d_refcnt_p)> 1) {
      // stop looking at the multiply viewed T
      --(*d_refcnt_p);
      // construct only-i-am-looking-at-T
      RECORDHERE(d_refcnt_p = new int(1);)
      d_data_p = d_data_p->clone();
    } else if ((*d_refcnt_p)<1) DBG();
    return * d_data_p;
  };

  void operator =(const T & x) {
    --(*d_refcnt_p);
    if((*d_refcnt_p)==0) {
      RECORDHERE(delete d_refcnt_p;)
      RECORDHERE(delete d_data_p;)
    };
    d_data_p = x.clone();
    RECORDHERE(d_refcnt_p = new int(1);)
  };
  bool simpleEqual(const RCountedPLocked & x) const {
    return d_data_p==x.d_data_p;
  };
  bool operator ==(const RCountedPLocked & x) const {
    return (this==&x) || (*d_data_p)==(*x.d_data_p);
  };
  bool operator !=(const RCountedPLocked & x) const { 
    return !((this==&x) || (*d_data_p)==(*x.d_data_p));
  };
};
#endif
