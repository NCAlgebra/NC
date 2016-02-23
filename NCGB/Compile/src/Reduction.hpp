// Reduction.h

#ifndef INCLUDED_REDUCTION_H
#define INCLUDED_REDUCTION_H

class GroebnerRule;
class Polynomial;
class SPIIDSet;
#include "SPIID.hpp"
#include "Copy.hpp"
class Tag;
class ReductionHint;

class Reduction {
    // not implemented
  Reduction(const Reduction &);
    // not implemented
  void operator=(const Reduction &);
    // not implemented
  bool d_tip;
public:
  Reduction() : d_tip(false) {};
  virtual ~Reduction() = 0;
  
  // Which rules can be used?
  virtual void clear() = 0;
  virtual void remove(const SPIID & x) = 0;
  virtual void addFact(const SPIID & x) = 0;

  // Which rules were used?
  virtual void  ClearReductionsUsed() = 0;
  virtual const SPIIDSet & ReductionsUsed() const = 0;
  virtual const SPIIDSet & allPossibleReductionNumbers() const = 0;

  // Type of reduction
  virtual void vTipReduction() = 0;
  void tipReduction(bool x) {
    d_tip = x;
    vTipReduction();
  };
  bool tipReduction() const { 
    return d_tip;
  };

  // The functionality
  virtual void reduce(Polynomial &,ReductionHint &,const Tag &)= 0;
  
  // OLD
  virtual void reduce(const Polynomial &,Polynomial &) = 0;
  virtual void reduce(const GroebnerRule &,Polynomial &) = 0;
};
#endif 
