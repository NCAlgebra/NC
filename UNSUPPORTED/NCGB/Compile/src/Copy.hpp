// Mark Stankus 1999 (c)
// Copy.h

#ifndef INCLUDED_COPY_H
#define INCLUDED_COPY_H

#include "CountDup.hpp"
#include "Newing.hpp"

template<class T>
class Copy : public CountDup<T,Newing<T> > {
public:
  Copy() : CountDup<T,Newing<T> >() {};
  explicit Copy(const T & x) : CountDup<T,Newing<T> >(x) {};
  Copy(T * x,Adopt dummy) : CountDup<T,Newing<T> >(x,dummy) {};
  Copy(const Copy & x) : CountDup<T,Newing<T> >(x) {};
  ~Copy() {};
  void operator =(const Copy & x) { CountDup<T,Newing<T> >::operator=(x);};
  void operator =(const T & x) { CountDup<T,Newing<T> >::operator=(x);};
  T & access() { 
    CountDup<T,Newing<T> >::makeUnique();
    return * CountDup<T,Newing<T> >::d_data_p;
  };
};
#endif
