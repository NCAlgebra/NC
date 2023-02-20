// Mark Stankus 1999 (c)
// Wreath.h

#ifndef INCLUDED_WREATH_H
#define INCLUDED_WREATH_H

class GroebnerRule;
class Polynomial;
#include "Variable.hpp"
#include "AdmWithLevels.hpp"
#include "ComparisonExtended.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"

class Wreath : public AdmWithLevels {
  Wreath();
    // not implemented
  void operator=(const Wreath &);
    // not implemented
  vector<AdmissibleOrder *> d_ords;
public:
  explicit Wreath(const vector<vector<Variable> > &,
                  vector<AdmissibleOrder *> d_ords);
  Wreath(const Wreath & x);
  virtual ~Wreath();
   
  // VIRTUAL FUNCTIONS
  virtual bool verify(const GroebnerRule & r) const;
  virtual bool verify(const Polynomial &) const;
  virtual void convert(const Polynomial &,GroebnerRule &) const;
  virtual bool monomialLess(const Monomial &,const Monomial &) const;
  virtual AdmissibleOrder * clone() const;
  virtual void ClearOrder();
  virtual void PrintOrder(MyOstream & ) const;
   
  Monomial grabAtLevel(int,const Monomial &) const;

  // OTHER FUNCTIONS
  static const int s_ID;
  static char * s_seperator;
};
#endif 
