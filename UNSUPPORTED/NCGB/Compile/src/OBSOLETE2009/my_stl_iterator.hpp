// my_stl_iterator.h

#ifndef INCLUDED_MY_STL_ITERATOR_H
#define INCLUDED_MY_STL_ITERATOR_H

// 
// Name: LowerTriangular
//
// Given iterators w,e in the constructor, construct an 
// iterator class such that we proceed through all pairs
// (w1,w2) with w1 equal to or  coming before w2.
// Due to technical issues, operator * returns 
// a pair (&*w1,&*w2).
//
// For any iterator x of type LowerTriangular<ITER,T>
// ((*x).first) is a dereferenced element which is the same as
// or before ((*x).second).


template<class ITER,class T>
class LowerTriangular {
  ITER d_save,d_w1,d_w2,d_e;
public:
  LowerTriangular(ITER w,ITER e) : d_save(w), d_w1(w), d_w2(w), d_e(e) {};
  pair<T *,T *> operator *() {
    pair<T*,T*> pr(&(*d_w1),&(*d_w2));
    return pr;
  };
  void operator++() { 
    if(d_w1==d_w2) {
      ++d_w2;d_w1 = d_save;
    } else {
      ++d_w1;
    };
  };
};

//  
// Name: AssociatedValue<ITER,CL,VAL>
// 
// Description:
//    Have an iterator based on an iterator.
//    The new iterator calls a member function for the dereferenced original
//      iterator.
//
//
// Technical description:
//    AssociatedValue<ITER,CL,VAL> x(w,func)
// is well defined if 
//  (1) w is an iterator of type ITER,
//  (2) *w is of type CL
//  (3) class CL has a member function taking no arguments are returning
//      an element of type VAL
//
//  When ++x is encountered, the internal iterator of type ITER is incremented
//  via operator++.
//
//  When *x is encountered,  the value w->*func() is returned.

template<class ITER,class CL,class TIME>
class AssociatedValue {
  ITER d_w;
  VAL (T::*d_time)();
public:
  AssociatedValue(ITER w,VAL (T::*time)())  : d_w(w), d_time(time) {};
  VAL operator *() { return d_w->*d_time();};
  void operator++() { ++d_w;};
  bool operator==(TimeIter & x) { return d_w==x.d_w;};
  bool operator!=(TimeIter & x) { return d_w!=x.d_w;};
};

#endif
