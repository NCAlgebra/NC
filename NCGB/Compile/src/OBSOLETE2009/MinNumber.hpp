// MinNumber.h

#ifndef INCLUDED_MINNUMBER_H 
#define INCLUDED_MINNUMBER_H 

#include "Utilities.hpp"

template<class T>
class MinNumberSame {
  const T * d_t_p;
  const T * d_u_p;
public:
  MinNumberSame(T * t_p,T * u_p) :  d_t_p(t_p), d_u_p(u_p) {};
  ~MinNumberSame() {};
  int operator()() const {
    int first = (*d_t_p)();
    int second = (*d_u_p)();
    return first> second ? first : second;
  };
};

template<class T, class U>
class MinNumber {
  const T * d_t_p;
  const U * d_u_p;
public:
  MinNumber(T * t_p,U * u_p) :  d_t_p(t_p), d_u_p(u_p) {};
  ~MinNumber() {};
  int operator()() const {
    int first = (*d_t_p)();
    int second = (*d_u_p)();
    return first> second ? first : second;
  };
};
#endif
