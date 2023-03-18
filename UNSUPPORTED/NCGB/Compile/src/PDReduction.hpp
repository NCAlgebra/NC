// PDReduction.h

#ifndef INCLUDED_PDREDUCTION_H
#define INCLUDED_PDREDUCTION_H

#include "load_flags.hpp"
#include "Reduction.hpp"
#ifdef PDLOAD
#include "SPIIDSet.hpp"
#include "GBList.hpp"
class FactBase;
#ifndef INCLUDED_POLYNOMIAL_H
#include "Polynomial.hpp"
#endif
class Monomial;
class GiveNumber;

class PDReduction : public Reduction {
  static void errorh(int);
  static void errorc(int);
  PDReduction();
    // not implemented
  PDReduction(const PDReduction &);
    // not implemented
  void operator=(const PDReduction &);
    // not implemented
public:
  explicit PDReduction(GiveNumber& ptr);
  virtual ~PDReduction();

  virtual void clear();
  virtual void remove(const SPIID &);
  virtual void addFact(const SPIID&);

  virtual void ClearReductionsUsed();
  virtual const SPIIDSet & ReductionsUsed() const;
  virtual const SPIIDSet & allPossibleReductionNumbers() const;

  virtual void vTipReduction();

  virtual void reduce(Polynomial & ,ReductionHint &,const Tag&);
  // OLD
  virtual void reduce(const Polynomial & thePoly,Polynomial & result);
  virtual void reduce(const GroebnerRule & theRule,Polynomial & result);
private:
  // from outside world
  GiveNumber & d_give;

  SPIIDSet d_factnumbers;
  SPIIDSet d_reductionsUsed;

  void preFilledReduce(const Polynomial &,Polynomial &);
};
#endif 
#endif 
