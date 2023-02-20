// NCASink.c

#include "NCASink.hpp"
#include "idValue.hpp"
#include "Choice.hpp"
#ifdef USE_VIRT_FIELD
#include "Holder.hpp"
#include "FieldRep.hpp"
#endif
#include "asStringGB.hpp"
#include "stringGB.hpp"
#include "symbolGB.hpp"
#include "TheChoice.hpp"
#ifdef USE_GB
#include "Variable.hpp"
#include "Monomial.hpp"
#include "Term.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "FieldChoice.hpp"
#endif
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif

NCASink::~NCASink() {};

void NCASink::put(bool x) {
  if(x) {
    d_ofs << " true ";
  } else {
    d_ofs << " false ";
  };
};

void NCASink::put(int x) {
  d_ofs << x;
};

void NCASink::put(long x) {
  d_ofs << x;
};

#ifdef USE_UNIX
void NCASink::put(long long x) {
  d_ofs << x;
};
#endif

void NCASink::put(const stringGB & x) {
  d_ofs << x.value().chars();
};

void NCASink::put(const asStringGB & x) {
  d_ofs << x.value().chars();
};

void NCASink::put(const symbolGB & x) {
  d_ofs << x.value().chars();
};

Alias<ISink> NCASink::outputFunction(const symbolGB & x,long) {
  errorc(__LINE__);
  d_ofs << x.value().chars();
  return *(Alias<ISink> *)0;
};

Alias<ISink> NCASink::outputFunction(const char * x,long) {
  errorc(__LINE__);
  d_ofs << x;
  return *(Alias<ISink> *)0;
};

#ifdef USE_GB
void NCASink::put(const Field& x) {
#ifdef USE_VIRT_FIELD
  Holder h2((void *)&x.rep(),x.rep().ID());
  s_table.execute(*this,h2);
#else
  int top = x.numerator().internal();
  if(top==0) {
    d_ofs << " + 0";
  } else if(top>0) {
    if(s_showPlusWithNumbers) {
      d_ofs << " + ";
    };
    if(x.denominator().one()) {
      d_ofs << top;
    } else {
      d_ofs << "\\frac{" << top << "}{" << x.denominator().internal() << '}';
    };
  } else {
    d_ofs << " - ";
    if(x.denominator().one()) {
      d_ofs << -top;
    } else {
      d_ofs << "\\frac{" << -top << "}{" << x.denominator().internal() << '}';
    };
  };
#endif
};

void NCASink::put(const Variable& x) {
  d_ofs << x.cstring();
};

void NCASink::put(const Monomial& x) {
  int len = x.numberOfFactors();
  if(len==0) {
    d_ofs << '1';
  } else if(len==1) {
    put(*x.begin());
  } else {
    MonomialIterator w = x.begin();
    put(*w);
    --len;++w;
    while(len) {
      d_ofs << " ** ";
      put(*w);
      --len;++w;
    };
  };
};

void NCASink::put(const Term& x) {
  const Field & f = x.CoefficientPart();
  const Monomial & m = x.MonomialPart();
  if(!f.one()) {
    put(f);
    if(!m.numberOfFactors()==1) {
      d_ofs << " * ";
      put(x.MonomialPart());
    }
  } else {
    put(x.MonomialPart());
  };
};

void NCASink::put(const Polynomial& x) {
  int len = x.numberOfTerms();
  if(len==0) {
    d_ofs << '0';
  } else if(len==1) {
    put(*x.begin());
  } else {
    PolynomialIterator w = x.begin();
    put(*w);
    --len;++w;
    while(len) {
      d_ofs << " + ";
      put(*w);
      --len;++w;
    };
  };
};

void NCASink::put(const GroebnerRule& x) {
  put(x.LHS());
  d_ofs << " -> ";
  put(x.RHS());
};
#endif

ISink * NCASink::clone() const {
  return new NCASink(d_ofs);
};

void NCASink::put(const char * s) {
  d_ofs << s;
};

bool NCASink::s_showPlusWithNumbers = true;
bool NCASink::s_CollapsePowers = false;


void NCASink::errorh(int n) { DBGH(n); };

void NCASink::errorc(int n) { DBGC(n); };

const int NCASink::s_ID = idValue("NCASink::s_ID");

#ifdef USE_VIRT_FIELD
#include "Choice.hpp"
#ifdef USE_UNIX
#include "SimpleTable.c"
#else
#include "SimpleTable.cpp"
#endif
template class SimpleTable<NCASink>;
SimpleTable<NCASink> NCASink::s_table;
#endif
