// (c) Mark Stankus 1999
// TriePolySource.c

#include "TriePolySource.hpp"
#include "Debug1.hpp"

TriePolySource::~TriePolySource() {};

bool TriePolySource::getNext(Polynomial &,ReductionHint &,Tag *,Tag &) {
  errorc(__LINE__);
};

void TriePolySource::insert(const RuleID &) {
  errorc(__LINE__);
};

void TriePolySource::insert(const PolynomialData &) {
  errorc(__LINE__);
};

void TriePolySource::remove(const RuleID &) {
  errorc(__LINE__);
};

void TriePolySource::fillForUnknownReason() {
  errorc(__LINE__);
};

void TriePolySource::print(MyOstream &) const {
  errorc(__LINE__);
};

void TriePolySource::setPerm(int) {
  errorc(__LINE__);
};

void TriePolySource::setNotPerm(int) {
  errorc(__LINE__);
};

void TriePolySource::errorh(int n) { DBGH(n); };

void TriePolySource::errorc(int n) { DBGC(n); };
