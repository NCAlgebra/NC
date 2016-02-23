// Mngr2Super.c

#define MARKS_FIX

#include "Mngr2Super.hpp"
#include "RecordHere.hpp"
#include "SPIID.hpp"
#include "PDGenerator.hpp"
#include "GBMatch.hpp"
#include "GBStream.hpp"
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
#include "FCGiveNumber.hpp"
#include "RA1.hpp"
#include "RA2.hpp"

MngrSuper::MngrSuper() : 
  d_inCleanUpBasis(false), d_tipReduction(false) {
  FactControl fc;
  GBList<Polynomial> L;
  _fcn = GBGlobals::s_factControls().push_back(fc);
  _srn = GBGlobals::s_polynomials().push_back(L);
  FactControl & FactB = TheFactBase();
  d_give_p = new FCGiveNumber(FactB); 
  RECORDHERE(_bin = new UnifierBin(FactB);)
  RECORDHERE(_workHorse  = new MoraWorkHorse(FactB,*d_give_p,*_bin);)
  RECORDHERE(d_gen_p = new PDGenerator(FactB,_bin);)
};

MngrSuper::~MngrSuper() {
// Tell the code that it can have these two "slots" back.
  RECORDHERE(delete _workHorse;)
  RECORDHERE(delete _bin;)
  RECORDHERE(delete d_gen_p;)
  GBGlobals::s_factControls().makeHole(_fcn);
  GBGlobals::s_polynomials().makeHole(_srn);
};

void MngrSuper::count_down(int n) {
  if(d_last_unifier_bin_size==d_unifierbin_initial_size) {
      GBStream << d_last_unifier_bin_size;
      --d_last_unifier_bin_size;
  };
  while(d_last_unifier_bin_size>n) {
    GBStream << ',' << d_last_unifier_bin_size;
    --d_last_unifier_bin_size;
  };
};

void MngrSuper::reorder(bool n) const {
  _bin->reorder(n);
};

void MngrSuper::OneStep(int iterationNumber) {
  _workHorse->doAtStartOfStep();
  d_gen_p->fillForUnknownReason();
  OneStepNoPrep(iterationNumber);
};

void MngrSuper::OneStepNoPrep(int iterationNumber) {
GBStream << "Full output forced.\n";
UserOptions::s_SelectionOutputMethod = 1;
UserOptions::s_supressAllCOutput=false;
  Match match;
  bool foundSomething = false;
  const int binSize = _bin->size();
  backspacer back(GBStream,binSize,-UserOptions::s_SelectionOutputMethod);
  if(!UserOptions::s_supressAllCOutput) {
    GBStream << "\n\nThere are n pairs to match where n is ";
    if(UserOptions::s_SelectionOutputMethod) {
      GBStream << binSize << "    ";
    } else {
      GBStream << "The following numbers indicate how many pairs still "
               << "need to be computed for this iteration.\n";
      GBStream << binSize;
    }
  }
  d_last_unifier_bin_size = binSize;
  d_unifierbin_initial_size = binSize;
#if 1
  while(d_gen_p->getNext(match)) {
    if(_workHorse->addMatches(match,
          d_gen_p->first_rule(),d_gen_p->first_id().d_data,
          d_gen_p->second_rule(),d_gen_p->second_id().d_data,  
          iterationNumber))  foundSomething = true;
    if(!UserOptions::s_supressAllCOutput) count_down(_bin->size());
  };
  if(!UserOptions::s_supressAllCOutput) count_down(_bin->size());
#endif
  ForceCleanUpBasis(iterationNumber);
  if(!UserOptions::s_SelectionOutputMethod) {
    back.clear();
  }
  _finished = ! foundSomething;
}

void MngrSuper::ManySteps(bool continueQ) {
   if(!continueQ) _step = 1;
   cleanIfNecessary(_step);
   while((!d_gen_p->empty())&&_step<=_numberOfIterations) {
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
  errorc(__LINE__);
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
  _workHorse->CleanUpBasis(iterationNumber);
#if 0
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
   };
   G.removeDuplicates();
   Polynomial f, f1;
   PDReduction reducer(FactB);
   reducer.tipReduction(d_tipReduction);
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
       reducer.addFact(*w);
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
       reducer.remove(SPIID(num));
       reducer.reduce(f,f1);
       if(f1==f) {
         const set<SPIID> & S = 
            _currentRules->allPossibleReductionNumbers().SET();
         int len = S.size();
         set<SPIID>::const_iterator ww = S.begin();
         for(int k=1;k<=len;++k,++ww) {
           FactB.markDone(num,(*ww).d_data);
         }
         reducer.addFact(SPIID(num));
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
           reducer.addFact(numb);
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
#endif
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
    errorc(__LINE__);
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
    errorc(__LINE__);
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
  const set<int> & S = h.reductions().impl().d_data;
  const int sz = S.size();
  set<int>::const_iterator w =  S.begin();
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

void MngrSuper::errorh(int n) { DBGH(n); };

void MngrSuper::errorc(int n) { DBGC(n); };
#endif
