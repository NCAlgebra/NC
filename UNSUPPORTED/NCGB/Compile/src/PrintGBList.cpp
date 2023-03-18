// PrintGBList.c

#include "PrintGBList.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"

template<class T>
void PrintGBList(const char * s,const GBList<T> & x) {
  PrintGBListStream(s,x,GBStream);
};

template<class T>
void PrintGBListStream(const char * s,const GBList<T> & x,MyOstream & os) {
  if(s) os << "The list: " << s << '\n';
  typename GBList<T>::const_iterator w = x.begin();
  const int sz = x.size();
  os << '{';
  for(int i=1;i<=sz;++i,++w) {
    if(i!=1) os << ',';
    os << * w << '\n';
  };
  os << "}\n";
  os.flush();
};

#include "simpleString.hpp"
#include "GBMatch.hpp"
#include "SPIID.hpp"
#include "GroebnerRule.hpp"
template void PrintGBList(const char *, const GBList<int> &);
template void PrintGBList(const char *, const GBList<simpleString> &);
template void PrintGBList(const char *, const GBList<Match> &);
template void PrintGBList(const char *, const GBList<SPIID> &);
template void PrintGBList(const char *, const GBList<GroebnerRule> &);
template void PrintGBList(const char *, const GBList<Polynomial> &);
template void PrintGBList(const char *, const GBList<Variable> &);

template void PrintGBListStream(const char *, const GBList<int> &,MyOstream &);
template void PrintGBListStream(const char *, const GBList<simpleString> &,MyOstream &);
template void PrintGBListStream(const char *, const GBList<Match> &,MyOstream &);
template void PrintGBListStream(const char *, const GBList<SPIID> &,MyOstream &);
template void PrintGBListStream(const char *, const GBList<GroebnerRule> &,MyOstream &);
template void PrintGBListStream(const char *, const GBList<Polynomial> &,MyOstream &);
template void PrintGBListStream(const char *, const GBList<Variable> &,MyOstream &);
