// Mark Stankus 1999 (c)
// RuleInformation.h

#ifndef INCLUDED_RULEINFORMATION_H
#define INCLUDED_RULEINFORMATION_H

#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"
#include "GroebnerRule.hpp"
#include "Utilities.hpp"
#include "Debug1.hpp"

using namespace std;

class RuleInformation {
  mutable int d_degree;
  mutable int d_leafcount;
  mutable int d_variablecount;
  mutable int d_multiplicity;
  mutable int d_tipNumber;
  mutable vector<int> d_variablesLHS;
  mutable vector<int> d_firstoccuranceLHS;
  mutable vector<int> d_DoubleCounts;
  const GroebnerRule & d_r;
  RuleInformation();
    // not implemented
  void operator=(const RuleInformation &); 
    // not implemented
  bool dividesDoubleCount(const vector<int> & small,const vector<int> & big) const;
public:
  RuleInformation(const GroebnerRule & r) : 
     d_degree(-1), d_leafcount(-1), d_variablecount(-1),
     d_multiplicity(-1), d_variablesLHS(), d_firstoccuranceLHS(),
     d_r(r) {};
  RuleInformation(const RuleInformation & x) : 
     d_degree(x.d_degree), d_leafcount(x.d_leafcount), 
     d_variablecount(x.d_variablecount), d_multiplicity(x.d_multiplicity), 
     d_variablesLHS(x.d_variablesLHS), 
     d_firstoccuranceLHS(x.d_firstoccuranceLHS), d_r(x.d_r) {};
  ~RuleInformation(){};
  const GroebnerRule & rule() const {
    return d_r;
  };
    // Returns true if d_r.LHS() divides x.d_r.LHS() 
    //     and sets front and back so that
    //      front**fact(r).LHS()**back === fact(s).LHS()
  bool divides(const RuleInformation & ri,Monomial & front,Monomial & back) const;
  int degree() const {
    if(d_degree==-1) {
      d_degree = Utilities::s_computeDegree(d_r);
    };
    return d_degree;
  };
  int multiplicity() const {
    if(d_multiplicity==-1) {
      d_multiplicity = Utilities::s_computeMultiplicity(d_r);
    };
    return d_multiplicity;
  };
  int leafcount() const {
    if(d_leafcount==-1) {
      d_leafcount = Utilities::s_computeLeafCount(d_r);
    };
    return d_leafcount;
  };
  int tipNumber() const {
    if(d_tipNumber==-1) {
      d_tipNumber = Utilities::s_computeTipNumber(d_r);
    };
    return d_tipNumber;
  };
  int variablecount() const {
    if(d_variablecount==-1) {
      d_variablecount = Utilities::s_computeVariableCount(d_r);
    };
    return d_variablecount;
  };
  const vector<int> & variablecounts() const {
    if(d_variablesLHS.empty()) {
      Utilities::s_computeVariablesLHS(d_variablesLHS,d_r);
    };
    return d_variablesLHS;
  };
  const vector<int> & firstoccurance() const {
    if(d_firstoccuranceLHS.empty()) {
      Utilities::s_computeFirstOccuranceLHS(d_firstoccuranceLHS,d_r);
    };
    return d_firstoccuranceLHS;
  };
  const vector<int> & variableDoubleCounts() const {
    if(d_DoubleCounts.empty()) {
      Utilities::s_computeDoubleCounts(d_DoubleCounts,d_r);
    };
    return d_DoubleCounts;
  };
  static int s_primes[100];
  static int s_number_primes;
};
#endif
