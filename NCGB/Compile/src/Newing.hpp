// Mark Stankus 1999 (c)
// Newing.h 

#ifndef INCLUDED_NEWING_H
#define INCLUDED_NEWING_H

template<class T>
struct Newing {
  static T * s_copy()            { return new T();};
  static T * s_copy(const T & x) { return new T(x);};
};
#endif
