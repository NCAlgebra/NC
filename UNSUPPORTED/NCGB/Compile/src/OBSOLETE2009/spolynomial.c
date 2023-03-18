// spolynomial.c

#include "spolynomial.hpp"

#ifndef INCLUDED_SPI_H
#include "SPI.hpp"
#endif
#include "FactBase.hpp"
#ifndef INCLUDED_GROEBNERRULE_H
#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
#endif
#ifndef INCLUDED_TIMINGRECORDER_H
#include "TimingRecorder.hpp"
#endif

Polynomial spolynomial(const SPI & spi,const FactBase & fc,TimingRecorder * timers) {
  if(timers) {
    timers->start(s_spolynomialsTiming);
  };
  const GroebnerRule & first = fc.rule(spi.leftID());
  const GroebnerRule & second = fc.rule(spi.rightID());
  Monomial tip1(first.LHS());
  Monomial tip2(second.LHS());
  Monomial right1, left2, one;
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
  Term ONE(one);
#if 0
  Monomial check1(tip1);
  check1 *= right1; 
  Monomial check2(left2);
  check2 *= tip1;
  if(check1!=check2) {
    DBG();
  };
#endif
  Polynomial result1(first.RHS());
  Polynomial result2(second.RHS());
  result1 *= Term(right1);
  result2.premultiply(Term(left2));
  result1 -= result2;
  if(timers) {
    timers->printpause("spolynomial Timing:",s_spolynomialsTiming);
  };
  return result1;
};
