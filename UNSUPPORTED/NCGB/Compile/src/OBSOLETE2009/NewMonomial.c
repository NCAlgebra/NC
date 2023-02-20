// NewMonomial.c

#include "NewMonomial.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"
#include "Variable.hpp"
#include "MLex.hpp"
#include "MyOstream.hpp"
#ifndef INCLUDED_OUMONOMIAL_H
#include "OuMonomial.hpp"
#endif

MonomialHelper::MonomialHelper(const AdmissibleOrder & x) : 
   d_order(x), d_v(), d_mult(x.multiplicity()), d_sz(0) {
  int n = d_mult;
  d_v.reserve(n);
  while(n) { d_v.push_back(0); --n;};
};

void MonomialHelper::commonMultiply(const Variable & x) {
  ++d_v[d_mult-((AdmWithLevels &)d_order).level(x)];
};

MyOstream & operator <<(MyOstream & os,const Monomial & aMonomial) {
  OuMonomial::NicePrint(os,aMonomial);
  return os;
};

bool Monomial::operator==(const Monomial & m) const {
  return d_data().LIST()==m.d_data().LIST();
};

// This is a memory leak, but it is only done once.
Copy<MonomialHelper> Monomial::s_one(*(new MLex(*new vector<vector<Variable> >)));

const AdmissibleOrder * Monomial::s_order_p = 0;
