// (c) Mark Stankus 1999
// AdmPolySource.c

#include "AdmPolySource.hpp"
#include "PolynomialData.hpp"

AdmPolySource::~AdmPolySource() { errorc(__LINE__);};

AdmPolySource::AdmPolySource(const AdmissibleOrder & ord,
    const AdmRuleSet & rset) : PolySource(s_ID),  d_ord(ord), d_rset(ord) {
  const set<RuleID,AdmRuleIDCompare> & X = rset.ADMSET();
  set<RuleID,AdmRuleIDCompare>::const_iterator w= X.begin(), e = X.end();
  while(w!=e) {
    d_rset.insert(*w);
    ++w;
  };
}; 

void AdmPolySource::fillForUnknownReason() {};

bool AdmPolySource::getNext(Polynomial & x,Tag*,Tag&) {
  d_rset.print(GBStream);
  bool result = !d_rset.ADMSET().empty();
  if(result) {
    set<RuleID,AdmRuleIDCompare>::iterator w = d_rset.ADMSET().begin(); 
    x = (*w).poly(); 
    d_rset.remove(w); 
  };
  return result;
};

void AdmPolySource::insert(const RuleID & x) {
  d_rset.insert(x);
};

void AdmPolySource::insert(const PolynomialData & x) {
  RuleID y(x.d_p,x.d_number);
  d_rset.insert(y);
};

void AdmPolySource::remove(const RuleID & x) {
  d_rset.remove(x);
};

void AdmPolySource::print(MyOstream & os) const {
  d_rset.print(os);
};

void AdmPolySource::setPerm(int) {
  errorc(__LINE__);
};

void AdmPolySource::setNotPerm(int) {
  errorc(__LINE__);
};

#include "idValue.hpp"
const int AdmPolySource::s_ID = idValue("AdmPolySource::s_ID");

void AdmPolySource::errorh(int n) { DBGH(n); };

void AdmPolySource::errorc(int n) { DBGC(n); };
