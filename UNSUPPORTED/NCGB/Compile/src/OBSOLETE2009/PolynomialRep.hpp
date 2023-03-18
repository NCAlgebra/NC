// (c) Mark Stankus 1999
// PolynomialRep.hpp

#ifndef INCLUDED_POLYNOMIALREP_H
#define INCLUDED_POLYNOMIALREP_H

#include "ChoicePolynomial.hpp"
#ifdef USE_POLYNOMIAL_NN
#include "Term.hpp"
#include "Copy.hpp"
#include "ByAdmissible.hpp"
class MyOstream;

class PolynomialRep {
  void error1();
protected:
  Copy<Term> d_term;
  bool d_negate;
  void printLead() const;
public:
  PolynomialRep(const Copy<Term> & x);
  PolynomialRep(const Term & x);
  virtual ~PolynomialRep() = 0;
  const Term & term() const;
  const Copy<Term> & copyterm() const;
  // Returns true if the new coefficient is nonzero.
  bool addCoefficient(const Field & f);
  bool valid() const;
  // removes the tip. 
  // if there is no tip, then the routine error1 is called.
  // if removing the tip results in the zero polynomial, false is returned.
  // otherwise true is returned.
  bool removeTip();
  void negate();
  virtual PolynomialRep * clone() const = 0;
  virtual void print() const = 0;
private:
  virtual bool vRemoveTip() = 0;
};

MyOstream & operator<<(MyOstream &,const PolynomialRep & x);

class PolynomialRepCompare {
  ByAdmissible d_compare;
public:
  PolynomialRepCompare(const AdmissibleOrder & order) : d_compare(order) {};
  bool operator()(PolynomialRep * p,PolynomialRep * q) const {
    if(!p->copyterm().isValid()) DBG();
    if(!q->copyterm().isValid()) DBG();
    return d_compare(q->term().MonomialPart(),p->term().MonomialPart());
  };    
};    
#endif
#endif
