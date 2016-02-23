// Wreath.c

#include "Wreath.hpp"
#include "RecordHere.hpp"
#include "load_flags.hpp"
#include "GroebnerRule.hpp"
#include "Monomial.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#ifndef INCLUDED_FSTREAM_H
#define INCLUDED_FSTREAM_H
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#endif
#include "MyOstream.hpp"

Wreath::Wreath(const vector<vector<Variable> > & L,
   vector<AdmissibleOrder *> ords) : AdmWithLevels(s_ID,L), d_ords(ords) {};

Wreath::Wreath(const Wreath & x) : 
    AdmWithLevels(x),
    d_ords(){
  d_ords.reserve(x.d_ords.size());
  vector<AdmissibleOrder *>::const_iterator w = x.d_ords.begin();
  vector<AdmissibleOrder *>::const_iterator e = x.d_ords.end();
  while(w!=e) {
    d_ords.push_back((*w)->clone());
    ++w;
  };
};

Wreath::~Wreath(){};

bool Wreath::verify(const GroebnerRule &) const { 
  bool result = true;
  DBG();
  return result;
};

bool Wreath::verify(const Polynomial &) const {
  bool result = true;
  DBG();
  return result;
};

void Wreath::convert(const Polynomial &,GroebnerRule &) const {
  DBG();
};

bool Wreath::monomialLess(const Monomial & first,const Monomial & second) const {
  bool result = false;
  Monomial FIRST, SECOND;
  vector<AdmissibleOrder *>::const_reverse_iterator w = d_ords.rbegin();
  for(int m = multiplicity();m>=1;--m,++w) {
    FIRST = grabAtLevel(m,first);
    SECOND = grabAtLevel(m,second);
    if(FIRST!=SECOND) {
      result = (*w)->monomialLess(FIRST,SECOND);
      break;
    };
  };
  return result;
};

Monomial Wreath::grabAtLevel(int aLevel,const Monomial & first) const {
  Monomial result;
  MonomialIterator w = first.begin();
  const int sz = first.numberOfFactors();
  for(int i=1;i<=sz;++i,++w) {
    const Variable & v = *w;
    if(level(v)==aLevel) result *= v;
  };
  return result;
};

void Wreath::ClearOrder() {
  d_ords.erase(d_ords.begin(),d_ords.end());
  vector<vector<Variable> > empty;
    // do not delete
  setVariables(empty);
};

void Wreath::PrintOrder(MyOstream &  os) const {
  if(!s_seperator) {
    RECORDHERE(s_seperator = new char[2];)
    s_seperator[0] ='\xa7';
    s_seperator[1] = '\0';
  };
  PrintOrderViaString(os,s_seperator);
};      

AdmissibleOrder * Wreath::clone() const {
  RECORDHERE(Wreath * p = new Wreath(*this);)
  return p;
};

#ifndef INCLUDED_IDVALUE_H
#include "idValue.hpp"
#endif

const int Wreath::s_ID = idValue("Wreath::s_ID");

char * Wreath::s_seperator = 0;
