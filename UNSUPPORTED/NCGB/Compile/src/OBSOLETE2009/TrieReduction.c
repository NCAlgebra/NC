// Mark Stankus 1999 (c)
// TrieReduction.c

#include "TrieReduction.hpp"

TrieReduction::~TrieReduction() {};
  
void TrieReduction::clear() {
  errorc(__LINE__);
};

void TrieReduction::remove(const SPIID & x) {
  errorc(__LINE__);
};

void TrieReduction::addFact(const SPIID & x) {
  errorc(__LINE__);
};

void  TrieReduction::ClearReductionsUsed() {
  errorc(__LINE__);
};

const SPIIDSet & TrieReduction::ReductionsUsed() const {
  errorc(__LINE__);
};

const SPIIDSet & TrieReduction::allPossibleReductionNumbers() const {
  errorc(__LINE__);
  return *(const SPIIDSet *)0;
};

void TrieReduction::vTipReduction() {
  errorc(__LINE__);
};

void TrieReduction::reduce(Polynomial &,ReductionHint &,const Tag &) {
  errorc(__LINE__);
};
  
void TrieReduction::reduce(const Polynomial &,Polynomial &) {
  errorc(__LINE__);
};

void TrieReduction::reduce(const GroebnerRule &,Polynomial &) {
  errorc(__LINE__);
};

void TrieReduction::errorh(int n) { DBGH(n); };

void TrieReduction::errorc(int n) { DBGC(n); };
