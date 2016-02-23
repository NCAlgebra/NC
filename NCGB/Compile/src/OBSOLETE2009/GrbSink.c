// GrbSink.c

#include "GrbSink.hpp"
#include "stringGB.hpp"
#include "symbolGB.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"
#include "Term.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "Field.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif

GrbSink::~GrbSink() {};

Sink & GrbSink::operator<<(int x) {
  d_ofs << x;
  return * this;
};

Sink & GrbSink::operator<<(const stringGB & x) {
  d_ofs << '\"' << x.value().chars() << '\"';
  return * this;
};

Sink & GrbSink::operator<<(const symbolGB & x) {
  d_ofs << x.value().chars();
  return * this;
};

Alias<ISink> GrbSink::outputFunction(const symbolGB & x,long len) {
  DBG();
  return *(Alias<ISink>*)0;
};

Alias<ISink> GrbSink::outputFunction(const char * x,long len) {
  DBG();
  return *(Alias<ISink>*)0;
};

Sink & GrbSink::operator<<(const Field& x) {
// MUST print + or -
  DBG();
  return * this;
};

Sink & GrbSink::operator<<(const Variable& x) {
  d_ofs << x.cstring();
  return * this;
};

Sink & GrbSink::operator<<(const Monomial& x) {
  int len = x.numberOfFactors();
  if(len==0) {
    d_ofs << "(1)";
  } else {
    MonomialIterator w = x.begin();
    while(len) {
      operator<<(*w);
      --len;++w;
    };
  };
  return * this;
};

Sink & GrbSink::operator<<(const Term& x) {
  const Field & f = x.CoefficientPart();
  const Monomial & m = x.MonomialPart();
  if(!f.one()) {
    operator<<(f);
    if(!m.numberOfFactors()==1) {
      d_ofs << " * ";
      operator<<(x.MonomialPart());
    }
  } else {
    operator<<(x.MonomialPart());
  };
  return * this;
};

Sink & GrbSink::operator<<(const Polynomial& x) {
  int len = x.numberOfTerms();
  if(len==0) {
    d_ofs << 0;
  } else {
    PolynomialIterator w = x.begin();
    while(len) {
      operator<<(*w);
      --len;++w;
    };
  };
  return * this;
};
