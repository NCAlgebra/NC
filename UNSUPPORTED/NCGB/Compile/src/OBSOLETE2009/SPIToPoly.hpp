// Mark Stankus 1999 (c)
// SPIToPoly.nwh

#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "SPI.hpp"
#include <list.h>
#include <pair.h>

class MatchToPoly {
  list<Polynomial> & d_L;
  const GiveNumber & d_give;
  Polynomial d_p;
public:
  SPIToPoly(list<Poly> & L,const GiveNumber & give) : d_L(L), d_give(give) {};
  void operator()(const SPI & x) const {
    x.spolynomial(d_p);
    if(!d_p.zero()) d_L.push_back(d_p);
  };
};
#endif
