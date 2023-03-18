// PDReduction.c

#include "PDReduction.hpp"
#include "GeneralMora.hpp"
#include "load_flags.hpp"
#include "GBStream.hpp"
#include "SPIID.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#ifdef PDLOAD
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "Debug3.hpp"
#include "Utilities.hpp"
#include "GiveNumber.hpp"
#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
#ifndef INCLUDED_MATCHERMONOMIAL_H
#include "MatcherMonomial.hpp"
#endif
#ifndef INCLUDED_ALLTIMINGS_H
#include "AllTimings.hpp"
#endif
#include "OfstreamProxy.hpp" 
#ifndef INCLUDED_USEROPTIONS_H
#include "UserOptions.hpp"
#endif
#include "MyOstream.hpp"
#pragma warning(disable:4786)
#ifndef INCLUDED_FSTREAM_H
#define INCLUDED_FSTREAM_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream> 
#else
#include <fstream.h> 
#endif
#endif

//#define DEBUG_REDUCTION

extern int inCleanUpBasis;

PDReduction::~PDReduction() {}; 

void PDReduction::ClearReductionsUsed() {
  d_reductionsUsed.clear();
};

const SPIIDSet & PDReduction::ReductionsUsed() const {
  return d_reductionsUsed;
};

void PDReduction::addFact(const SPIID & x) {
  d_factnumbers.insert(x);
}; 

const SPIIDSet & PDReduction::allPossibleReductionNumbers() const {
  return d_factnumbers;
};

PDReduction::PDReduction(GiveNumber & give) : d_give(give), 
      d_factnumbers(), d_reductionsUsed() {
  tipReduction(false);
  clear();
};

void PDReduction::remove(const SPIID & x) {
  d_factnumbers.remove(x);
};

void PDReduction::clear() {
  d_factnumbers.clear();
};

void PDReduction::reduce(const GroebnerRule & theRule,Polynomial & result) {
  Term t(theRule.LHS());
  Polynomial p;
  p = t;
  Polynomial temp1;
  reduce(p,temp1);
  if(false) // if(d_tipReduction)
  {
    if(p==temp1) {
      // Nothing happened on the tip
      // Just pass it through
      result = p;
      p -= theRule.RHS();
    } else {
      // The tip was reduced
      temp1 -= theRule.RHS(); 
      reduce(temp1,result);
    }
  } else {
    Polynomial temp2;
    reduce(theRule.RHS(),temp2);
    result = temp1;
    result -= temp2; 
  }
};


void PDReduction::preFilledReduce(const Polynomial & thePoly,
       Polynomial & newPoly) {
  ++s_number_of_reductionstar;
  newPoly.setToZero();
  ClearReductionsUsed();
  Polynomial toReduce(thePoly);
  Polynomial change;
  long tTipNumber,aliasTipNumber;
  GBList<Term> almostAnswer;
  MatcherMonomial matcher;
#ifdef DEBUG_REDUCTION
int number_of_times_in_loop = 0;
#endif
  while(!toReduce.zero()) {
#ifdef DEBUG_REDUCTION
++number_of_times_in_loop;
if(number_of_times_in_loop>2000) {
  GBStream << "Warning: reduction routine may be in an infinite loop.\n";
  GBStream << toReduce << "\n";
};
if(number_of_times_in_loop>2050) errorc(__LINE__);
#endif
    bool changed = false;
    Term  t(* toReduce.begin());
    tTipNumber = Utilities::s_computeTipNumber(toReduce);
#if 0
    toReduce -= t;
#else
    toReduce.Removetip();
#endif
#ifdef DEBUG_REDUCTION
if(t.CoefficientPart().zero()) {
  GBStream << "Have a polynomial with a zero leading term!!!\n";
  errorc(__LINE__);
};
#endif
    const set<SPIID,less<SPIID> > & GL = d_factnumbers.SET();
    const int Size = GL.size();
    set<SPIID,less<SPIID> >::const_iterator iter(GL.begin());
    for(int i=1;i<=Size &&(!changed);++i) {
      // *iter is _factnumbers.element(itertwo)
      int index = (*iter).d_data;
      aliasTipNumber = 1;
      GroebnerRule aliasFact =  d_give.fact(index);
      Monomial aliasM = aliasFact.LHS();
      if(AllTimings::timingOn/*&&!inCleanUpBasis*/) {
        AllTimings::reductionMatchingTiming->restart();
      };
#if 0
      bool matchfound = 
          (tTipNumber % aliasTipNumber == 0 ) &&
          aliasM.numberOfFactors() <= t.MonomialPart().numberOfFactors() &&
          matcher.matchExists(aliasM, t.MonomialPart());
#else
      bool matchfound = matcher.matchExists(aliasM, t.MonomialPart());
#endif
       if(AllTimings::timingOn /*&& !inCleanUpBasis*/) {
         Debug3::s_TimingFile() << "reduction matching:"
            << AllTimings::reductionMatchingTiming->check() << '\n';
         AllTimings::reductionMatchingTiming->pause();
       }
      if(matchfound) {
        if(AllTimings::timingOn) {
          AllTimings::reductionPolyTiming1->restart();
        }
        ++s_number_of_reduction_didreduce;
        change.doubleProduct(
            t.CoefficientPart(),
            matcher.matchIs().const_left1(),
            aliasFact.RHS(),
            matcher.matchIs().const_right1()
         );
         if(AllTimings::timingOn) {
          AllTimings::reductionPolyTiming1->pause();
          AllTimings::reductionPolyTiming2->restart();
         }
         if(AllTimings::timingOn) {
          AllTimings::reductionPolyTiming2->pause();
          AllTimings::reductionPolyTiming3->restart();
         };
         toReduce += change;
         if(AllTimings::timingOn) {
           AllTimings::reductionPolyTiming3->pause();
         }
         changed = true;
         if(UserOptions::s_recordHistory)   {
	   d_reductionsUsed.insert(SPIID(index));
         };
         if(d_reductionsUsed.size()>5000) {
           GBStream << &d_give
                    << "\nThe reductions numbers are ";
           typedef set<SPIID,less<SPIID> >::const_iterator SI;
           SI w = d_reductionsUsed.SET().begin(),
              e = d_reductionsUsed.SET().end();
           while(w!=e) {
             GBStream << (*w).d_data << '\n';
             ++w;
           };
           errorc(__LINE__);
         }
      }
      if(!changed) ++iter;
    }       
    if(!changed) {
#if 0
      newPoly += t;
#else
      newPoly.addNewLastTerm(t);
#endif
    }
  }
  if(!newPoly.zero()) ++s_number_of_reduction_didnotreduce;
};

void PDReduction::reduce(const Polynomial & start,Polynomial & result) {
  preFilledReduce(start,result);
};

void PDReduction::reduce(Polynomial & start,ReductionHint&,const Tag &) {
  Polynomial result;
  preFilledReduce(start,result);
  start = result;
};

void PDReduction::vTipReduction() {};
#endif

void PDReduction::errorh(int n) { DBGH(n); };

void PDReduction::errorc(int n) { DBGC(n); };
