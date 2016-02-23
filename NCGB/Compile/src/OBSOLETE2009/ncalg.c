// ncalg.c


#include "GBInput.hpp"
#include "GBOutput.hpp"
#include "MyOstream.hpp"
#include "Polynomial.hpp"
#include "stringGB.hpp"
#include "Monomial.hpp"
#include "Field.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"

void monomial2opal(const vector<int> & vec,const Monomial& p,MyOstream & os) {
  const int sz = p.numberOfFactors();
  MonomialIterator w = p.begin();
  int n;
  for(int i=1;i<=sz;++i,++w) {
    n = vec[(*w).stringNumber()];
    os << ('a'+n);
  };
};

void term2opal(const vector<int> & vec,const Term & p,MyOstream & os) {
  p.CoefficientPart().print(os);
  monomial2opal(vec,p.MonomialPart(),os);
};

void polynomial2opal(const vector<int> & vec,const Polynomial & p,
    MyOstream & os) {
  int sz = p.numberOfTerms();
  if(sz==0) {
    os << "0";
  } else {
    PolynomialIterator w = p.begin();
    for(int i=1;i<sz;++i,++w) {
      const Term & t = *w;
      term2opal(vec,t,os);
      os << " + ";
    };
    const Term & t = *w;
    term2opal(vec,t,os);
    os << ";\n";
  };
};

void ncalg2opal(const list<Variable> & L,const list<Polynomial> & M,
    const char * s) {
  const int sz = Variable::s_largestStringNumber();
  const int vsz = L.size();
  vector<int> vec;
  vec.reserve(sz+1);
  for(int i=0;i<=sz;++i) vec.push_back(-1);
  list<Variable>::const_iterator w = L.begin();
  for(int j=0;j<vsz;++j,++w)  {
    vec[(*w).stringNumber()] = j;
  };
//  MyOstream os(s);
  list<Polynomial>::const_iterator ww = M.begin();
  list<Polynomial>::const_iterator ee = M.end();
  while(ww!=ee) {
    polynomial2opal(vec,*ww,GBStream);
    ++ww;
  };
};

void _OutputRelationsAsOpal(Source & so,Sink & si) {
  list<Variable> L;
  list<Polynomial> M;
  GBInput(L,ioh);
  GBInput(M,ioh);
  stringGB x;
  so >> x;
  so.shouldBeEnd();
  ncalg2opal(L,M,"ncalg_out");
  si.noOutput();
};
