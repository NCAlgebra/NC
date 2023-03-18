//  LINTEGER.c

#include "LINTEGER.hpp"
#include "MyOstream.hpp"

bool LINTEGER::s_gcds = true;

MyOstream & operator << (MyOstream & os,const LINTEGER & aI) {
  os << aI.internal();
  return os;
};
