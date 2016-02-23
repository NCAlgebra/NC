// PrintVector.c

#include "PrintVector.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"

template<class T>
void PrintVector(const char * s,const vector<T> & x,const char * after) {
  GBStream << "The vector: " << s << '\n';
  typename vector<T>::const_iterator w = x.begin();
  const int sz = x.size();
  GBStream << '{';
  if(sz>0) {
    GBStream << * w << after;
    ++w;
    for(int i=2;i<=sz;++i,++w) {
      GBStream << ',' << * w << after;
    };
  };
  GBStream << "}\n";
};

#include "GroebnerRule.hpp"
template void PrintVector(const char *, const vector<bool> &,const char *);
template void PrintVector(const char *, const vector<int> &,const char *);
template void PrintVector(const char *, const vector<GroebnerRule> &,const char *);
template void PrintVector(const char *, const vector<Variable> &,const char *);
