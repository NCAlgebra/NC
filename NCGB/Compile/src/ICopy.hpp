// Mark Stankus 1999 (c)
// ICopy.h

#ifndef INCLUDED_ICOPY_H
#define INCLUDED_ICOPY_H

#include "CountDup.hpp"
#include "Choice.hpp"
#include "Cloning.hpp"
#ifdef OLD_GCC
#include "Debug1.hpp"
#endif

template<class T>
class ICopy : public CountDup<T,Cloning<T> > {
  static void errorh(int);
  static void errorc(int);
public:
  ICopy() : CountDup<T,Cloning<T> >() {};
  explicit ICopy(const T & x) : CountDup<T,Cloning<T> >(x) {};
  ICopy(T * x,Adopt dummy) : CountDup<T,Cloning<T> >(x,dummy) {};
  ICopy(const ICopy & x) : CountDup<T,Cloning<T> >(x) {};
  ~ICopy() {};
  void operator =(const ICopy & x) { 
    CountDup<T,Cloning<T> >::operator=(x);
  };
  void operator =(const T & x) { 
    CountDup<T,Cloning<T> >::operator=(x);
  };
  T & access() { 
    CountDup<T,Cloning<T> >::makeUnique();
    return * CountDup<T,Cloning<T> >::d_data_p;
  };
#ifdef OLD_GCC
  bool operator<(const ICopy<T> &) const {
     errorh(__LINE__);
     return true;
  };
#endif
};
#endif
