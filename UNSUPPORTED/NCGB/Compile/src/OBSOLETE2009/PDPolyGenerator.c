// PDPolyGenerator.c

#include "PDPolyGenerator.hpp"
#include "UserOptions.hpp"
#include "MatcherMonomial.hpp"

PDPolyGenerator::~PDPolyGenerator() {};

bool PDPolyGenerator::getPolynomialIteration(Polynomial & p,GBHistory & hist) {
  bool done = false;  
  bool flag = false;
  Polynomial parta,partb,q;
  Match match;
  while(!done) {
    done = d_matches.getMatchIteration(match);
    if(done) {
      parta.doubleProduct(match.left1,d_first.RHS(),match.right1);
      partb.doubleProduct(match.left2,d_second.RHS(),match.right2);
      q = parta;
      q -= partb;
      d_currentRules.reduce(q,p);
      done = !p.zero();
      if(done) {
        hist = GBHistory(d_indices.first,d_indices.second,
                         d_currentRules.ReductionsUsed());
        flag = true;
      };
    };
  };
  return flag;
};

bool PDPolyGenerator::fillForNextIteration() {
  d_currentRules.clearNumbers();
  const int numFacts = d_fc.numberOfPermanentFacts();
  if(numFacts>0) {
    FactControl::InternalPermanentType::const_iterator w =
        d_fc.permanentBegin();
    int num;
    for(int i=1;i<=numFacts;++i,++w) {
      num = *w;
      d_currentRules.addFactNumber(num);
    }
  }                  
  d_matches.fillForNextIteration();
  return !d_matches.empty();
};
