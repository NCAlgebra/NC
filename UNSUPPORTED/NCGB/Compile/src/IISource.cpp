// (c) Mark Stankus 1999
// IISource.c

#include "IISource.hpp"
#include "symbolGB.hpp"
#include "StringAccumulator.hpp"
#include "GBInputNumbers.hpp"
#include "TellHead.hpp"
#include "Debug1.hpp"
#include "Field.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "Term.hpp"
#include "MyOstream.hpp"

IISource::~IISource() {};

void IISource::get(Field& x) {
  int type = getType();
  if(type==GBInputNumbers::s_IOINTEGER) {
    int i;
    ((ISource*)this)->get(i);
    x = Field(i);
  } else if(type==GBInputNumbers::s_IOFUNCTION) {
    int i,j;
    symbolGB y;
    Alias<ISource> iso(inputFunction(y));
    if(y=="Rational") {
      iso.access().get(i);
      iso.access().get(j);
      x = Field(i,j);
    } else {
      TellHead(iso.access());
      DBG(); // Why would the code be here?
    }
  } else {
    TellHead(*this);
    DBG(); // Why would the code be here?
  }
};

void IISource::get(Variable& x) {
  int type = getType();
  if(type==GBInputNumbers::s_IOSYMBOL) {
    symbolGB y;
    ((ISource *)this)->get(y);
    x.assign(y.value().chars());
  } else if(type==GBInputNumbers::s_IOFUNCTION) {
    StringAccumulator acc; 
    getAnything(acc);
    x.assign(acc.chars());
  } else DBG();
};

void IISource::get(Monomial& x) {
#if 1
  x.setToOne();
  Variable v;
  int type = getType();
  if(type==GBInputNumbers::s_IOFUNCTION) {
    pair<bool,Alias<ISource> > pr(queryNamedFunction("NonCommutativeMultiply"));
    if(pr.first) {
      while(!pr.second.access().eoi()) {
        pr.second.access().get(v);
        x *= v;
      };
    } else {
      get(v);
      x *= v;
    };
  } else if(type==GBInputNumbers::s_IOINTEGER) {
    int i;
    ((ISource *)this)->get(i);
    if(i!=1) DBG();
  } else if(type==GBInputNumbers::s_IOSYMBOL) {
    get(v);
    x *= v;
  } else {
    TellHead(*this);
    DBG();
  };
#else
  DBG();
#endif
};

void IISource::get(Term& x) {
#if 1
  x.setToOne();
  int type = getType();
  if(type==GBInputNumbers::s_IOFUNCTION) {
    pair<bool,Alias<ISource> > pr(queryNamedFunction("Times"));
    if(pr.first) {
      pr.second.access().get(x.Coefficient());
      pr.second.access().get(x.MonomialPart());
    } else {
      pair<bool,Alias<ISource> > pr2(queryNamedFunction("Rational"));
      if(pr2.first) {
        pr2.second.access().get(x.Coefficient());
      } else {
        get(x.MonomialPart());
      };
    };
  } else if(type==GBInputNumbers::s_IOINTEGER) {
    get(x.Coefficient());
  } else {
    get(x.MonomialPart());
  };
#else
  DBG();
#endif
};

void IISource::get(Polynomial & x) {
#if 1
  x.setToZero();
  Term t;
  int type = getType();
  bool todo = true;
  if(type==GBInputNumbers::s_IOFUNCTION) {
    pair<bool,Alias<ISource> > pr(queryNamedFunction("Plus"));
    if(pr.first) {
      list<Term> L;
      while(!pr.second.access().eoi()) {
        pr.second.access().get(t);
        L.push_back(t);
      }
      x.setWithList(L);
      todo = false;
    };
  };
  if(todo) {
    Term t;
    get(t);
    x = t;
    todo = false;
  };
#else
  DBG();
#endif
};

void IISource::get(GroebnerRule & x) {
  Alias<ISource> iso(inputNamedFunction("Rule"));
  iso.access().get(x.LHS());
  iso.access().get(x.RHS());
};

void IISource::getAnything(StringAccumulator & acc) {
  int type = getType();
  symbolGB y;
  if(type==GBInputNumbers::s_IOSYMBOL) {
    get(y);
    acc.add(y.value().chars());
  } else {
    Alias<ISource> iso(inputFunction(y));
    acc.add(y.value().chars());
    bool first = true;
    while(!iso().eoi()) {
      if(!first) acc.add(',');
      ((IISource &)iso.access()).getAnything(acc);
    };
  };
};
