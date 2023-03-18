// SPIPoly.h

#ifndef INCLUDED_SPIPOLY_H
#define INCLUDED_SPIPOLY_H

#include "SPI.hpp"
#include "RecordHere.hpp"
#include "ComparisonExtended.hpp"
#include "Polynomial.hpp"
#include "OriginalFunctions.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
class Monomial;
class Field;

class SPIPoly {
  bool d_modifiable;
  pair<bool,SPI> d_spi;
  Polynomial * d_p;
public:
  SPIPoly(const SPI & spi,bool modifiable=false) 
         : d_modifiable(modifiable), d_spi(false,spi), d_p(0) {};
  SPIPoly(Polynomial * p,bool modifiable=false) 
         : d_modifiable(modifiable), d_spi(true,SPI()), d_p(p) {};
  ~SPIPoly() {
    if(SPIfinite()) {
      RECORDHERE(delete d_p;)
    } else {
      // nothing here 
    };
  };

  ComparisonExtended compareTo(SPIPoly * p) {
    ComparisonExtended result(ComparisonExtended::s_INCOMPARABLE);
    if(d_spi.second==p->d_spi.second) {
      result = ComparisonExtended::s_EQUIVALENT;
    } else if(d_spi.first) {
      if(p->d_spi.first) {
        result = ComparisonExtended::s_EQUIVALENT;
      } else {
        result = ComparisonExtended::s_LESS;
      };
    } else {
      if(p->d_spi.first || selectCompare(p->d_spi.second,d_spi.second)) {
        result = ComparisonExtended::s_GREATER;
      } else {
        result = ComparisonExtended::s_LESS;
      };
    }
    return result;
  };

  // accessors
  bool SPIfinite() const { return  !d_spi.first;};
  bool hasPolynomial() const { return !!d_p;};
  bool modifiable() const { return d_modifiable;};

  bool zero() const {
    if(!d_p) computePolynomial();
    return d_p->zero();
  };
  bool nonzero() const {
    if(!d_p) computePolynomial();
    return !d_p->zero();
  };
  const Field & LC() const {
    if(!d_p) computePolynomial();
    return d_p->tip().CoefficientPart();
  };
  const Monomial & LM() const {
    if(!d_p) computePolynomial();
    return d_p->tip().MonomialPart();
  };
  const Term & LT() const {
    if(!d_p) computePolynomial();
    return d_p->tip();
  };
  const Polynomial & polynomial() const {
    if(!d_p) computePolynomial();
    return *d_p;
  };
    

  // modifiers
  void computePolynomial() const {
    if(!d_p) {
      Polynomial * p = const_cast<Polynomial*>(d_p);
      RECORDHERE(p = new Polynomial(spolynomial(d_spi.second));)
    };
  };
  void modifiable(bool b) { d_modifiable = b;};
  void reduce(const Field &,const Monomial &,
              SPIPoly * const,const Monomial &);
};
#endif
