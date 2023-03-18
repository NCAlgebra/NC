// FactBase.h

#ifndef INCLUDED_FACTBASE_H
#define INCLUDED_FACTBASE_H

class GroebnerRule;
class Monomial;
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"
#include "GroebnerRule.hpp"
#include "expandVector.hpp"
#include "Utilities.hpp"

using namespace std;

class FactBase {
protected:
  mutable vector<GroebnerRule *>  d_rules;
  int d_numberOfFacts;
  mutable int d_rules_sz;
private:
  mutable vector<int> d_degree;
  mutable vector<int> d_tipNumber;
  mutable vector<int> d_leafcount;
  mutable vector<int> d_variablecount;
  mutable vector<int> d_multiplicity;
  mutable vector<vector<int> > d_variablesLHS;
  mutable vector<vector<int> > d_firstoccuranceLHS;
public:
  FactBase() : d_numberOfFacts(0), d_rules_sz(0) {};
  virtual ~FactBase();
  void clearFactBase() {
    d_rules.erase(d_rules.begin(),d_rules.end());
    d_numberOfFacts = 0;
    d_rules_sz = 0;
    d_degree.erase(d_degree.begin(),d_degree.end());
    d_tipNumber.erase(d_tipNumber.begin(),d_tipNumber.end());
    d_leafcount.erase(d_leafcount.begin(),d_leafcount.end());
    d_variablecount.erase(d_variablecount.begin(),d_variablecount.end());
    d_multiplicity.erase(d_multiplicity.begin(),d_multiplicity.end());
    d_variablesLHS.erase(d_variablesLHS.begin(),d_variablesLHS.end());
    d_firstoccuranceLHS.erase(d_firstoccuranceLHS.begin(),
                              d_firstoccuranceLHS.end());
  };
  int numberOfFacts() const { return d_numberOfFacts;};
  const GroebnerRule & rule(int i) const {
    if(i>d_rules_sz) {
      d_rules.reserve(i+1);
      while(i>d_rules_sz) {
        d_rules.push_back((GroebnerRule *)0); 
        ++d_rules_sz;
      };
    };
    if(!d_rules[i-1]) {
      d_rules[i-1] = (GroebnerRule *)(&grabRule(i));
      d_rules_sz=i;
    };
    return * d_rules[i-1];
  };
  int degree(int i) const {
    if(i>(int)d_degree.size()) expandVector(d_degree,i,-1);
    int result = d_degree[i-1];
    if(result==-1) {
      result = Utilities::s_computeDegree(rule(i));
    };
    return result;
  };
  int multiplicity(int i) const {
    if(i>(int)d_multiplicity.size()) expandVector(d_multiplicity,i,-1);
    int result = d_multiplicity[i-1];
    if(result==-1) {
      result = Utilities::s_computeMultiplicity(rule(i));
    };
    return result;
  };
  int leafcount(int i) const {
    if(i>(int)d_leafcount.size()) expandVector(d_leafcount,i,-1);
    int result = d_leafcount[i-1];
    if(result==-1) {
      result = Utilities::s_computeLeafCount(rule(i));
    };
    return result;
  };
  int tipNumber(int i) const {
    if(i>(int)d_tipNumber.size()) expandVector(d_tipNumber,i,-1);
    int result = d_tipNumber[i-1];
    if(result==-1) {
      result = Utilities::s_computeTipNumber(rule(i));
    };
    return result;
  };
  int variablecount(int i) const {
    if(i>(int)d_variablecount.size()) expandVector(d_variablecount,i,-1);
    int result = d_variablecount[i-1];
    if(result==-1) {
      result = Utilities::s_computeVariableCount(rule(i));
    };
    return result;
  };
  const vector<int> & variablecounts(int i) const {
    vector<int> dummy;
    if(i>(int)d_variablesLHS.size()) expandVector(d_variablesLHS,i,dummy);
    vector<int> & V = d_variablesLHS[i-1];
    if(V.size()==0) {
      Utilities::s_computeVariablesLHS(V,rule(i));
    };
    return V;
  };
  const vector<int> & firstoccurance(int i) const {
    vector<int> dummy;
    if(i>(int)d_firstoccuranceLHS.size()) expandVector(d_firstoccuranceLHS,i,dummy);
    vector<int> & V = d_firstoccuranceLHS[i-1];
    if(V.size()==0) {
      Utilities::s_computeFirstOccuranceLHS(V,rule(i));
    };
    return V;
  };
  virtual const GroebnerRule & grabRule(int i) const = 0;
};
#endif
