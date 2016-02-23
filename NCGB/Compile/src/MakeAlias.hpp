// MakeAlias.h 

#ifndef INCLUDED_MAKEALIAS_H
#define INCLUDED_MAKEALIAS_H

template<class T>
struct MakeAlias {
  static T * s_copy()            { return 0;};
  static T * s_copy(const T & x) { return const_cast<T*>(&x);};
};
#endif
