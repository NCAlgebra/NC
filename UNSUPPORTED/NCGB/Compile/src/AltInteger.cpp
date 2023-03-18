//  INTEGER.c

#include "AltInteger.hpp"
#include "MyOstream.hpp"

bool INTEGER::s_gcds = true;

MyOstream & operator << (MyOstream & os,const INTEGER & aI) {
  os << aI.internal();
  return os;
};
