// MLex.h

#ifndef INCLUDED_MLEX_H
#define INCLUDED_MLEX_H

#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
#include "AdmWithLevels.hpp"
#include "ComparisonExtended.hpp"
#include "Choice.hpp"
#ifndef INCLUDED_VECTOR_H
#define INCLUDED_VECTOR_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#endif
#include "vcpp.hpp"

class MLex : public AdmWithLevels {
  
    // not implemented
  void operator=(const MLex &);
    // not implemented
public:
  MLex();
  explicit MLex(const vector<vector<Variable> > &);
  MLex(const MLex & x);
  virtual ~MLex();
   
  // VIRTUAL FUNCTIONS
  virtual bool verify(const GroebnerRule & r) const;
  virtual bool verify(const Polynomial &) const;
  virtual bool monomialLess(const Monomial &,const Monomial &) const;
  virtual AdmissibleOrder * clone() const;
  virtual void ClearOrder();
  virtual void PrintOrder(MyOstream & os) const;
  static const int s_ID;
};
#endif 
