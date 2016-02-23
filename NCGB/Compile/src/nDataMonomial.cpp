// nDataMonomial.c

#include "nDataMonomial.hpp"
#include "GBStream.hpp"
#include "RecordHere.hpp"
#include "load_flags.hpp"
#ifdef PDLOAD
#include "MLex.hpp"
#ifndef INCLUDED_NCGBADVANCE_H
#include "ncgbadvance.hpp"
#endif
#include "PrintVector.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"
#include "Monomial.hpp"

nDataMonomial::nDataMonomial(const MLex * const mlex,const Monomial & m) : 
  _length(0), _counts(), _mlex(mlex) {
#ifdef DEBUGDATAMONOMIAL
  ++s_numberOfDataMonomials;
#endif
  clearData();
  _counts.reserve(_mlex->multiplicity());
  updateMonomial(m); 
};

nDataMonomial::~nDataMonomial(){
#ifdef DEBUGDATAMONOMIAL
  --s_numberOfDataMonomials;
  GBStream << "Destroying an nDataMonomial with address " << this 
           << ". Now there are " << s_numberOfDataMonomials 
           << " instances of nDataMonomial.\n";
#endif
};

void nDataMonomial::tellMonomial(const Monomial & m) const {
  GBStream << "The monomial is " << m << " and the data is\n"
           << "length:" << _length << " and counts:";
  PrintVector("",_counts);
};

void nDataMonomial::updateMonomial(const Monomial & m) {
#ifdef DEBUGDATAMONOMIAL
  GBStream << "Updating an nDataMonomial with address " << this 
           << " via monomial " << m << '\n';
#endif
  if(!_mlex) DBG();
  const int sz = m.numberOfFactors();
#if 0
  if(sz<_length) DBG();
  RECORDHERE(nDataMonomial * ptr = new nDataMonomial();)
  ptr->setOrder(_mlex);
  int mul = _mlex->multiplicity();
  int tem;
  MonomialIterator ww = m.begin();
  for(int k=1;k<=_length;++k,++ww)
  {
    tem = _mlex->level(* ww);
    ++(ptr->_counts[mul - tem]);
  }
  if(ptr->_counts!=_counts) DBG();
  RECORDHERE(delete ptr;)
#endif
  if(sz>_length) {
    int mult = _mlex->multiplicity();
    int temp;
    MonomialIterator w = m.begin();
#ifdef MID_MONOMIAL
    for(int jj=1;jj<=_length;++jj,++w) {};
#else
    ncgbadvance(w,_length);
#endif
    for(int i=_length+1;i<=sz;++i,++w) {
       temp = _mlex->level(* w); 
       ++_counts[mult - temp];
    }
    _length = sz;
  }
};

void nDataMonomial::clearData() {
#ifdef DEBUGDATAMONOMIAL
  GBStream << "ClearingData for an nDataMonomial with address " 
           << this << '\n'; 
#endif
  _length = 0;
  _counts.erase(_counts.begin(),_counts.end());
  if(_mlex) {
    int mult = _mlex->multiplicity();
    _counts.reserve(mult);
    while(mult) { _counts.push_back(0); --mult;};
  };
};

void nDataMonomial::assign(const AuxilaryData & d) {
#ifdef DEBUGDATAMONOMIAL
  GBStream << "ClearingData for an nDataMonomial with address " 
           << this << '\n'; 
#endif
  operator=(* (nDataMonomial *) (void *) (&d));
};

bool nDataMonomial::equal(const AuxilaryData &d) const {
  return operator==(*(nDataMonomial *)(void *)(&d));
};

void nDataMonomial::vClearData(int) { clearData();};

#ifdef DEBUGDATAMONOMIAL
int nDataMonomial::s_numberOfDataMonomials = 0;
#endif

#endif
