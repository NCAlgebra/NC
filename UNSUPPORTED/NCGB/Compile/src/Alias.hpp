// Alias.h

#ifndef INCLUDED_ALIAS_H
#define INCLUDED_ALIAS_H

#include "CountDup.hpp"
#include "MakeAlias.hpp"

template<class T>
class Alias : public CountDup<T,MakeAlias<T> > {
public:
  Alias() : CountDup<T,MakeAlias<T> >() {};
  explicit Alias(const T & x) : CountDup<T,MakeAlias<T> >(x) {};
  Alias(T * x,Adopt dummy) : CountDup<T,MakeAlias<T> >(x,dummy) {};
  Alias(const Alias & x) : CountDup<T,MakeAlias<T> >(x) {};
  ~Alias() {};
  void operator =(const Alias & x) { 
    CountDup<T,MakeAlias<T> >::operator=(x);
  };
  void operator =(const T & x) { 
    CountDup<T,MakeAlias<T> >::operator=(x);
  };
  T & access() { 
    return * CountDup<T,MakeAlias<T> >::d_data_p;
  };
  const T & operator()() const { 
    return * CountDup<T,MakeAlias<T> >::d_data_p;
  };
};
#endif
