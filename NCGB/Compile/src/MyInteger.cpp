//  MyInteger.c

#include "MyInteger.hpp"
#include "FieldChoice.hpp"
#ifdef USE_MyInteger
#include "MyOstream.hpp"

bool MyInteger::s_gcds = true;

MyOstream & operator << (MyOstream & os,const MyInteger & x) {
  os << x;
  return os;
};
#endif
