// Mark Stankus 1999 (c)
// Lean.cpp

#include "Lean.hpp"
#include "GiveNumber.hpp"
#include "GroebnerRule.hpp"
#include "Polynomial.hpp"
#include "BroadCast.hpp"
#include "Reduction.hpp"
#include "PolynomialData.hpp"
#include "PolySource.hpp"
class Tag;

void Lean(AttainableMap<AlwaysTrue> &) {
};
void Lean(PolySource & ps,Tag & ps_tag,
            Reduction & reduce,Tag * rules_tag,
            BroadCast & reportit,bool & foundSomething,
            GiveNumber & giveNumber) {
  Polynomial p;
  Tag * poly_tag_p = 0;
  GroebnerRule r;
  int num;
  while(ps.getNext(p,poly_tag_p,ps_tag)) {
    reduce.reduce(p,*rules_tag);
    if(!p.zero()) {
      num = giveNumber(p);
      PolynomialData data(p,num,poly_tag_p,rules_tag);
      reportit.broadcast(data);
    };
  };
};
