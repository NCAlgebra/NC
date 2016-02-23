// RCountPLock.h

#ifndef INCLUDED_RCOUNTPLOCK_H
#define INCLUDED_RCOUNTPLOCK_H

#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "RecordHere.hpp"
#include "Ownership.hpp"

#define INEFFICIENT_RCOUNTPLOCK

template<class T>
class RCountPLock {
  mutable int d_NotShare;
    // d_NotShare==0 means we can share
    // d_NotShare>0  means we cannout share
    // an "int" is used, rather than a "bool" to replicate the action
    // of a stack
  mutable int * d_refcnt_p;
  mutable T * d_data_p;
public:
  struct ADOPT {};
  RCountPLock() : d_NotShare(0), d_refcnt_p(0), d_data_p((T *) 0) {
    RECORDHERE(d_refcnt_p = new int(1);)
  };
  explicit RCountPLock(const T & x) : 
    d_NotShare(0), d_refcnt_p(0), d_data_p(x.clone()) {
    RECORDHERE(d_refcnt_p=new int(1);)
  };
  explicit RCountPLock(T * p,ADOPT) : 
    d_NotShare(0),d_refcnt_p(0), d_data_p(p) {
    RECORDHERE(d_refcnt_p=new int(1);)
  };
  RCountPLock(const RCountPLock & x) : 
#ifdef INEFFICIENT_RCOUNTPLOCK
    d_NotShare(0), d_refcnt_p(0), d_data_p(x.d_data_p->clone()) {
    RECORDHERE(d_refcnt_p=new int(1);)
  };
#else
    d_NotShare(0), d_refcnt_p(x.d_refcnt_p), d_data_p(x.d_data_p) {++(*d_refcnt_p);};
#endif
  void operator =(const RCountPLock & x) {
    if(x.d_NotShare==0) {
      if(d_data_p!=x.d_data_p) {
        if(--(*d_refcnt_p)==0) {
          RECORDHERE(delete d_refcnt_p;)
          RECORDHERE(delete d_data_p;)
        };
#ifdef INEFFICIENT_RCOUNTPLOCK
        d_data_p = x.d_data_p->clone();
        RECORDHERE(d_refcnt_p = new int(1);)
#else
        d_data_p = x.d_data_p;
        d_refcnt_p = x.d_refcnt_p;
        ++(*d_refcnt_p);
#endif
      }
    } else {
      // x.d_NotShare>0 so we cannot share
      d_data_p = x.d_data_p->clone();
      RECORDHERE(d_refcnt_p = new int(1);)
      d_NotShare = 0;
    };
  };
  void operator =(const T & x) {
    if(--(*d_refcnt_p)==0) {
      RECORDHERE(delete d_refcnt_p;)
      RECORDHERE(delete d_data_p;)
    };
    d_data_p = x.clone();
    RECORDHERE(d_refcnt_p = new int(1);)
  };
  ~RCountPLock() {
    if(--(*d_refcnt_p)==0) {
      RECORDHERE(delete d_refcnt_p;)
      RECORDHERE(delete d_data_p;)
    };
  }; 

  const T & operator()() const { return * (const T *)d_data_p;};

  void makeUnique() const {
    if((*d_refcnt_p)> 1) {
      // stop looking at the multiply viewed T
      --(*d_refcnt_p);
      // construct only-i-am-looking-at-T
      RECORDHERE(d_refcnt_p = new int(1);)
      d_data_p = d_data_p->clone();
    } else if ((*d_refcnt_p)<1) DBG();
  };
  T & access() { 
    makeUnique();
    return * d_data_p;
  };
  void lock()   const { ++d_NotShare;}
  void unlock() const { --d_NotShare;if(d_NotShare<0) DBG();}
  
  T & cheat_access() { return * (T *) d_data_p;};

  bool simpleEqual(const RCountPLock & x) const {
    return d_data_p==x.d_data_p;
  };
  bool operator ==(const RCountPLock & x) const {
    return (this==&x) || (*d_data_p)==(*x.d_data_p);
  };
  bool operator !=(const RCountPLock & x) const { 
    return !((this==&x) || (*d_data_p)==(*x.d_data_p));
  };
};
#endif
