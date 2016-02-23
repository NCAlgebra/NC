// (c) Mark Stankus 1999
// AdmRuleSet.c

#include "AdmRuleSet.hpp"
#include "vcpp.hpp"
#include "GBStream.hpp"


AdmRuleSet::~AdmRuleSet() {};

RuleSet * AdmRuleSet::clone() const {
  return new AdmRuleSet(d_ord,d_adm_set);
};

void AdmRuleSet::insert(const RuleID & x) {
GBStream << "3b r is " << x << '\n';
  d_adm_set.insert(x);
GBStream << "3c r is " << x << '\n';
}

void AdmRuleSet::print(MyOstream & os) const {
  const set<RuleID,AdmRuleIDCompare> & X = ADMSET();
  typedef set<RuleID,AdmRuleIDCompare>::const_iterator SI;
  SI w = X.begin(), e = X.end();
  while(w!=e){
    const RuleID & rid = *w;
    os << "#" << rid.number() << ' ' << rid.poly() << '\n';
    ++w;
  };
};
