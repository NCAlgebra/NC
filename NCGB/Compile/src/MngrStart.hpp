//  MngrStart.h

#ifndef INCLUDED_MNGRSTART_H
#define INCLUDED_MNGRSTART_H

class FactBase;
#ifndef INCLUDED_POLYNOMIAL_H
#include "Polynomial.hpp"
#endif
#include "SPIID.hpp"
#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifndef INCLUDED_LIST_H
#define INCLUDED_LIST_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#endif
#ifndef INCLUDED_PAIR_H
#define INCLUDED_PAIR_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#endif
class GBHistory;
class GroebnerRule;
#include "vcpp.hpp"

class MngrStart {
  MngrStart(const MngrStart &);
    // not implemented
  void operator=(const MngrStart &);
    // not implemented
protected:
  MngrStart();
public:
  virtual ~MngrStart(); 

  // ACCESSORS/ MANIPULATORS 
  int numberOfIterations() const { 
    return _numberOfIterations;
  };
  void numberOfIterations(int theNumber) { 
    _numberOfIterations = theNumber;
  };
  void CleanUpBasis(bool doItOrNot) {  
    _cleanFlag = doItOrNot;
  };
  bool GetCleanUpBasis() const {
    return _cleanFlag;
  };
  bool foundBasis() const {
    return _finished;
  };
  // Knowns and unknowns stuff
  void emptyDeselects() {
    Deselected.clear();
  };
  void addDeselect(int n) {
    warning1(n);
    Deselected.push_back(n);
  };
  void setCutOffFlag(bool yn) {
    _cutOffs = yn;
  };
  void setMinNumberCutOff(int min) {
    _minNumber = min;
  };
  void setSumNumberCutOff(int sum) {
    _sumNumber = sum;
  };

  // VIRTUAL FUNCTIONS
  virtual const FactBase & factbase() const = 0;
  virtual const list<Polynomial> & startingRelations() const = 0;
  virtual void reorder(bool n) const  = 0;
  virtual void run() = 0;
  virtual void run(Polynomial &) = 0;
  virtual void continueRun() = 0;
  virtual void ForceCleanUpBasis(int iter) = 0;
  virtual const GroebnerRule & rule(int n) const = 0;
  virtual int lowvalue() const = 0;
  virtual int numberOfFacts() const = 0;
  virtual pair<int*,int> idsForPartialGBRules() const = 0;
  virtual int iterationNumber(int) const = 0;
#if 0
  virtual pair<SPIID *,int> reductionsUsed(int) const = 0;
#endif
  virtual int leftIDForSpolynomial(int) const = 0;
  virtual int rightIDForSpolynomial(int) const = 0;
  virtual list<Polynomial> partialBasis() const = 0;
  virtual Polynomial partialBasis(int n) const = 0;
  virtual void partialBasis(int n,Polynomial & aPolynomial) const = 0;
  virtual void debug() const = 0;

  void DefaultOptions();
protected:
  int  _numberOfIterations;
    // Default 1
  bool _cleanFlag;
    // Default true
  bool _finished;
    // Default false
  bool _cutOffs;
    // Default false
  int _minNumber;
    // Default 0
  int _sumNumber;
    // Default 0
  GBVector<int> Deselected;
  void warning1(int) const;
};
#endif /* MngrStart_h */
