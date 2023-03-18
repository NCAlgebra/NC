// MoraWorkHorse.c

#include "MoraWorkHorse.hpp"
#include "load_flags.hpp"
#include "GBStream.hpp"
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
#include "Debug3.hpp"
#ifndef INCLUDED_UNIFIERBIN_H
#include "UnifierBin.hpp"
#endif
#ifndef INCLUDED_FACTCONTROL_H
#include "FactControl.hpp"
#endif
#ifndef INCLUDED_ALLTIMINGS_H
#include "AllTimings.hpp"
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
#ifndef INCLUDED_BACKSPACER_H
#include "backspacer.hpp"
#endif

extern int s_number_of_spolynomials;

extern bool s_tipReduction;

MoraWorkHorse::MoraWorkHorse(FactControl &fc, GiveNumber& give,
    UnifierBin & aBin) :
   d_fc(fc), d_give(give) , _currentRules(d_give), _bin(aBin) { };

void MoraWorkHorse::doAtStartOfStep() {
  _currentRules.clear();
  const vector<int> & nums = d_give.perm_numbers();
  vector<int>::const_iterator w = nums.begin(), e = nums.end();
  int num;
  while(w!=e) {
    num = *w;
    _currentRules.addFact(SPIID(num));
    _bin.addNewNumber(num);
    ++w;
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
   GBList<int> G1,G;
   const vector<int> & nums = d_give.perm_numbers();
   vector<int>::const_iterator w = nums.begin(), e = nums.end();
   while(w!=e) { 
     G.push_back(*w);
     ++w;
   };
   G.removeDuplicates();
   Polynomial f;
   Polynomial f1;
   PDReduction reducer(d_give);
   reducer.tipReduction(s_tipReduction);
   int num, numb;
   GroebnerRule pref;
   while (!unchanged) { 
     if(!UserOptions::s_supressAllCOutput) {
       GBStream  << 
         "Number of polynomials to process in CleanUpBasis: ";
     }
     reducer.clear();
     GBList<int>::const_iterator w = ((const GBList<int> &)G).begin();
     const int len = G.size();
     for(int i=1;i<=len;++i,++w) {
       reducer.addFact(SPIID(*w));
     }     
UserOptions::s_supressAllCOutput = true;
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
       d_give.fact(num).toPolynomial(f);
       G.pop_front();
       reducer.remove(SPIID(num));
       reducer.reduce(f,f1);
       if(f1==f) {
         const set<SPIID,less<SPIID> > & SS = 
             _currentRules.allPossibleReductionNumbers().SET();
         int len = SS.size();
         set<SPIID,less<SPIID> >::const_iterator ww = SS.begin();
         for(int k=1;k<=len;++k,++ww) {
           d_fc.markDone(num,(*ww).d_data);
         }
         reducer.addFact(SPIID(num));
         G1.push_back(num);
       } else {
         unchanged = false;
         d_give.setNotPerm(num);
         _bin.removeAllNumber(num);
         if(!f1.zero()) {
           pref.convertAssign(f1);
           numb = d_fc.addFactAndHistory(pref,
                 GBHistory(-num,-num,reducer.ReductionsUsed()),iterationNumber);
           d_give.setPerm(numb);
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
  d_give.fact(www).NicePrint(GBStream);
  GBStream  << '\n';
};
#endif
  if(AllTimings::timingOn)
  {
    inCleanUpBasis = false;
    Debug3::s_TimingFile() << "cleanupbasis:" 
               << AllTimings::cleanUpBasisTiming->check() << '\n';
    AllTimings::cleanUpBasisTiming->pause();
  }
};

#ifdef USE_MANAGER_ONE_CHOICE
bool MoraWorkHorse::processFacts( const GBList<Match> & aList,
     const GroebnerRule & aRule,int a, const GroebnerRule & bRule,int b,
     int iterationNumber) {
  bool anythingnew = false;
  const int listSize = aList.size();
  GBList<Match>::const_iterator w = aList.begin();
  for(int i=1;i<=listSize;++i,++w) {
    anythingnew = addMatches(*w,aRule,a,bRule,b,iterationNumber)
                  || anythingnew;
  }
  return anythingnew;
};
#endif

inline void MoraWorkHorse::spolynomial( const Match & aMatch,
     const GroebnerRule & rule1,int,
     const GroebnerRule & rule2,int,GBList<Polynomial> & result) const {
   Polynomial firstpart;
   firstpart.doubleProduct(aMatch.const_left1(),
                           rule1.RHS(),
                           aMatch.const_right1());
   Polynomial secondpart;
   secondpart.doubleProduct(aMatch.const_left2(),
                            rule2.RHS(),
                            aMatch.const_right2());
   Polynomial spol(firstpart);
   spol -= secondpart;
   result.push_back(spol);
};

bool MoraWorkHorse::addMatches( const Match & aMatch,
    const GroebnerRule & rule1,int a, const GroebnerRule & rule2,int b,
                 int iterationNumber) {
++s_number_of_spolynomials;
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
    Debug3::s_TimingFile() << "spolynomial:" 
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
  /* This is ok since there is exactly one polynomial per match! */
  /* The code is slight inefficient. */
  _currentRules.reduce(*(temp.begin()),reducedSpol);
  if(AllTimings::timingOn) {
    Debug3::s_TimingFile() << "reduction:" 
               << AllTimings::reductionTiming->check() << '\n';
    AllTimings::reductionTiming->pause();
  }
  if(!reducedSpol.zero()) {
      anythingnew = true;
     GroebnerRule theRule;
     theRule.convertAssign(reducedSpol);
     int num = d_fc.addFactAndHistory(theRule,
               GBHistory(a,b,_currentRules.ReductionsUsed()),iterationNumber);
// MXS**** 9/2/97
#if 0
     int len = _currentRules.allPossibleReductionNumbers().size();
     GBList<int>::const_iterator ww = 
          _currentRules.allPossibleReductionNumbers().begin();
     for(int k=1;k<=len;++k,++ww) {
       fcgive.fc().markDone(num,*ww);
     }
#endif
     d_give.setPerm(num);
     _bin.addNewNumber(num); 
     _currentRules.addFact(SPIID(num));
  }
  return anythingnew;
};
#endif
