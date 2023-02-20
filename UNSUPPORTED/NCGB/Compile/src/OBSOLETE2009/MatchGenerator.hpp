// MatchGenerator.h

#ifndef INCLUDED_MATCHGENERATOR_H
#define INCLUDED_MATCHGENERATOR_H

#include "GBMatch.hpp"
#include "UnifierBin.hpp"
#include "FactControl.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

class MatchGenerator {
  list<Match> d_reserve;
  pair<int,int> d_indices;
  GroebnerRule d_first, d_second; 
  FactControl & d_fc;
  UnifierBin d_bin;
  void prepareList();
public:
  MatchGenerator(FactControl & fc) : d_fc(fc), d_bin(fc) {};
  ~MatchGenerator() {};
  bool getMatchIteration(Match & m);
  bool fillForNextIteration();
  bool empty();
};
#endif
