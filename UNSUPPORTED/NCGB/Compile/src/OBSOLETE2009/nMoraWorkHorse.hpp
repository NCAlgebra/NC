// MoraWorkHorse.h

#ifndef INCLUDED_MORAWORKHORSE_H
#define INCLUDED_MORAWORKHORSE_H

#include "load_flags.hpp"
#ifdef PDLOAD
#include "PDReduction.hpp"
#ifndef INCLUDED_GBMATCH_H
#include "GBMatch.hpp"
#endif
#include "FactControl.hpp"
class UnifierBin;
class MLex;
class GroebnerRule;

class MoraWorkHorse {
  MoraWorkHorse();
    // not implemented
  MoraWorkHorse(const MoraWorkHorse &);
    // not implemented
  void operator=(const MoraWorkHorse &);
    // not implemented
public:
   typedef Polynomial Given;
public:
  MoraWorkHorse(FactControl &, UnifierBin &);
  ~MoraWorkHorse(){};

  // process matches
  bool processFacts(
       const GBList<Match> & aListOfFacts,
       const GroebnerRule & aRule,int a,
       const GroebnerRule & bRule,int b,
       int iterationNumber);
  // Fill reduction array
  void doAtStartOfStep();
  
  // clean up basis function
  void CleanUpBasis(int iterationNumber);
 
  // the effect of the call is appending to result
  void spolynomial(
     const Match & aMatch,
     const GroebnerRule & rule1,int a,
     const GroebnerRule & rule2,int b,
     GBList<Polynomial> & result) const;
  bool addMatches(
       const Match & aMatch,
       const GroebnerRule & rule1,int a,
       const GroebnerRule & rule2,int b,
       int iterationNumber);
private:
  // from the outside world
  FactControl & _factBase;

  PDReduction _currentRules;
  UnifierBin & _bin;
};

#endif
#endif
