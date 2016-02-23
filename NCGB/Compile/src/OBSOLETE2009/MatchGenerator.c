// MatchGenerator.c

#include "MatchGenerator.hpp"
#include "UserOptions.hpp"
#include "MatcherMonomial.hpp"

void MatchGenerator::prepareList() {
  while(d_reserve.empty() && !d_bin.iterationEmpty()) {
    d_indices = d_bin.nextPair();
    d_first = d_fc.rule(d_indices.first);
    d_second = d_fc.rule(d_indices.second);
    MatcherMonomial matcher;
    if(UserOptions::s_UseSubMatch) {
      matcher.subMatch(d_first.LHS(),d_indices.first,d_second.LHS(),
                       d_indices.second,d_reserve);
    };
    matcher.overlapMatch(d_first.LHS(),d_indices.first,d_second.LHS(),
                       d_indices.second,d_reserve);   
  };
};

bool MatchGenerator::getMatchIteration(Match & m) {
  prepareList();
  bool flag = !d_reserve.empty();
  if(flag) {
    m = d_reserve.front();
    d_reserve.pop_front();
  };
  return flag;
};

bool MatchGenerator::fillForNextIteration() {
  const int numFacts = d_fc.numberOfPermanentFacts();
  if(numFacts>0) {
    FactControl::InternalPermanentType::const_iterator w =
        d_fc.permanentBegin();
    int num;
    for(int i=1;i<=numFacts;++i,++w) {
      num = *w;
      d_bin.addNewNumber(num);
    }
  }
  d_bin.fillForNextIteration();
  return !d_bin.empty();
};

bool MatchGenerator::empty() {
  prepareList();
  return d_reserve.empty();
};
