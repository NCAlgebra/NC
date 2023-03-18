// (c) Mark Stankus 1999
// MidMonomial.c

#include "MidMonomial.hpp"
#include "RecordHere.hpp"
#include "SetSlot.hpp"
#include "load_flags.hpp"
#include "MyOstream.hpp"
#ifndef NO_DATA
class AuxilaryData;
#ifdef PDLOAD
#ifndef INCLUDED_AUXILARYDATA_H
#include "AuxilaryData.hpp"
#endif
#endif
#endif
#ifndef INCLUDED_OUMONOMIAL_H
#include "OuMonomial.hpp"
#endif

int s_NumberMonomialTotal = 0;
int s_NumberMonomialNow = 0;

Monomial::Monomial() { 
#ifdef DEBUG_MONOMIAL
 ++s_NumberMonomialTotal;
 ++s_NumberMonomialNow;
GBStream << "total number of monomials:" << s_NumberMonomialTotal << "\n";
GBStream << "present number of monomials:" << s_NumberMonomialNow << "\n";
#endif
#ifndef NO_DATA
  d_monomialData = 0;
#endif
  _numberOfFactors = 0;
//   setToOne();
};


Monomial::Monomial(const Monomial & aMonomial)  {
#ifdef DEBUG_MONOMIAL
 ++s_NumberMonomialTotal;
 ++s_NumberMonomialNow;
GBStream << "total number of monomials:" << s_NumberMonomialTotal << "\n";
GBStream << "present number of monomials:" << s_NumberMonomialNow << "\n";
#endif
  const int len = aMonomial.numberOfFactors();
  ListManager<Variable>::s_copy(_factors,aMonomial._factors);
  _numberOfFactors = len;
#ifndef NO_DATA
  d_monomialData = 0;
#endif
};

void Monomial::operator = (const Monomial & RightSide) {
  if(this!=&RightSide) { 
    const int len = RightSide.numberOfFactors();
    ListManager<Variable>::s_copy(_factors,RightSide._factors);
    _numberOfFactors = len;
#ifdef PDLOAD
#ifndef NO_DATA
      if(d_monomialData) {
        RECORDHERE(delete d_monomialData;)
        d_monomialData = 0;
      }
#endif
#else
      DBG();
#endif
#ifndef NO_DATA
    d_monomialData = 0;
#endif
  }
}; 

void  Monomial::operator *= (const Monomial & anotherMonomial) {
  const int len = anotherMonomial.numberOfFactors();
  MonomialIterator w = anotherMonomial.begin();
  for(int i=1;i<=len;++i,++w) {
    addFactor(*w);
  }
};

void Monomial::variablesIn(VariableSet & result) const {
  const int len = numberOfFactors(); 
  MonomialIterator j = begin();
  for(int i=1;i<=len&&!result.full();++i,++j) {
    result.insert(*j);
  }
};

int Monomial::compareMonomialsAux(const Monomial & Right) const {
  int Result = 0;
  const int NumChildren = _numberOfFactors;
  
  if(NumChildren>0) {
    MonomialIterator j = begin();
    MonomialIterator k = Right.begin();

    // Systematically compare children
    for (int i=1;i<=NumChildren && Result==0 ;++i,++j,++k) {
      Result = (*j).stringNumber()-(*k).stringNumber();
    }
  }
  // Otherwise, they are equal
  return Result;
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
#ifdef PDLOAD
#ifndef NO_DATA
 if(d_monomialData) {
   RECORDHERE(delete d_monomialData;)
   d_monomialData = 0;
  }
#endif
#else
  DBG();
#endif
  ListManager<Variable>::s_release(_factors);
};

void Monomial::setToOne() {
  if(_numberOfFactors>0) {
    _factors.clear();
    _numberOfFactors = 0;
  }
#ifdef PDLOAD
#ifndef NO_DATA
  if(d_monomialData) d_monomialData->vClearData(1);
#endif
#else
  DBG();
#endif
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

#ifndef NO_DATA
void Monomial::auxilaryData(AuxilaryData * p) const {
#ifdef PDLOAD
if(p==d_monomialData) DBG();
  RECORDHERE(delete d_monomialData;)
  d_monomialData = p;
#else
  DBG();
#endif
};
#endif

void Monomial::setPart(Monomial & m,int start,int end) const {
  m.setToOne();
  m.reserve(end-start);
  const Monomial & M = *this;
  MonomialIterator w = M.begin();
  for(int i=1;i<start;++i,++w) {}; 
  for(int j=start;j<end;++j,++w) { m *= (*w);};
};
