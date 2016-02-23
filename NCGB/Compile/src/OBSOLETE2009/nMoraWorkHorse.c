// MoraWorkHorse.c

#include "MoraWorkHorse.hpp"
#include "load_flags.hpp"
#pragma warning(disable:4687)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
bool inCleanUpBasis = false;
#include "SPIID.hpp"
#include "GroebnerRule.hpp"
#include "PrintGBList.hpp"
#include "OfstreamProxy.hpp"
#ifdef PDLOAD
#ifndef INCLUDED_USEROPTIONS_H
#include "UserOptions.hpp"
#endif
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#ifndef INCLUDED_UNIFIERBIN_H
#include "UnifierBin.hpp"
#endif
#ifndef INCLUDED_FACTCONTROL_H
#include "FactControl.hpp"
#endif
#ifndef INCLUDED_ALLTIMINGS_H
#include "AllTimings.hpp"
#endif
#pragma warning(disable:4786)
#include "MyOstream.hpp"
#ifndef INCLUDED_FSTREAM_H
#define INCLUDED_FSTREAM_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#endif
#ifndef INCLUDED_BACKSPACER_H
#include "backspacer.hpp"
#endif

bool s_tipReduction = true;

MoraWorkHorse::MoraWorkHorse(FactControl & factBase,UnifierBin & aBin) :
   _factBase(factBase) , _currentRules(factBase), _bin(aBin) { };

void MoraWorkHorse::doAtStartOfStep() {
  _currentRules.clear();
  const int numFacts = _factBase.numberOfPermanentFacts();
  if(numFacts>0) {
    FactControl::InternalPermanentType::const_iterator w = 
        _factBase.permanentBegin();
    int num;
    for(int i=1;i<=numFacts;++i,++w) {
      num = *w;
      _currentRules.addFact(SPIID(num));
      _bin.addNewNumber(num);
    }
  }
};

void MoraWorkHorse::CleanUpBasis(int iterationNumber) {
   if(AllTimings::timingOn) {
     inCleanUpBasis = true;
     AllTimings::cleanUpBasisTiming->restart();
   }
   if(!UserOptions::s_supressAllCOutput) {
     GBStream << "\n\n";
   }
   bool unchanged = false;
   list<int> G1;
   list<int> G;
   int index;
   const int numFacts = _factBase.numberOfPermanentFacts();
   if(numFacts>0) {
     FactControl::InternalPermanentType::const_iterator iter = 
           _factBase.permanentBegin();
     for(int ww=1;ww<=numFacts;++ww,++iter) {
       index = *iter;
       G.push_back(index);
     }
   }
   list<int> Gprime(G);
   G.clear();
   list<int>::const_iterator w = Gprime.begin(), e = Gprime.end();
   set<int> S;
   int nnn;
   while(w!=e) {
     nnn = *w;
     if(S.find(nnn)==S.end()) {
       G.push_back(nnn);
       S.insert(nnn);
     };
   };
   Polynomial f;
   Polynomial f1;
   PDReduction reducer(_factBase);
   reducer.tipReduction(s_tipReduction);
   int num, numb;
   GroebnerRule pref;
   while (!unchanged) { 
#if 0
GBStream << "G:" << G << "\n";
const int bugsz = _factBase.numberOfFacts();
for(int rrr=1;rrr<=bugsz;++rrr)
{
  GBStream << rrr << "> ";
//  _factBase.fact(rrr).NicePrint(GBStream);
  GBStream << "\n" << _factBase.history(rrr) ;
  GBStream << "\n";
}
#endif
     if(!UserOptions::s_supressAllCOutput) {
       GBStream  << 
         "Number of polynomials to process in CleanUpBasis: ";
     }
     reducer.clear();
     list<int>::const_iterator w = G.begin();
     const int len = G.size();
     for(int i=1;i<=len;++i,++w) {
       reducer.addFact(SPIID(*w));
     }     
     unchanged = true;
     G1.clear();
     backspacer back(GBStream,G.size(),-1);
     while(G.size()>0) {
       if(!UserOptions::s_supressAllCOutput) {
         back.show();
#if 0
         GBStream << G.size();
         if(G.size()==1) {
           GBStream << '\n';
         } else {
           GBStream << ',';
         }
#endif
       }
       num =  (*(G.begin()));
       _factBase.fact(num).toPolynomial(f);
       G.pop_front();
       reducer.remove(SPIID(num));
// mxs chg   f1 = reducer.reduce(f);
#if 0
// After April 2, 1996
       reducer.reduce(_factBase.fact(num),f1);
#endif
#if 1
// pre April 2, 1996
       reducer.reduce(f,f1);
#endif
       if(f1==f) {
#if 1
         const set<SPIID> & SS = 
             _currentRules.allPossibleReductionNumbers().SET();
         int len = SS.size();
         set<SPIID>::const_iterator ww = SS.begin();
         for(int k=1;k<=len;++k,++ww) {
           _factBase.markDone(num,(*ww).d_data);
         }
#endif
         reducer.addFact(SPIID(num));
         G1.push_back(num);
       } else {
         unchanged = false;
         _factBase.unsetFactPermanent(num);
         _bin.removeAllNumber(num);
         if(!f1.zero()) {
           pref.convertAssign(f1);
           numb = _factBase.addFactAndHistory(pref,
                 GBHistory(-num,-num,reducer.ReductionsUsed()),iterationNumber);
           _factBase.setFactPermanent(numb);
            _bin.addNewNumber(numb);
           G1.push_back(numb);
           reducer.addFact(SPIID(numb));
         }
       }
     }
     if(!UserOptions::s_supressAllCOutput) { 
       back.show();
#if 0
       if(!unchanged) { 
         GBStream << ',';
       }   
       else
#endif
       { 
         GBStream << '\n';
       };
     }
     G = G1;
  }
  GBStream << "\n\n";
#if 0
  if(!UserOptions::s_supressAllCOutput) {
    GBStream << "\nEnding CleanUpBasis.\n";
  }
#endif
#if 0
const int Gsize = G.size();
for(int www=1;www<=Gsize;++www) {
  GBStream << www << ") ";
  _factBase.fact(www).NicePrint(GBStream);
  GBStream  << '\n';
};
#endif
  if(AllTimings::timingOn)
  {
    inCleanUpBasis = false;
    Debug1::s_TimingFile() << "cleanupbasis:" 
               << AllTimings::cleanUpBasisTiming->check() << '\n';
    AllTimings::cleanUpBasisTiming->pause();
  }
};

