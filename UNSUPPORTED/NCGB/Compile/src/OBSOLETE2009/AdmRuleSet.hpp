// (c) Mark Stankus 1999
// AdmRuleSet.h

#ifndef INCLUDED_ADMRULESET_H
#define INCLUDED_ADMRULESET_H

#include "RuleSet.hpp"
#include "RuleID.hpp"
#include "Choice.hpp"
#include "AdmRuleIDCompare.hpp"
// #pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#include "vcpp.hpp"
class AdmissibleOrder;

class AdmRuleSet : public RuleSet {
  set<RuleID,AdmRuleIDCompare> d_adm_set;
  const AdmissibleOrder & d_ord;
public:
  AdmRuleSet(const AdmissibleOrder & ord) : 
      d_adm_set(AdmRuleIDCompare(ord)), d_ord(ord) {};
  AdmRuleSet(const AdmissibleOrder & ord,
      const set<RuleID,AdmRuleIDCompare> & S) : 
      d_adm_set(S), d_ord(ord) {};
  virtual ~AdmRuleSet();
  virtual void insert(const RuleID &); 
  void remove(const RuleID & x) {
    set<RuleID,AdmRuleIDCompare>::iterator w = d_adm_set.find(x); 
    if(w!=d_adm_set.end()) {
      d_adm_set.erase(w); 
    };
  };
  void remove(set<RuleID,AdmRuleIDCompare>::iterator w) {
    d_adm_set.erase(w); 
  };
  virtual RuleSet * clone() const;
  virtual void print(MyOstream &) const;
  const set<RuleID,AdmRuleIDCompare> & ADMSET() const { return d_adm_set;};
};
#endif
