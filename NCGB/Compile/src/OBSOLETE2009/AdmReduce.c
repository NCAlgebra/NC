// (c) Mark Stankus 1999
// AdmReduce.c

#include "AdmReduce.hpp"
#include "MatcherMonomial.hpp"

AdmReduce::~AdmReduce(){};

History * AdmReduce::history() const {
  return (History *) 0;
};

void AdmReduce::insert(const RuleID & x) {
  d_rules.insert(x);
};

void AdmReduce::remove(const RuleID & x) {
  d_rules.remove(x);
};

bool AdmReduce::reduce(Polynomial & x) const {
  MatcherMonomial matcher;
  bool result = false;
  if(!x.zero()) {
    bool changed = true;
    Polynomial toadd;  
    while(changed) {
      changed = false;
      Term t(*x.begin());
      typedef set<RuleID,AdmRuleIDCompare> SET;
      const SET & X = d_rules.ADMSET();
      SET::const_iterator w = X.begin(), e = X.end();
      while(w!=e) {
        const RuleID & id = *w;
        const Polynomial & pol = id.poly();
        const Monomial & mon = pol.tipMonomial();
        if(matcher.matchExists(mon,t.MonomialPart())) {
          changed = true;
          toadd.doubleProduct(
             -t.CoefficientPart(),matcher.matchIs().const_left1(),
             pol,
             matcher.matchIs().const_right1()
          );
          result = true;
          x += toadd;
          w = X.begin();
          break;
        };
        ++w;
      };
    };
  };
  return result;
};

void AdmReduce::print(MyOstream & os) const {
  d_rules.print(os);
};
