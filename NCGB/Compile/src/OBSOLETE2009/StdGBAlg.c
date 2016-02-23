// StdGBAlg.c

#include "StdGBAlg.hpp"
#include "History.hpp"
#include "Polynomial.hpp"
#include "Reduce.hpp"
#include "History.hpp"
#include "RuleSet.hpp"
#include "PolySource.hpp"
#include "RuleID.hpp"

StdGBAlg::~StdGBAlg() {};

bool StdGBAlg::perform() {
  ++d_iter;
  bool foundSomething = false;
  d_poly_source.fillForUnknownReason();
  Polynomial p;
  int n;
  while(d_poly_source.getNext(p)) {
    d_reduce.reduce(p);
    if(!p.zero()) {
      foundSomething = true;
      n  = d_rules.largestSoFar()+1;
      RuleID r(p,n);
      History * ptr = d_reduce.history();
      if(ptr) {
        ptr->index(n);
        d_histories.insert(ptr);
      };
      d_poly_source.insert(r);
      d_rules.insert(r);
      d_reduce.insert(r);
    };
  };
  return foundSomething;
};
