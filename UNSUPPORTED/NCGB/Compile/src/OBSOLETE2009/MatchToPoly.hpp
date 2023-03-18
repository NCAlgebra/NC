// Mark Stankus 1999 (c)
// MatchToPoly.nwh

#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "GBMatch.hpp"
#include <list.h>
#include <pair.h>

class MatchToPoly {
  list<Polynomial> & d_L;
  const GiveNumber & d_give;
  pair<int,int> d_numbers;
  Polynomial d_p;
public:
  MatchToPoly(list<Poly> & L,const GiveNumber & give,
      pair<int,int> & numbers) : d_L(L), d_give(give), d_numbers(numbers) {};
  void assign(pair<int,int> & numbers) {
    d_numbers = numbers;
  };
  void operator()(const Match & m) const {
    const GroebnerRule & rule1 = d_give.fact(d_numbers.first);
    const GroebnerRule & rule2 = d_give.fact(d_numbers.second);
    d_p.doubleProduct(m.const_left1(),
                      rule1.RHS(),
                      m.const_right1());
    Polynomial x;
    x.doubleProduct(m.const_left2(),
                    rule2.RHS(),
                    m.const_right2());
    d_p -= x;
    if(!d_p.zero()) d_L.push_back(d_p);
  };
};
#endif
