// MngrSuper.c

#include "Mngr1Super.hpp"
#include "RecordHere.hpp"
#include "SPIID.hpp"
#include "GBGlobals.hpp"
#include "EditChoices.hpp"
#ifdef WANT_MNGRSUPER
#include "load_flags.hpp"
#ifdef PDLOAD
#include "OfstreamProxy.hpp"
#include "MatcherMonomial.hpp"
#ifndef INCLUDED_MORAWORKHORSE_H
#include "MoraWorkHorse.hpp"
#endif
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#ifndef INCLUDED_ALLTIMINGS_H
#include "AllTimings.hpp"
#endif
#ifndef INCLUDED_FIRSTDIFFER_H
#include "firstDiffer.hpp"
#endif
#ifndef INCLUDED_GBIO_H
#include "GBIO.hpp"
#endif
#ifndef INCLUDED_BACKSPACER_H
#include "backspacer.hpp"
#endif
#include "PrintGBList.hpp"
#ifndef INCLUDED_USEROPTIONS_H
#include "UserOptions.hpp"
#endif
#pragma warning(disable:4786)
#ifndef INCLUDED_FSTREAM_H
#define INCLUDED_FSTREAM_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#endif
#include "MyOstream.hpp"

MngrSuper::MngrSuper() : 
   d_inCleanUpBasis(false), d_tipReduction(false) {
   _fcn = GBGlobals::s_factControls().push_back(FactControl());
   _srn = GBGlobals::s_polynomials().push_back(GBList<Polynomial>());
   FactControl & FactB = TheFactBase();
   RECORDHERE(_bin = new UnifierBin(FactB);)
   RECORDHERE(_workHorse  = new MoraWorkHorse(FactB,*_bin);)
};

MngrSuper::~MngrSuper() {
// Tell the code that it can have these two "slots" back.
  RECORDHERE(delete _workHorse;)
  RECORDHERE(delete _bin;)
  GBGlobals::s_factControls().makeHole(_fcn);
  GBGlobals::s_polynomials().makeHole(_srn);
};

void MngrSuper::reorder(bool n) const {
  _bin->reorder(n);
};

void MngrSuper::OneStep(int iterationNumber) {
  _workHorse->doAtStartOfStep();
  _bin->fillForNextIteration();
  OneStepNoPrep(iterationNumber);
};

void MngrSuper::OneStepNoPrep(int iterationNumber) {
  const FactControl & GetFactB = GetFactBase();
  bool doMatch;
  GBList<Match> result;
  bool foundSomething = false;
  int i;
  const int binSize = _bin->size();
  backspacer back(GBStream,binSize,-UserOptions::s_SelectionOutputMethod);
  if(!UserOptions::s_supressAllCOutput) {
    GBStream << "\n\nThere are n*n pairs to match where n is ";
    if(UserOptions::s_SelectionOutputMethod) {
      GBStream << binSize << ' ';
    } else {
      GBStream << "The following numbers indicate how many pairs still "
               << "need to be computed for this iteration.\n";
      GBStream << binSize;
    }
  }
  while (!_bin->iterationEmpty()) {
    if(!UserOptions::s_supressAllCOutput) {
      if(UserOptions::s_SelectionOutputMethod) {
        GBStream << _bin->size() << ' '; 
      } else {
        back.show();
      }
    }
    for (i = 1; (i <= UserOptions::s_SelectionOutputMethod) && 
                (!_bin->iterationEmpty()); ++i) {
      pair<int,int> indices(_bin->nextPair());
      doMatch = !avoidTheSPolynomial(indices.first,indices.second);
      if(doMatch) {
        const GroebnerRule & firstRule = GetFactB.fact(indices.first);
        const GroebnerRule & secondRule = GetFactB.fact(indices.second);
        result.clear();
        MatcherMonomial matcher;
        if(UserOptions::s_UseSubMatch) {
          matcher.subMatch(firstRule.LHS(),indices.first,secondRule.LHS(),
                           indices.second,result);
        };
        matcher.overlapMatch(firstRule.LHS(),
                         indices.first,secondRule.LHS(),
                         indices.second,result);    
        foundSomething = 
            _workHorse->processFacts(result,firstRule,
               indices.first,secondRule,indices.second,
               iterationNumber)
                || foundSomething;
      }
    }
//    if(!UserOptions::s_supressAllCOutput) GBStream << ',' << _bin->size();
  }
  if(!UserOptions::s_SelectionOutputMethod) {
    back.clear();
  }
  _finished = ! foundSomething;
}

