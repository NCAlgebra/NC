// RuleIDSet.c

#include "RuleID.hpp"
#include "RuleIDSet.hpp"
#include "RuleIDSetImpl.hpp"
#include "RuleOrder.hpp"
#include "Debug1.hpp"

RuleIDSet::RuleIDSet()  : d_p(new RuleIDSetImpl), d_sz(0) {};

RuleIDSet::RuleIDSet(RuleOrder)  : d_p(new RuleIDSetImpl), d_sz(0) {};

RuleIDSet::RuleIDSet(const RuleIDSet & x)  : 
  d_p(new RuleIDSetImpl(x.d_p->d_data)),
  d_sz(x.d_sz) {};

void RuleIDSet::operator =(const RuleIDSet & x)  {
  if(this!=&x) {
    delete d_p;
    d_p = new RuleIDSetImpl(x.d_p->d_data);
    d_sz = x.d_sz;
  };
};

void RuleIDSet::clear() {
  d_p->clear();
}

bool RuleIDSet::operator==(const RuleIDSet & x) const {
  return d_p->d_data== x.d_p->d_data;
};
  
RuleIDSet::~RuleIDSet() {};

bool RuleIDSet::firstRuleID(RuleID & id) {
  bool result = !d_p->d_data.empty();
  if(result) {
    id = * d_p->d_data.begin();
  };
  return result;
};

bool RuleIDSet::nextRuleID(RuleID & id) {
  set<int>::iterator w = d_p->d_data.upper_bound(id.d_data);
  bool result = w!=d_p->d_data.end();
  if(result) {
    id.d_data = *w;
  };
  return result;
};

void RuleIDSet::insert(const RuleID & id) {
  if(d_p->d_data.insert(id.d_data).second) {
    ++d_sz;
  };
};

void RuleIDSet::remove(const RuleID & id) {
  set<int>::iterator w = d_p->d_data.find(id.d_data);
  if(w==d_p->d_data.end()) DBG();
  d_p->d_data.erase(w);
  --d_sz;
};