bool MoraWorkHorse::processFacts( const GBList<Match> & aList,
     const GroebnerRule & aRule,int a, const GroebnerRule & bRule,int b,
     int iterationNumber) {
  bool anythingnew = false;
   const int listSize = aList.size();
   GBList<Match>::const_iterator w = 
            aList.begin();
   for(int i=1;i<=listSize;++i,++w) {
     anythingnew = addMatches(*w,aRule,a,bRule,b,iterationNumber)
                   || anythingnew;
   }
  return anythingnew;
};

inline void MoraWorkHorse::spolynomial( const Match & aMatch,
     const GroebnerRule & rule1,int,
     const GroebnerRule & rule2,int,GBList<Polynomial> & result) const {
   Polynomial firstpart;
   firstpart.doubleProduct(aMatch.left1(),rule1.RHS(),aMatch.right1());
   Polynomial secondpart;
   secondpart.doubleProduct(aMatch.left2(),rule2.RHS(),aMatch.right2());
   Polynomial spol = firstpart - secondpart;
   result.push_back(spol);
};

bool MoraWorkHorse::addMatches( const Match & aMatch,
    const GroebnerRule & rule1,int a, const GroebnerRule & rule2,int b,
                 int iterationNumber) {
  bool anythingnew = false;
  GBList<Given> temp;
#if 0
GBStream << "About to compute the spolynomial of the rules "
         << rule1 << " and " << rule2 << " with numbers "
         << a << " and " << b << " via the match " 
         << aMatch << ".\n";
#endif
  if(AllTimings::timingOn) {
    AllTimings::spolynomialsTiming->restart();
  }
  spolynomial(aMatch,rule1,a,rule2,b,temp);
  if(AllTimings::timingOn) {
    Debug1::s_TimingFile() << "spolynomial:" 
               << AllTimings::spolynomialsTiming->check() << '\n';
    AllTimings::spolynomialsTiming->pause();
  }
#if 0
GBStream << " The result of the polynomial computation is "
         << temp << "\n";
#endif
  Polynomial reducedSpol;
  if(AllTimings::timingOn) {
    AllTimings::reductionTiming->restart();
  }
  _currentRules.reduce(*(temp.begin()),reducedSpol);
  if(AllTimings::timingOn) {
    Debug1::s_TimingFile() << "reduction:" 
               << AllTimings::reductionTiming->check() << '\n';
    AllTimings::reductionTiming->pause();
  }
  if(!reducedSpol.zero()) {
      anythingnew = true;
     GroebnerRule theRule;
     theRule.convertAssign(reducedSpol);
     int num = _factBase.addFactAndHistory(theRule,
               GBHistory(a,b,_currentRules.ReductionsUsed()),iterationNumber);
// MXS**** 9/2/97
#if 0
     int len = _currentRules.allPossibleReductionNumbers().size();
     GBList<int>::const_iterator ww = 
          _currentRules.allPossibleReductionNumbers().begin();
     for(int k=1;k<=len;++k,++ww) {
       _factBase.markDone(num,*ww);
     }
#endif
     _factBase.setFactPermanent(num);
     _bin.addNewNumber(num); 
     _currentRules.addFact(SPIID(num));
  }
  return anythingnew;
};
#endif