void MngrSuper::ManySteps(bool continueQ) {
   if(!continueQ) _step = 1;
   cleanIfNecessary(_step);
   while((!_bin->empty())&&_step<=_numberOfIterations) {
      if(! UserOptions::s_supressAllCOutput) {
        GBStream << "ManySteps :-) About to execute the " 
        << _step << "th step.\n";
      }
      OneStep(_step);
      cleanIfNecessary(_step);
      ++_step;
   }
   if(!UserOptions::s_supressOutput) {
     if(_finished) {
       if(_cutOffs) {
          GBStream << "Done with the GB calculation, but degree cut offs "
                   << "might have been  used.\n\n\n";
       } else if(Deselected.size()>0) {
         GBStream << "Done with the GB calculation, but deselects might "
                  << "have been used.\n\n\n";
       } else {
         GBStream << "Finished calculating the basis.\n\n\n";
       }
     } else {
       GBStream << "Ran into the maximal number of iterations.\n\n\n";
     }
   };
}

void MngrSuper::continueRun() {
  ManySteps(false);
};

void MngrSuper::run(Polynomial &) {
  DBG();
};

void MngrSuper::run() {
   _finished = false;
   const FactControl & GetFactB = GetFactBase();
   const int len = GetFactB.numberOfPermanentFacts();
   if(len>0) {
     FactControl::InternalPermanentType::const_iterator iter = 
          GetFactB.permanentBegin();
     for(int i=1;i<=len;++i,++iter) {
       _bin->addNewNumber(*iter);
     }
   }
   ManySteps(false);
};

bool MngrSuper::avoidTheSPolynomial(int first,int second) const {
  const FactControl & GetFactB = GetFactBase();
  bool doMatch = true;
  if(IsMember(Deselected,first) &&
     IsMember(Deselected,second)) {
    doMatch = false;
  }
  if(doMatch && _cutOffs) {
    const GroebnerRule & one = GetFactB.fact(first); 
    const GroebnerRule & two = GetFactB.fact(second); 
    int deg1L = one.LHS().numberOfFactors();
    int deg2L = two.LHS().numberOfFactors();
    int sum = deg1L + deg2L; 
    int min = (deg1L < deg2L) ? deg1L : deg2L;
    if(min>=_minNumber) {
      doMatch = false;
    } else if(sum>_sumNumber) {
      doMatch = false; 
    }
  }
  return !doMatch;
};

bool MngrSuper::avoidTheMatchQ(int,int, const Match & ) const {
  return false;
};

// Tell the code the the starting relations are from 
// polynomial container with number srn.
void MngrSuper::RegisterStartingRelations(int srn) {
   FactControl & FactB = TheFactBase();
   GBGlobals::s_polynomials().reference(_srn).empty();
   GBGlobals::s_polynomials().makeHole(_srn);
   _srn = srn;
   GroebnerRule Pref;
   int num;
   const GBList<Polynomial> & aList = 
       GBGlobals::s_polynomials().const_reference(_srn);

   GBStream << "\nThe starting relations are \n";
   const int listSize = aList.size();
   GBList<Polynomial>::const_iterator w = aList.begin();
   for(int i=1;i<=listSize;++i,++w) { 
     const Polynomial & poly = *w;
     if(!poly.zero()) {
        Pref.convertAssign(poly);
        GBStream << Pref << '\n';
        num = FactB.addFactAndHistory(Pref,GBHistory(0,0),0);
        FactB.setFactPermanent(num);
       _bin->addNewNumber(num);
     }
   }
   GBStream << "\n\n\n";
};

