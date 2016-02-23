// (c) Mark Stankus 1999
// Licencse: Based strongly on the code of Ben Keller July 1997
// SPI.c

#include "SPI.hpp"
#include "Ownership.hpp"

void SPI::prspolynomial(Polynomial & x) const {
#if 1
  DBG();
#else
  const Polynomial & poly1 = d_left.poly();
  const Polynomial & poly2 = d_right.poly();
  const Monomial & alphabeta = poly1.tip().MonomialPart();
  const Monomial & betatau   = poly2.tip().MonomialPart();
  int alphasz = alphabeta.numberOfFactors() - d_len;
  int tausz   = betatau.numberOfFactors() - d_len;
  Monomial alpha,tau;
  alpha.copyFirst(alphabeta,alphasz);
  tau.copyLast(betatau,tausz);
  Monomial is_one;
  x.doubleProduct(is_one,poly1,tau);
  Polynomial y;
  y.rightProduct(alpha,poly2,is_one);
  x -= y;
  SPI * alias = const_cast<SPI*>(this);
  alias->d_computed = true;
#endif
}; 
