// Mark Stankus 1999 (c)
// GBLoop.cpp

#include "GBLoop.hpp"
#include "GiveNumber.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"
#include "GroebnerRule.hpp"
#include "Polynomial.hpp"
#include "BroadCast.hpp"
#include "Reduction.hpp"
#include "PolynomialData.hpp"
#include "PolySource.hpp"
#include "SFSGExtra.hpp"

class Tag;

void GBLoop(PolySource & ps,Tag & ps_tag,
            Reduction & reduce,Tag * rules_tag,
            BroadCast & reportit,bool & foundSomething,
            GiveNumber & giveNumber) {
  Polynomial p;
  Tag * poly_tag_p = 0;
  GroebnerRule r;
  int num;
  ReductionHint hint;
  while(ps.getNext(p,hint,poly_tag_p,ps_tag)) {
    GBStream << "Processing " << p << '\n';
    reduce.reduce(p,hint,*rules_tag);
    if(!p.zero()) {
      foundSomething = true;
      num = giveNumber(p);
      PolynomialData data(p,num,poly_tag_p,rules_tag);
      reportit.broadcast(data);
    };
  };
};
