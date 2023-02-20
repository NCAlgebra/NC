// PrintList.c

#include "PrintList.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"

template<class T>
void PrintList(const char * s,const list<T> & x) {
  GBStream << "The list: " << s << '\n';
  typename list<T>::const_iterator w = x.begin();
  const int sz = x.size();
  GBStream << '{';
  for(int i=1;i<=sz;++i,++w) {
    if(i!=1) GBStream << ',';
    GBStream << * w << '\n';
  };
  GBStream << "}\n";
};

#ifndef INCLUDED_POLYNOMIAL_H
#include "Polynomial.hpp"
#endif
#ifndef INCLUDED_MONOMIAL_H
#include "Monomial.hpp"
#endif
#include "Variable.hpp"
#include "Copy.hpp"
#include "GBHistory.hpp"
#include "GroebnerRule.hpp"

template void PrintList(const char *, const list<GroebnerRule> &);
template void PrintList(const char *, const list<GBHistory> &);
template void PrintList(const char *, const list<Polynomial> &);
template void PrintList(const char *, const list<Monomial> &);
template void PrintList(const char *, const list<int> &);
template void PrintList(const char *, const list<Variable> &);
template void PrintList(const char *, const list<Term> &);
