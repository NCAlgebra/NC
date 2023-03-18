// SPIPoly.c

#include "SPIPoly.hpp"
#include "Term.hpp"

void SPIPoly::reduce(const Field & f,const Monomial & alpha,
                     SPIPoly * const q,const Monomial &beta) {
#if 0 
  computePolynomial();
  q->computePolynomial();
  d_p->Removetip();
  Term t1(f,alpha);
  Polynomial temp;
  temp = t1;
  temp *= q->polynomial();
  Term t2(beta);
  temp *= t2;
  (*d_p) -= temp;
#else
  DBG();
#endif
}; 
