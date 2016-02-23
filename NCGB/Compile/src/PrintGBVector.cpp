// PrintGBVector.c

#include "PrintGBVector.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"

template<class T>
void PrintGBVector(const char * s,const GBVector<T> & x) {
  GBStream << "The vector: " << s << '\n';
  typename GBVector<T>::const_iterator w = x.begin();
  const int sz = x.size();
  GBStream << '{';
  for(int i=1;i<=sz;++i,++w) {
    if(i!=1) GBStream << ',';
    GBStream << * w << '\n';
  };
  GBStream << "}\n";
};

template void PrintGBVector(const char *, const GBVector<bool> &);
template void PrintGBVector(const char *, const GBVector<int> &);
