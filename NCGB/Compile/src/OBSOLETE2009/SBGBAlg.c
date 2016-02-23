// SBGBAlg.c

#include "SBGBAlg.hpp"
#include "GBHistory.hpp"
#include "GroebnerRule.hpp"
#include "Polynomial.hpp"
#include "FactControl.hpp"
#include "Generator.hpp"
#include "Reduction.hpp"

SBGBAlg::~SBGBAlg() {};

bool SBGBAlg::perform() {
  typedef list<Polynomial>::iterator LI;
  LI w = d_L.begin(), e = d_L.end();
  Polynomial p;
  while(w!=e) {
    d_red.reduce(*w,p);
    if(p.zero()) {
     d_L.erase(w);
    } else {
     d_red.addFactNumber(SPIID());
     d_alg.addRelation(*w);
    };
    ++w;
  };
  return foundSomething;
};
