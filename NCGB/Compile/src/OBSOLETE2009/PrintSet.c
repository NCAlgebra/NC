// PrintSet.c

#include "PrintSet.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"

template<class T,class U>
void PrintSet(const char * s,const set<T,U> & x) {
  PrintSet(GBStream,s,x);
};

template<class T,class U>
void PrintSet(MyOstream &os,const char * s,const set<T,U> & x) {
  os << "The list: " << s << '\n';
  set<T,U>::const_iterator w(x.begin());
  const int sz = x.size();
  os << '{';
  for(int i=1;i<=sz;++i,++w) {
    if(i!=1) os << ',';
    os << * w << '\n';
  };
  os << "}\n";
};

#ifdef HAS_INCLUDE_NO_DOTS
#include <functional>
#else
#include <function.h>
#endif
template void PrintSet(const char *, const set<int,less<int> > &);
#include "GroebnerRule.hpp"
#include "Monomial.hpp"
#include "ByAdmissible.hpp"
template void PrintSet(const char *, const set<GroebnerRule,ByAdmissible> &);
template void PrintSet(const char *, const set<Monomial,ByAdmissible> &);
template void PrintSet(MyOstream&,const char *, const set<Monomial,ByAdmissible> &);
