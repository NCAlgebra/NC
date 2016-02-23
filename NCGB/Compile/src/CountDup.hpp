// Mark Stankus 1999 (c)
// CountDup.h

#ifndef INCLUDED_COUNTEDDUP_H
#define INCLUDED_COUNTEDDUP_H

#include "Counted.hpp"
#include "CountDupError.hpp"
// #pragma warning(disable:4786)

#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif

template<class T,class TECHNIQUE>
class CountDup  : public Counted<T> {
protected:
  int d_freeze;
private:
  inline void destroyit() {
    if(Counted<T>::d_refcnt_p) {
      --(*Counted<T>::d_refcnt_p);
      if((*Counted<T>::d_refcnt_p)==0) {
        RECORDHERE(delete Counted<T>::d_refcnt_p;)
        RECORDHERE(delete Counted<T>::d_data_p;)
      };// else printMessage();
    };
  }; 
  void copyOnFreeze(const CountDup & x) {
    if(d_freeze!=0) {
      Counted<T>::d_refcnt_p = new int(1);
      Counted<T>::d_data_p = TECHNIQUE::s_copy(*x.d_data_p);
    } else {
      Counted<T>::d_refcnt_p=x.d_refcnt_p; 
      Counted<T>::d_data_p=x.d_data_p; 
      if(Counted<T>::d_refcnt_p) ++(*Counted<T>::d_refcnt_p);
    };
  };
public:
  CountDup() : Counted<T>(), d_freeze(0) {};
  explicit CountDup(const T & x) : 
       Counted<T>(TECHNIQUE::s_copy(x),Adopt::s_dummy),
       d_freeze(0) {};
  CountDup(T * p,Adopt dummy) : Counted<T>(p,dummy), d_freeze(0) {};
  CountDup(const CountDup & x) : d_freeze(0) {
    copyOnFreeze(x);
  };
  ~CountDup() {
    destroyit(); 
  };
  void operator =(const CountDup<T,TECHNIQUE> & x) {
    if(Counted<T>::d_data_p!=x.d_data_p) {
      destroyit();
      copyOnFreeze(x);
    }
  };
  void operator =(const T & x) {
    destroyit();
    Counted<T>::d_data_p = TECHNIQUE::s_copy(x);
    RECORDHERE(Counted<T>::d_refcnt_p = new int(1);)
  };
  void assign(T * p,Adopt dummy) {
    destroyit();
    d_freeze = 0;
    Counted<T>::assign(p,dummy);
  };
  void freezeIt() const {
    CountDup<T,TECHNIQUE>  * alias = const_cast<CountDup<T,TECHNIQUE>*>(this);
    ++alias->d_freeze;
  };
  void unfreezeIt() const {
    CountDup<T,TECHNIQUE>  * alias = const_cast<CountDup<T,TECHNIQUE>*>(this);
    --alias->d_freeze;
  };
  bool isFrozen() const { 
    return d_freeze==0;
  };
  void printMessage() const;

  void makeUnique() const {
    if(d_freeze!=0) CountDupError::errorh(__LINE__);
    if((*Counted<T>::d_refcnt_p)> 1) {
      // stop looking at the multiply viewed T
      CountDup<T,TECHNIQUE> * alias = const_cast<CountDup<T,TECHNIQUE> *>(this);
      --(*alias->d_refcnt_p);
      // construct only-i-am-looking-at-T
      RECORDHERE(alias->d_refcnt_p = new int(1);)
      alias->d_data_p = TECHNIQUE::s_copy(*alias->d_data_p);
    } else if ((*Counted<T>::d_refcnt_p)<1) CountDupError::errorh(__LINE__);
  };
  bool operator ==(const CountDup & x) const {
    return (this==&x) || (*this)()==x();
  };
  bool operator !=(const CountDup & x) const { 
    return !((this==&x) || (*this)()==x());
  };
};
#endif
