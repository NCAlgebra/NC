// (c) Mark Stankus 1999
// WFileSink.c

#include "Choice.hpp"
#ifdef USE_WFILE
#include "WFileSink.hpp"
#include "Debug1.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"
#include "Term.hpp"
#include "Field.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "stringGB.hpp"
#include "symbolGB.hpp"
#include "asStringGB.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif

WFileSink::~WFileSink() {};

void WFileSink::put(const Field&) {
  DBG();
};

void WFileSink::put(const Variable& x) {
  const char * p = x.cstring();
  d_ofs << 'S' << strlen(p) << 'Y' << p << '\n';
};

void WFileSink::put(const Monomial& x) {
  const int sz = x.numberOfFactors();
  d_ofs << "F" << strlen("NonCommutativeMultiply") 
        << "N" <<  sz << "C" <<  "NonCommutativeMultiply\n";
  MonomialIterator w = x.begin(); 
  for(int i=1;i<=sz;++i) {
    put(*w);
  };
};

void WFileSink::put(const Term& x) {
  d_ofs << "F4N2CTimes\n";
  put(x.CoefficientPart());
  put(x.MonomialPart());
};

void WFileSink::put(const RuleID &) {
  DBG();
};

void WFileSink::put(const Polynomial& x) {
  const int sz = x.numberOfTerms();
  d_ofs << "F" << strlen("Plus") 
        << "N" <<  sz << "C" <<  "Plus\n";
  PolynomialIterator w = x.begin(); 
  for(int i=1;i<=sz;++i) {
    put(*w);
  };
};

void WFileSink::put(const GroebnerRule& x) {
  d_ofs << "F4N2CRule\n";
  put(x.LHS());
  put(x.RHS());
};

void WFileSink::noOutput() {
  d_ofs << "S4YNull\n";
};

WFileSink::WFileSink(ofstream & ofs)  : d_ofs(ofs) {
};

void WFileSink::put(bool) {  
  DBG();
};

void WFileSink::put(int x) {
  d_ofs << "I0N" << x << '\n';
};

void WFileSink::put(long x) {
  d_ofs << "I0N" << x << '\n';
};

#ifdef USE_UNIX
void WFileSink::put(long long x) {
  d_ofs << "I0N" << x << '\n';
};
#endif

void WFileSink::put(const stringGB & x) {
  const char * p = x.value().chars();
  d_ofs << 'S' << strlen(p) << 'T' << p << '\n';
};

void WFileSink::put(const symbolGB & x) {
  const char * p = x.value().chars();
  d_ofs << 'S' << strlen(p) << 'Y' << p << '\n';
};

void WFileSink::put(const char * x) {
  d_ofs << 'S' << strlen(x) << 'Y' << x << '\n';
};


void WFileSink::put(const asStringGB & x) {
  const char * p = x.value().chars();
  d_ofs << 'S' << strlen(p) << 'T' << p << '\n';
};

Alias<ISink> WFileSink::outputFunction(const symbolGB &,long L) {
  DBG();
  return *(Alias<ISink> *)0;
};

Alias<ISink> WFileSink::outputFunction(const char * s,long L) {
  DBG();
  return *(Alias<ISink> *)0;
};

ISink * WFileSink::clone() const {
  DBG();
  return (ISink *)0;
};
#endif
