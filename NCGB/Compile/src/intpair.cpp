// intpair.c

#include "intpair.hpp"
#include "MyOstream.hpp"

MyOstream & operator << (MyOstream & os,const intpair & aPair) {
  os << '(' << aPair.first() << ' ' << aPair.second() << ")\n";
  return os;
};

MyOstream & intpair::InstanceToOStream(MyOstream & os) const { 
  os << '(' << d_t << ' ' << d_u << ")\n";
  return os;
};