void MngrSuper::ForceCleanUpBasis(int iterationNumber) {
   FactControl & FactB = TheFactBase();
   const FactControl & GetFactB = GetFactBase();
   if(AllTimings::timingOn) {
     d_inCleanUpBasis = true;
     AllTimings::cleanUpBasisTiming->restart();
   }
   if(!UserOptions::s_supressAllCOutput) {
     GBStream << "\n\n";
   }
   bool unchanged = false;
   GBList<int> G1;
   GBList<int> G;
   int index;
   const int numFacts = GetFactB.numberOfPermanentFacts();
   if(numFacts>0) {
     FactControl::InternalPermanentType::const_iterator iter = 
           GetFactB.permanentBegin();
     for(int ww=1;ww<=numFacts;++ww,++iter) {
       index = *iter;
       G.push_back(index);
     }
   }
   G.removeDuplicates();
   Polynomial f;
   Polynomial f1;
   Reduction reducer(FactB);
   reducer.tipReduction(d_tipReduction);
   int num, numb;
   GroebnerRule pref;
   while (!unchanged) { 
     if(!UserOptions::s_supressAllCOutput) {
       GBStream  << 
         "Number of polynomials to process in CleanUpBasis: ";
     }
     reducer.clearNumbers();
     GBList<int>::const_iterator w = ((const GBList<int> &)G).begin();
     const int len = G.size();
     for(int i=1;i<=len;++i,++w) {
       reducer.addFactNumber(*w);
     }     
     unchanged = true;
     G1.clear();
     backspacer back(GBStream,G.size(),-1);
     while(G.size()>0) {
       if(!UserOptions::s_supressAllCOutput) {
         back.show();
       }
       num =  (*(G.begin()));
       GetFactB.fact(num).toPolynomial(f);
       G.pop_front();
       reducer.clearNumber(num);
       reducer.reduce(f,f1);
       if(f1==f) {
         int len = _currentRules->allPossibleReductionNumbers().size();
         GBList<int>::const_iterator ww = 
              _currentRules->allPossibleReductionNumbers().begin();
         for(int k=1;k<=len;++k,++ww) {
           FactB.markDone(num,*ww);
         }
         reducer.addFactNumber(num);
         G1.push_back(num);
       } else {
         unchanged = false;
         FactB.unsetFactPermanent(num);
         _bin->removeAllNumber(num);
         if(!f1.zero()) {
           pref.convertAssign(f1);
           numb = FactB.addFactAndHistory(pref, 
                            GBHistory(-num,-num,reducer.ReductionsUsed()),
                            iterationNumber); 
            FactB.setFactPermanent(numb);
            _bin->addNewNumber(numb);
           G1.push_back(numb);
           reducer.addFactNumber(numb);
         }
       }
     }
     if(!UserOptions::s_supressAllCOutput) { 
       back.show();
       GBStream << '\n';
     }
     G = G1;
  }
  GBStream << "\n\n";
  if(AllTimings::timingOn) {
    d_inCleanUpBasis = false;
    Debug1::s_TimingFile() << "cleanupbasis:" 
               << AllTimings::cleanUpBasisTiming->check() << '\n';
    AllTimings::cleanUpBasisTiming->pause();
  }
};

FactControl & MngrSuper::TheFactBase() {
  return GBGlobals::s_factControls().reference(_fcn);
};

const list<Polynomial> & MngrSuper::startingRelations() const {
  _startingRelationsHolder.erase(_startingRelationsHolder.begin(),
                                 _startingRelationsHolder.end());
  const GBList<Polynomial> &  aList =  GBGlobals::s_polynomials().const_reference(_srn);
  const int sz = aList.size();
  GBList<Polynomial>::const_iterator w = aList.begin();
  for(int i=1;i<=sz;++i,++w) {
    _startingRelationsHolder.push_back(*w);
  };
  return _startingRelationsHolder;
};

const FactControl & MngrSuper::GetFactBase() const {
  return GBGlobals::s_factControls().const_reference(_fcn);
};

