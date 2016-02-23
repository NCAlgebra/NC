// Mark Stankus 1999 (c)
// SFSGReduction.h

#ifndef INCLUDED_SFSGREDUCTION_H
#define INCLUDED_SFSGREDUCTION_H

#include "Reduction.hpp"

class GroebnerRule;
class Polynomial;
class SPIIDSet;
#include "SPIID.hpp"
#include "Copy.hpp"
#include "BiMap.hpp"
#include "Monomial.hpp"
#include "Polynomial.hpp"
#include "SFSGExtra.hpp"
#include "ByAdmissible.hpp"

class SFSGReduction : public Reduction {
  SFSGRules d_M;
public:
  SFSGReduction(BIMAP & M) : d_M(M) {};
  virtual ~SFSGReduction();
  
  // Which rules can be used?
  virtual void clear();
  virtual void remove(const SPIID & x);
  virtual void addFact(const SPIID & x);

  // Which rules were used?
  virtual void  ClearReductionsUsed();
  virtual const SPIIDSet & ReductionsUsed() const;
  virtual const SPIIDSet & allPossibleReductionNumbers() const;

  virtual void vTipReduction();

  // The functionality
  virtual void reduce(Polynomial &,ReductionHint & hint,const Tag &);
  
  // OLD
  virtual void reduce(const Polynomial &,Polynomial &);
  virtual void reduce(const GroebnerRule &,Polynomial &);
};
#endif 
