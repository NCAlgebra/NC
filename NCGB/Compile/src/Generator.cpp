// Generator.c

#include "Generator.hpp"
#include "Debug1.hpp"
#include "SPI.hpp"
#include "GBMatch.hpp"
#include "Monomial.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"

Generator::~Generator() {};

// SPI Specific
void Generator::insert(const SPI &) {
  errorc(__LINE__);
};

void Generator::insert(const SPIID &) {
  errorc(__LINE__);
};

void Generator::remove(const SPIID &) {
  errorc(__LINE__);
};

void Generator::remove(const SPIID &,const SPIID &) {
  errorc(__LINE__);
};

void Generator::remove(const SPIID &,list<SPI>&) {
  errorc(__LINE__);
};

bool Generator::getNext(SPI &) {
  errorc(__LINE__);
  return true;
};

// Match Specific
void Generator::insert(const Match &) {
  errorc(__LINE__);
};

void Generator::remove(int,list<Match>&) {
  errorc(__LINE__);
};

bool Generator::getNext(Match &) {
  errorc(__LINE__);
  return true;
};

// Polynomial Specific
bool Generator::getNext(Polynomial &) {
  errorc(__LINE__);
  return true;
};

// Polynomial and GBHistory Specific
bool Generator::getNext(Polynomial &,GBHistory &) {
  errorc(__LINE__);
  return true;
};

// SPI and Polynomial Specific
bool Generator::getNext(SPI &,Polynomial &) {
  errorc(__LINE__);
  return true;
};

// SPI and Polynomial and GBHistory Specific
bool Generator::getNext(SPI &,Polynomial &,GBHistory &) {
  errorc(__LINE__);
  return true;
};

// Match and Polynomial Specific
bool Generator::getNext(Match &,Polynomial &) {
  errorc(__LINE__);
  return true;
};

// Match and Polynomial and GBHistory Specific
bool Generator::getNext(Match &,Polynomial &,GBHistory &) {
  errorc(__LINE__);
  return true;
};

#if 0
void Generator::convert(const SPI & spi,Polynomial & result1) const {
  SPIID ID1(spi.leftID()), ID2(spi.rightID());
  const GroebnerRule & first = retrieve(ID1);
  const GroebnerRule & second = retrieve(ID2);
  Monomial tip1(first.LHS());
  Monomial tip2(second.LHS());
  Monomial right1, left2;
  int len1 = spi.overlapLength();
  MonomialIterator w1 = tip2.begin();
  for(int k=1;k<=len1;++k) { ++w1;};
  int max1 = tip2.numberOfFactors()-1;
  // The following line is for a faster run-time.
  right1.reserve(max1-len1+1);
  for(int i=len1;i<=max1;++i,++w1) {
    right1 *= (*w1);
  }
  MonomialIterator w2 = tip1.begin();
  int max2 = tip1.numberOfFactors() - len1;
  // The following line is for a faster run-time.
  left2.reserve(max2);
  for(i=0;i< max2;++i,++w2) {
    left2 *= (*w2);
  }
  helpConvert(first.RHS(),right1,left2,second.RHS(),result1);
};
#endif

#if 0
void Generator::helpConvert(const Polynomial & p1,const Monomial & onRight,
      const Monomial & onLeft,const Polynomial & p2,Polynomial & result) 
   const {
  result = p1;
  Polynomial temp(p2);
  result *= Term(onRight);
  temp.premultiply(onLeft);
  result -= temp;
};
#else 
 
#if 0 
#include "AdmissibleOrder.hpp"

void Generator::helpConvert(const Polynomial & p1,const Monomial & onRight,
      const Monomial & onLeft,const Polynomial & p2,Polynomial & result) const {
  AdmissibleOrder & ord = AdmissibleOrder::s_getCurrent();
  typedef PolynomialIterator PI;
  PI w1 = p1.begin(), w2 = p2.begin();
  int sz1 = p1.numberOfTerms();
  int sz2 = p2.numberOfTerms();
  Term t1,t2;
  if(sz1 && sz2) {
    t1 = *w1;
    t1 *= onRight;
    t2.assign(onLeft);
    t2 *= *w2;
    while(sz1 && sz2) {
      const Monomial & m1 = t1.MonomialPart();
      const Monomial & m2 = t1.MonomialPart();
      if(ord.monomialLess(m1,m2)) {
        result += t1;
        --sz1;++w1;
        t1 = *w1;
        t1 *= onRight;
      } else if(ord.monomialGreater(m1,m2)) {
        result += t2;
        --sz2;++w2;
        t2.assign(onLeft);
        t2 *= *w2;
      } else { 
        t1.Coefficient() += t2.Coefficient();
        if(t1.Coefficient().zero()) {
          --sz1;++w1;
          t1 = *w1;
          t1 *= onRight;
        };
        --sz2;++w2;
        t2.assign(onLeft);
        t2 *= *w2;
      }; 
    }; 
  } else if(sz1) {
    --sz1;++w1;
    t1 = *w1;
    t1 *= onRight;
  } else if(sz2) {
    --sz2;++w2;
    t2.assign(onLeft);
    t2 *= *w2;
  };
  while(sz1) {
    result += t1;
    --sz1;++w1;
    t1 = *w1;
    t1 *= onRight;
  };
  while(sz2) {
    result += t2;
    --sz2;++w2;
    t2.assign(onLeft);
    t2 *= onRight;
  };
};
#endif
#endif

void Generator::convert(const Match & match,const GroebnerRule & r1,
         const GroebnerRule & r2,Polynomial & result) const {
  result.doubleProduct(match.const_left1(),r1.RHS(),match.const_right1());
  Polynomial temp;
  temp.doubleProduct(match.const_left2(),r2.RHS(),match.const_right2());
  result -= temp;
};

void Generator::errorc(int n) { DBGC(n); };
