// SPIID.c

#include "SPIID.hpp"
#include "MyOstream.hpp"

MyOstream & operator<<(MyOstream & os,const SPIID & x) {
  os << x.d_data;
  return os;
};
