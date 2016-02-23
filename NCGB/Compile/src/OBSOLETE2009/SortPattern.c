// (c) Mark Stankus 1999
// SortPattern.cpp

#include "SortPattern.hpp"
#include "ByAdmissible.hpp"

void removePowers(const Monomial & m,Monomial & result) {
  if(m.numberOfFactors()!=0) {
    Variable v;
    result.setToOne();
    MonomialIterator w = m.begin(), e = m.end();
    while(w!=e) {
      if(v!=*w) {
        v = *w;
        result *= v;
      };
      ++w;
    };
  };
};

void SortPattern(const list<GroebnerRule> & L,BuildOutput & build,
         ByAdmissible & adm,list<RuleDisplayPart> & result) {
  map<Monomial,RuleDisplayPart*,ByAdmissible> xx(adm);
  typedef list<GroebnerRule>::const_iterator LRI;
  typedef list<RuleDisplayPart>::const_iterator LPI;
  LRI w = L.begin(), e = L.end();
  Monomial m;
  while(w!=e) {
    const GroebnerRule & rule = * w;
    removePowers(rule.LHS(),m);
    map<Monomial,RuleDisplayPart*>::iterator w = xx.find(m);
    if(w==xx.end()) {
      pair<Monomial,RuleDisplayPart*> pr(m,new RuleDisplayPart(build));
      pr.second->d_list.push_back(rule);
      xx.insert(pr);
    } else {
      (*w).second->d_list.push_back(rule);
    };
    ++w;
  };
  map<Monomial,RuleDisplayPart*>::iterator ww = xx.begin();
  map<Monomial,RuleDisplayPart*>::iterator ee = xx.end();
  while(ww!=ee) {
    result.push_back(*((*ww).second));
    delete (*ww).second;
    ++ww;
  };
};
