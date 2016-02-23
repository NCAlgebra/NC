// Mark Stankus 1999 (c)
// Cloning.h 

#ifndef INCLUDED_CLONING_H
#define INCLUDED_CLONING_H

template<class T>
struct Cloning {
  static T * s_copy()            { return 0;};
  static T * s_copy(const T & x) { return x.clone();};
};
#endif
