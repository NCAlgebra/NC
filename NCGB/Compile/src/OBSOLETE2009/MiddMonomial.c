// (c) Mark Stankus 1999
// MiddMonomial.c

#include "MiddMonomial.hpp"
#include "RecordHere.hpp"
#include "SetSlot.hpp"
#include "load_flags.hpp"
#include "MyOstream.hpp"
#include "OuMonomial.hpp"

int s_NumberMonomialTotal = 0;
int s_NumberMonomialNow = 0;

Monomial::Monomial() { 
  d_factors = s_one;
  d_numberOfFactors = 0;
#ifdef DEBUG_MONOMIAL
 ++s_NumberMonomialTotal;
 ++s_NumberMonomialNow;
GBStream << "total number of monomials:" << s_NumberMonomialTotal << "\n";
GBStream << "present number of monomials:" << s_NumberMonomialNow << "\n";
#endif
};

Monomial::Monomial(const Monomial & x)  {
  d_numberOfFactors= x.d_numberOfFactors;
  d_factors = x.d_factors;
#ifdef DEBUG_MONOMIAL
 ++s_NumberMonomialTotal;
 ++s_NumberMonomialNow;
GBStream << "total number of monomials:" << s_NumberMonomialTotal << "\n";
GBStream << "present number of monomials:" << s_NumberMonomialNow << "\n";
#endif
};

void Monomial::operator = (const Monomial & x) {
  if(this!=&x) { 
    d_numberOfFactors= x.d_numberOfFactors;
    d_factors = x.d_factors;
  }
}; 

void  Monomial::operator *= (const Monomial & x) {
  list<Variable> & L = d_factors.access();
  typedef list<Variable>::const_iterator LI;
  LI w(x.d_factors().begin()), e(x.d_factors().end());
  while(w!=e) {
    L.push_back(*w);
    ++d_numberOfFactors;
    ++w;
  };
};

void Monomial::variablesIn(VariableSet & result) const {
  typedef list<Variable>::const_iterator LI;
  LI w(d_factors().begin()), e(d_factors().end());
  while(w!=e) {
    result.insert(*w);
    ++w;
  };
};

bool Monomial::operator==(const Monomial & x) const {
  typedef list<Variable>::const_iterator LI;
  LI w1(d_factors().begin()), e1(d_factors().end());
  LI w2(x.d_factors().begin()), e2(x.d_factors().end());
  bool result = true;
  while(result && w1!=e1 &&w2!=e2) {
    result = (*w1)==(*w2);
    ++w1;++w2;
  };
  if(result) {
    result = w1==e1 && w2==e2;
  };
  return result;
}

MyOstream & operator <<(MyOstream & os,const Monomial & aMonomial) {
  OuMonomial::NicePrint(os,aMonomial);
  return os;
};

Monomial::~Monomial() {
#ifdef DEBUG_MONOMIAL
 --s_NumberMonomialNow;
GBStream << "total number of monomials:" << s_NumberMonomialTotal << "\n";
GBStream << "present number of monomials:" << s_NumberMonomialNow << "\n";
#endif
};

void Monomial::setToOne() {
  d_factors = s_one;
  d_numberOfFactors = 0;
};

#ifndef INCLUDED_IDVALUE_H
#include "idValue.hpp"
#endif

#include "Edit6ThisFile.hpp"

void Monomial::error() const {
  GBStream << "Error obtaining monomial-additional-types.\n";
  GBStream.flush();
  DBG();
};

void Monomial::setPart(Monomial & m,int start,int end) const {
  m.setToOne();
  m.reserve(end-start);
  const Monomial & M = *this;
  MonomialIterator w = M.begin();
  for(int i=1;i<start;++i,++w) {}; 
  for(int j=start;j<end;++j,++w) { m *= (*w);};
};

const list<Variable> Monomial::s_one;
