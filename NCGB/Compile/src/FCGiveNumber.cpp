// Mark Stankus 1999 (c)
// FCGiveNumber.c


#include "FCGiveNumber.hpp"
#include "FactControl.hpp"

FCGiveNumber::~FCGiveNumber() {};

int FCGiveNumber::operator()(const Polynomial & p) {
  GroebnerRule ru;
  ru.convertAssign(p);
  int num = d_fc.addFact(ru);
  return num;
};

const GroebnerRule & FCGiveNumber::fact(int num) const {
  return d_fc.fact(num);
};

GiveNumber * FCGiveNumber::clone() const {
  return new FCGiveNumber(d_fc);
};

const vector<int> & FCGiveNumber::perm_numbers() const {
  d_vec_p = new vector<int>;
  const GBList<int> & L = d_fc.indicesOfPermanentFacts();
  GBList<int>::const_iterator w = L.begin();
  const int sz = L.size();
  d_vec_p->reserve(sz);
  for(int i=1;i<=sz;++i,++w) {
    d_vec_p->push_back(*w);
  };
  return *d_vec_p;
};

void FCGiveNumber::setNotPerm(int n) {
  d_fc.unsetFactPermanent(n);
};

void FCGiveNumber::setPerm(int n) {
  d_fc.setFactPermanent(n);
};
