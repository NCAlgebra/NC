// MmaSink.c

#include "MmaSink.hpp"
#include "stringGB.hpp"
#include "asStringGB.hpp"
#include "symbolGB.hpp"
#include "Sink.hpp"
#include "CountSink.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"
#include "Term.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "MyOstream.hpp"
#ifdef USE_VIRT_FIELD
#include "FieldRep.hpp"
#endif

#include "GBStream.hpp"

//#define DEBUG_MMASINK

MmaSink::~MmaSink() {};

void MmaSink::put(bool b) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:bool " << this << ' ' << b << '\n';
#endif
  if(b) {
    MLPutSymbol(d_mlink,"True");
  } else {
    MLPutSymbol(d_mlink,"False");
  };
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};

void MmaSink::put(int x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:int " << this << ' ' << x << '\n';
#endif
  MLPutInteger(d_mlink,x);
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};

void MmaSink::put(long x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:long " << this << ' ' << x << '\n';
#endif
  MLPutInteger(d_mlink,x);
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};

#ifdef USE_UNIX
void MmaSink::put(long long x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:long " << this << ' ' << x << '\n';
#endif
  MLPutInteger(d_mlink,x);
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};
#endif

void MmaSink::put(const char * x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink::symbol " << this << ' ' << x << '\n';
#endif
  MLPutSymbol(d_mlink,x);
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};

void MmaSink::put(const stringGB & x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:string " << this << x.value().chars() << '\n';
#endif
  MLPutString(d_mlink,(const char *)x.value().chars());
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};

void MmaSink::put(const symbolGB & x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:symbol " << this << ' ' << x.value().chars() << '\n';
#endif
  MLPutSymbol(d_mlink,(const char *) x.value().chars());
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};

void MmaSink::put(const asStringGB & x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:asString " << this << ' ' << x.value().chars() << '\n';
#endif
  MLPutString(d_mlink,(const char *)x.value().chars());
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};

void MmaSink::put(const Variable& x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:variable " << this << x.cstring() << '\n';
#endif
  MLPutFunction(d_mlink,"ToExpression",1L);
  MLPutString(d_mlink,x.cstring());
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};

#ifdef USE_VIRT_FIELD
void MmaSink::put(const Holder& h) {
  s_table.executeconst(*this,h);
#else
void MmaSink::put(const Holder&) {
  errorc(__LINE__);
#endif
};

#ifdef USE_VIRT_FIELD
void MmaSink::put(const Field & x) {
  Holder h((void *)&x.rep(),x.rep().ID());
  s_table.executeconst(*this,h);
};
#endif

#ifndef USE_VIRT_FIELD
void MmaSink::put(const Field & x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:number " << this << '\n';
#endif

  /* New version by MAURICIO that uses strings */
  MLPutFunction(d_mlink, "ToExpression", 1);
  MLPutString(d_mlink, x.str().c_str());

  /* COMMENTED BY MAURICIO, NOV 09
  const long long & num = x.numerator().internal();
  const long long & den = x.denominator().internal();

  if(den==1L) {
    MLPutInteger(d_mlink,num);
  } else {
    MLPutFunction(d_mlink,"Rational",2L);
    MLPutInteger(d_mlink,num);
    MLPutInteger(d_mlink,den);
  };
  */
  
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};
#endif
 
 void MmaSink::put(const Monomial& x) {
#ifdef DEBUG_MMASINK
   GBStream << "sink:monomial " << this << ' ' << x << '\n';
#endif
  int len = x.numberOfFactors();
  if(len==0) {
    MLPutInteger(d_mlink,1);
    ++d_count;
  } else if(len==1) {
    put(*x.begin());
  } else {
    MLPutFunction(d_mlink,"NonCommutativeMultiply",len);
    ++d_count;
    d_count -= len;
    MonomialIterator w = x.begin();
    while(len) {
      put(*w);
      --len;++w;
    };
  };
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
};

void MmaSink::put(const Term& x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:term " << this << ' ' << x << '\n';
#endif
  MLPutFunction(d_mlink,"Times",2L);
  ++d_count;
  d_count -= 2;
  put(x.CoefficientPart());
  put(x.MonomialPart());
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
};

void MmaSink::put(const Polynomial& x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:polynomial " << this << ' ' << x << '\n';
#endif
  int len = x.numberOfTerms();
  if(len==0) {
    MLPutInteger(d_mlink,0);
    ++d_count;
  } else if(len==1) {
    put(*x.begin());
  } else {
    MLPutFunction(d_mlink,"Plus",len);
    ++d_count;
    d_count -= len;
    PolynomialIterator w = x.begin();
    while(len) {
      put(*w);
      --len;++w;
    };
  };
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
};

void MmaSink::put(const GroebnerRule& x) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:rule " << this << ' ' << x << '\n';
#endif
  MLPutFunction(d_mlink,"Rule",2L);
  put(x.LHS());
  put(x.RHS());
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
};

ISink * MmaSink::clone() const {
#ifdef DEBUG_MMASINK
  GBStream << "sink:clone " << this << '\n';
#endif
  return new MmaSink(d_mlink);
};

Alias<ISink> MmaSink::outputFunction(const symbolGB & x,long L) {
#ifdef DEBUG_MMASINK
  GBStream << "sink:function " << x.value().chars() << ' ' << L << ' ' << this << '\n';
#endif
  Alias<ISink> result(outputFunction((const char *)x.value().chars(),L));
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  return result;
};

Alias<ISink> MmaSink::outputFunction(const char* x,long L) {
  if(!MLPutFunction(d_mlink,x,L)) errorc(__LINE__);
  ++d_count;
// DO NOT INCLUDE d_count -= L; since this will be done by the new MmaSink 
  Alias<ISink> al(new MmaSink(*this),Adopt::s_dummy);
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
return al;
};

void MmaSink::noOutput() {
#ifdef DEBUG_MMASINK
  GBStream << "sink:null" << this << '\n';
#endif
  if(!MLPutSymbol(d_mlink,"Null")) errorc(__LINE__);
#ifdef DEBUG_MMASINK
  checkforerror();
#endif
  ++d_count;
};

bool MmaSink::verror() const {
  return MLError(d_mlink)!=MLEOK;
};

void MmaSink::checkforerror() const {
  if(MLError(d_mlink)!=MLEOK) errorc(__LINE__);
};

#ifdef USE_VIRT_FIELD
#ifdef USE_UNIX
#include "SimpleTable.c"
#else
#include "SimpleTable.cpp"
#endif
#ifdef OLD_GCC
template class vector<pair<int,void(*)(MmaSink&,Holder &)> >;
template class vector<pair<int,void(*)(MmaSink&,const Holder &)> >;
#endif
template class SimpleTable<MmaSink>;
SimpleTable<MmaSink> MmaSink::s_table;
#endif

void MmaSink::errorh(int n) { DBGH(n); };

void MmaSink::errorc(int n) { DBGC(n); };

#include "idValue.hpp"

const int MmaSink::s_ID = idValue("MmaSink::s_ID");
