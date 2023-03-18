// Mark Stankus 1999 (c)
// TrieReduction.h

#ifndef INCLUDED_TRIEREDUCTION_H
#define INCLUDED_TRIEREDUCTION_H

#include "Trie.hpp"
#include "Reduction.hpp"

class TrieReduction : public Reduction {
  static void errorh(int);
  static void errorc(int);
  Trie & d_t;
public:
  TrieReduction(Trie & t)  : d_t(t) {};
  virtual ~TrieReduction();
  
  // Which rules can be used?
  virtual void clear();
  virtual void remove(const SPIID & x);
  virtual void addFact(const SPIID & x);

  // Which rules were used?
  virtual void  ClearReductionsUsed();
  virtual const SPIIDSet & ReductionsUsed() const;
  virtual const SPIIDSet & allPossibleReductionNumbers() const;

  // Type of reduction
  virtual void vTipReduction();

  // The functionality
  virtual void reduce(Polynomial &,ReductionHint &,const Tag &);
  
  // OLD
  virtual void reduce(const Polynomial &,Polynomial &);
  virtual void reduce(const GroebnerRule &,Polynomial &);
};
#endif