list<Polynomial> MngrSuper::partialBasis() const
#ifdef UseGnuGCode
   return aList;
{
#else
{
  list<Polynomial> aList;
#endif
  const FactControl & getFactBase = GetFactBase();

  const int num = getFactBase.numberOfPermanentFacts();
  if(num>0) {
    int index;
    FactControl::InternalPermanentType::const_iterator iter = 
          getFactBase.permanentBegin();
    Polynomial p;
    for(int j=1;j<=num;++j,++iter)
    {
      index = *iter;
      getFactBase.fact(index).toPolynomial(p);
      aList.push_back(p);
    }
  }
#ifndef UseGnuGCode
  return aList;
#endif
};

Polynomial MngrSuper::partialBasis(int n) const {
  const FactControl & getFactBase = GetFactBase();
  if((0>=n) || n> getFactBase.numberOfPermanentFacts()) {
    GBStream << "Tried to access the " << n << "th element"
             << " of " << getFactBase.numberOfPermanentFacts();
    GBStream << '\n';
    DBG();
  }
  int index = getFactBase.indexOfnthPermanentFact(n);
  Polynomial p;
  getFactBase.fact(index).toPolynomial(p);
  return p;
};

void MngrSuper::partialBasis(int n,Polynomial & result) const {
  const FactControl & getFactBase = GetFactBase();
  if((0>=n) || n> getFactBase.numberOfPermanentFacts()) {
    GBStream << "Tried to access the " << n << "th element"
             << " of " << getFactBase.numberOfPermanentFacts();
    GBStream << '\n';
    DBG();
  }
  int index = getFactBase.indexOfnthPermanentFact(n);
  getFactBase.fact(index).toPolynomial(result);
};

const GroebnerRule & MngrSuper::rule(int n) const {
  return GetFactBase().fact(n);
};

int MngrSuper::lowvalue() const {
  return 1;
};
 
int MngrSuper::numberOfFacts() const {
  return GetFactBase().numberOfFacts();
};

pair<int *,int> MngrSuper::idsForPartialGBRules() const {
  const GBList<int> & L =  GetFactBase().indicesOfPermanentFacts();
  const int sz = L.size();
  RECORDHERE(int * result = new int[sz];)
  GBList<int>::const_iterator w = L.begin();
  for(int i=0;i<sz;++i,++w) {
    result[i] = *w;
  };
  return make_pair(result,sz);
};

int MngrSuper::iterationNumber(int n) const {
  return GetFactBase().extra(n);
};

#if 0
pair<SPIID *,int> MngrSuper::reductionsUsed(int n) const {
  const GBHistory & h = GetFactBase().history(n);
  const int sz = h.reductions().size();
  GBHistory::HistoryContainerType::const_iterator w =  h.reductions().begin();
  RECORDHERE(int * result = new int[sz];)
  for(int i=0;i<sz;++i,++w) {
    result[i] = *w;
  }
  return make_pair(SPIID(result),sz);
};
#endif

int MngrSuper::leftIDForSpolynomial(int n) const {
  return GetFactBase().history(n).first();
};

int MngrSuper::rightIDForSpolynomial(int n) const {
  return GetFactBase().history(n).second();
};

void MngrSuper::debug() const {
  GBStream << "_srn:                      " 
           << _srn << '\n';
  GBStream << "_fcn:                       " 
           << _fcn << '\n';
  GBStream << "_bin:                       " 
           << _bin << '\n';
  GBStream << "_workHorse:                 " 
           << _workHorse << '\n';
  GBStream << "d_inCleanUpBasis:           " 
           << d_inCleanUpBasis << '\n';
  GBStream << "d_tipReduction:             " 
           << d_tipReduction << '\n';
  GBStream << "_currentRules:              " 
           << _currentRules << '\n';
  GBStream << "_step:                      " 
           << _step << '\n';
  GBStream << "&_startingRelationsHolder:  " 
           << & _startingRelationsHolder<< '\n';
};
#endif

const FactBase & MngrSuper::factbase() const { 
  return GetFactBase();
};
#endif
