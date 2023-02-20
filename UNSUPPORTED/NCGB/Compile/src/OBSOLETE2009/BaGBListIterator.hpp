// BaGBListIterator.h

#ifndef INCLUDED_BAGBLISTITERATOR_H
#define INCLUDED_BAGBLISTITERATOR_H

#include "ListChoice.hpp"

#ifdef USE_OLD_GBLIST

#ifdef DEBUGGBListIterator
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#endif

#ifndef INCLUDED_DLLIST_H
#include "DLList.hpp"
#endif
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
class MyOstream;

class BaGBListIterator {
  static void errorh(int);
  static void errorc(int);
  void operator = (const BaGBListIterator & x);
    // not implemented
public:
  BaGBListIterator(); 
  BaseDLList * _ptr;
  Pix _p;
#ifdef DEBUGGBListIterator
  int _n;
#endif

  BaGBListIterator(const BaGBListIterator & ptr);
  explicit BaGBListIterator(BaseDLList & ptr);
  BaGBListIterator(Pix p,BaseDLList & ptr);
protected:
  virtual ~BaGBListIterator(); 
  void assign(const BaGBListIterator &);
public:
  bool operator ==(const BaGBListIterator & x) const;
  bool operator !=(const BaGBListIterator & x) const;
  void operator ++();
  void operator ++(int);
  void operator --();
  void operator --(int);
  void advance(int n);
  friend MyOstream & operator <<(MyOstream & os,const BaGBListIterator & iter);
};

inline void BaGBListIterator::assign(const BaGBListIterator & r) {
  _ptr = r._ptr;
  _p   = r._p;
#ifdef DEBUGGBListIterator
  _n   = r._n;
#endif
}

inline bool BaGBListIterator::operator ==(const BaGBListIterator & iter) 
    const {  
  return (_p)== (iter._p);
}

inline bool BaGBListIterator::operator !=(const BaGBListIterator & iter) 
   const { return !((*this)==iter);};

inline BaGBListIterator::BaGBListIterator() : _ptr(0), _p(0) { }
 
inline BaGBListIterator::BaGBListIterator(BaseDLList & ptr) :
   _ptr(&ptr), _p(0)
#ifdef DEBUGGBListIterator
    ,_n(1)
#endif
{
  _p = _ptr->first();
}
 
inline
BaGBListIterator::BaGBListIterator(Pix p, BaseDLList & ptr) :
   _ptr(&ptr), _p(p)
#ifdef DEBUGGBListIterator
    ,_n(1)
#endif
{ };

inline
BaGBListIterator::BaGBListIterator(const BaGBListIterator & ptr) : 
     _ptr(ptr._ptr), _p(ptr._p) 
#ifdef DEBUGGBListIterator
    ,_n(ptr._n)
#endif
{ };

inline void BaGBListIterator::operator ++() {
  if(_p==0) errorh(__LINE__);
  _ptr->next(_p);
#ifdef DEBUGGBListIterator
  ++_n;
  if(_n>_ptr->length()+1) errorh(__LINE__);
#endif
};

inline void BaGBListIterator::operator --() {
  if(_p==0) { 
    _p = _ptr->last();
  } else {
    _ptr->prev(_p);
  }; 
#ifdef DEBUGGBListIterator
  --_n;
  if(_n<=0) errorh(__LINE__);
#endif
};
#endif 
#endif
